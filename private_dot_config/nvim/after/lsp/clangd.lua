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

return {
  -- The default configuration incorrectly binds to "proto".
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  -- TODO: use the on_attach handler from lsp-config as well.
  on_attach = vim.list_extend(
    { dofile("/home/sking/src/driving/experimental/sking/nvim/clangd-bazel-args.lua").on_attach }, collect_on_attach()),
  cmd = {
    "clangd", "--log=error",
  },
}
