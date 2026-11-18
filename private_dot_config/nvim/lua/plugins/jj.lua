-- Files that `rev` adds or modifies, each with the hunks it changes.
-- Paths are relative to the repository root.
local function changed_files(rev)
  local output = require("jj.core.runner").execute(
    { "jj", "diff", "--git", "--color=never", "--context=0", "-r", rev },
    "Error getting diff"
  )
  if not output then
    return nil
  end
  local files, file, hunk = {}, nil, nil
  for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
    local path = line:match("^diff %-%-git a/.- b/(.*)$")
    if path then
      file, hunk = { path = path, hunks = {} }, nil
      table.insert(files, file)
    elseif file and line:match("^deleted file mode") then
      table.remove(files)
      file = nil
    elseif file then
      local start = line:match("^@@ %-%S+ %+(%d+)")
      if start then
        -- A pure deletion reports the line before it, possibly 0.
        hunk = { lnum = math.max(tonumber(start), 1) }
        table.insert(file.hunks, hunk)
      elseif hunk and (not hunk.text or (hunk.text:match("^%-") and line:match("^%+"))) then
        -- Prefer the first added line, which the buffer shows.
        hunk.text = line
      end
    end
  end
  return files
end

-- Deletes listed file buffers outside `keep`, sparing modified ones.
local function close_others(keep)
  local skipped = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" and name ~= "" and not keep[name] then
      if vim.bo[buf].modified then
        skipped = skipped + 1
      else
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
  if skipped > 0 then
    require("jj.utils").notify("Kept " .. skipped .. " modified buffer(s)", vim.log.levels.WARN)
  end
end

-- Edits `rev` (default @), then opens each file it adds or modifies at its
-- first change and lists every hunk in a new quickfix list. With `only`,
-- closes every other file buffer.
local function open(rev, only)
  local utils = require("jj.utils")
  local root = utils.get_jj_root()
  if not root then
    return
  end
  rev = rev or "@"
  if rev ~= "@" then
    local _, ok = require("jj.core.runner").execute({ "jj", "edit", rev }, "Error editing change")
    if not ok then
      return
    end
    utils.reload_changed_file_buffers()
  end
  local files = changed_files("@")
  if not files then
    return
  end
  if #files == 0 then
    utils.notify("No added or modified files in " .. rev)
    return
  end
  local items = {}
  for _, file in ipairs(files) do
    file.path = vim.fs.joinpath(root, file.path)
    for _, hunk in ipairs(file.hunks) do
      table.insert(items, { filename = file.path, lnum = hunk.lnum, text = hunk.text })
    end
  end
  vim.fn.setqflist({}, " ", { title = "J open " .. rev, items = items })
  -- Reverse order leaves the first file in the window, on the first entry.
  local keep = {}
  for i = #files, 1, -1 do
    local lnum = files[i].hunks[1] and files[i].hunks[1].lnum or 1
    vim.cmd("edit +" .. lnum .. " " .. vim.fn.fnameescape(files[i].path))
    keep[vim.api.nvim_buf_get_name(0)] = true
  end
  if only then
    close_others(keep)
  end
end

local function J(lhs, args, desc)
  return { lhs, "<cmd>J " .. args .. "<cr>", desc = "JJ " .. desc }
end

return {
  "NicolasGB/jj.nvim",
  version = "*", -- Use the latest stable release
  lazy = false,
  init = function()
    -- The plugin's PAGER=cat loses to ui.pager and JJ_PAGER, and the plugin
    -- offers no per-command env hook, so force cat for all of Neovim.
    vim.env.JJ_PAGER = "cat"
  end,
  opts = {},
  config = function(_, opts)
    require("jj").setup(opts)
    -- :J dispatches through cmd.j at call time, so wrapping it adds `open`.
    local cmd = require("jj.cmd")
    local j = cmd.j
    cmd.j = function(args)
      local argv = type(args) == "string" and vim.split(args, "%s+") or args
      if argv[1] == "open" then
        local only = argv[2] == "--only"
        return open(argv[only and 3 or 2], only)
      end
      return j(args)
    end
    -- The subcommand list is local to the plugin's completer, so extend that.
    local existing = vim.api.nvim_get_commands({}).J
    vim.api.nvim_create_user_command("J", existing.callback, {
      nargs = existing.nargs,
      desc = existing.definition,
      complete = function(arglead, line, pos)
        local matches = existing.complete(arglead, line, pos)
        if vim.startswith("open", arglead) then
          table.insert(matches, "open")
        end
        return matches
      end,
    })
  end,
  keys = {
    J("<leader>jd", "describe", "describe"),
    J("<leader>jj", "log", "log"),
    J("<leader>jl", "log", "log"),
    J("<leader>jL", "log -r all()", "log all"),
    J("<leader>je", "edit", "edit"),
    J("<leader>jn", "new", "new"),
    J("<leader>js", "status", "status"),
    J("<leader>ju", "undo", "undo"),
    J("<leader>jy", "redo", "redo"),
    J("<leader>jr", "rebase", "rebase"),
    J("<leader>jS", "split", "split"),
    J("<leader>jba", "bookmark advance", "bookmark advance"),
    J("<leader>jbc", "bookmark create", "bookmark create"),
    J("<leader>jbd", "bookmark delete", "bookmark delete"),
    J("<leader>jbm", "bookmark move", "bookmark move"),
    J("<leader>jts", "tag set", "tag set"),
    J("<leader>jtd", "tag delete", "tag delete"),
    J("<leader>ja", "annotate", "annotate file"),
    J("<leader>jA", "annotate_line", "annotate line"),
    J("<leader>jx", "abandon", "abandon"),
    J("<leader>jf", "fetch", "fetch"),
    J("<leader>jp", "push", "push"),
    J("<leader>jpr", "open_pr", "open PR"),
    J("<leader>jpl", "open_pr --list", "open PR from bookmark list"),
    J("<leader>jo", "open", "open changed files"),
    J("<leader>jO", "open --only", "open only changed files"),
  },
}
