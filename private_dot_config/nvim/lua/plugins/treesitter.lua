return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts = {},
    init = function(plugin)
      require("nvim-treesitter").install { "rust", "python", "lua", "starlark", "cpp" }
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "*" },
        callback = function(ev)
          -- Start treesitter for all filetypes, but ignore errors when it's unsupported.
          if not pcall(vim.treesitter.start) then
            return
          end
          local ok, queries = pcall(vim.treesitter.query.get, ev.match, "indents")
          if ok and queries then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local ranges = { a = "outer", i = "inner" }
      local mappings = { a = "parameter", m = "function", c = "class" }
      for okey, object in pairs(mappings) do
        for rkey, range in pairs(ranges) do
          vim.keymap.set({ "x", "o" }, ("%s%s"):format(rkey, okey), function()
            select(("@%s.%s"):format(object, range), "textobjects")
          end)
        end
      end
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.outer")
      end)
    end
  }
}
