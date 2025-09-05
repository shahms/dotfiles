local function collect_on_attach()
  local self = debug.getinfo(1).source:match("^@(.*)$")
  if not self then return {} end
  local name = self:match("/lsp/([^/]*).lua$")
  if not name then return {} end
  local result = {}
  for _, v in ipairs(vim.api.nvim_get_runtime_file(('lsp/%s.lua'):format(name), true)) do
    if v == self then
      -- Stop reading files after we encounter our own path as subsequent paths will be merged by nvim.
      break
    end
    local on_attach = loadfile(v)().on_attach
    if on_attach then
      if vim.islist(on_attach) then
        result = vim.list_extend(result, on_attach)
      else
        table.insert(result, on_attach)
      end
    end
  end
  return result
end

local function gsplitlines(text)
  return text:gmatch("[^\n]+")
end
local function abspath(path)
  if vim.fs.abspath then
    return vim.fs.abspath(path)
  end
  if path:match("^/") then
    return path
  end
  return vim.fs.joinpath(vim.fn.getcwd(), path)
end
local function relpath(base, target)
  if vim.fs.relpath then
    return vim.fs.relpath(base, target)
  end
  if base == target then
    return "."
  end

  if not base:match("/$") then
    base = base .. "/"
  end
  if target:sub(1, base:len()) == base then
    return target:sub(base:len() + 1)
  end
  return nil
end

local function bazel_info(path, cb)
  vim.system({ "bazel", "info", "workspace", "execution_root" }, { text = true, cwd = vim.fs.dirname(path) },
    function(result)
      cb(vim.iter(gsplitlines(result.stdout)):fold({},
        function(acc, line)
          local key, value = line:match("%s*([^:]+): ([^\n]+)")
          acc[key] = value
          return acc
        end))
    end)
end

local function bazel_print_action(workspace, path, cb)
  local cmd = {
    "bazel",
    "print_action",
    "--nobuild",
    "--keep_going",
    "--compile_one_dependency",
    path,
  }
  vim.system(cmd, { text = true, cwd = workspace },
    function(result)
      cb(vim.iter(gsplitlines(result.stdout)):map(
        function(line)
          local arg = line:match('^%s*tool: (.+)') or line:match('^%s*compiler_option: (.*)')
          if arg then
            -- These are textproto-escaped strings, which are close enough to JSON for us.
            return vim.json.decode(arg)
          end
        end):totable()
      )
    end
  )
end

local function find_compile_command(path, cb)
  bazel_info(path,
    function(info)
      -- Obnoxiously, bazel print_action only works from the workspace root so we need to find a relative path.
      bazel_print_action(info.workspace, relpath(info.workspace, abspath(path)),
        function(command)
          cb({
            workingDirectory = info.execution_root,
            compilationCommand = command,
          })
        end
      )
    end
  )
end

local M = {}

function M.find_compile_command(path, cb)
  if cb then
    find_compile_command(path, cb)
  else
    local state = {}
    find_compile_command(path, function(command)
      state.command = command
    end)
    vim.wait(2 ^ 31, function()
      return state.command ~= nil
    end)
    return state.command
  end
end

function M.on_attach(client, bufnr)
  local bufpath = vim.api.nvim_buf_get_name(bufnr)
  M.find_compile_command(bufpath, function(command)
    client.notify("workspace/didChangeConfiguration", {
      settings = {
        compilationDatabaseChanges = {
          [bufpath] = command,
        },
      },
    })
  end)
end

return {
  -- The default configuration incorrectly binds to "proto".
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  -- TODO: use the on_attach handler from lsp-config as well.
  on_attach = vim.list_extend({ M.on_attach }, collect_on_attach()),
  cmd = {
    "clangd", "--log=error",
  },
}
