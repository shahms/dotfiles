local function guard_string(opts)
  local path = vim.api.nvim_buf_get_name(0)
  local root = vim.fs.find({ "MODULE.bazel", "REPO.bazel", "WORKSPACE", "WORKSPACE.bazel" },
    { upward = true, path = path, type = "file" })[1]
  if root then
    root = vim.fs.dirname(root)
  else
    root = vim.fn.getcwd()
  end
  local header = vim.fs.relpath(root, path) or path
  return header:gsub("[%.%-/]", "_"):upper()
end

local function snippet_luasnip(trig, opts)
  -- local ls = require("luasnip")
  -- local s = ls.snippet
  -- local f = ls.function_node
  -- local t = ls.text_node
  -- local i = ls.insert_node
  return s(trig, {
    f(function(_, _, _)
      return "#ifndef " .. guard_string(opts)
    end),
    t { "", "" },
    f(function(_, _, _)
      return "#define " .. guard_string(opts)
    end),
    t { "", "", "" },
    i(0),
    t { "", "", "" },
    f(function(_, _, _)
      return "#endif // " .. guard_string(opts)
    end),
  })
end
return {
  snippet_luasnip("guard", {})
}
