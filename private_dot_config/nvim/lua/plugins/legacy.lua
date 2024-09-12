-- Legacy plugins migrated wholesale from vim-plug
return {
  {
    "google/vim-maktaba",
    config = function()
      vim.fn["maktaba#plugin#Detect"]()
    end,
  },
  {
    "google/vim-glaive",
    config = function()
      vim.fn["glaive#Install"]()
    end,
    dependencies = {
      "google/vim-maktaba",
    },
  },
  {
    "google/vim-codefmt",
    init = function()
      -- TODO(shahms): Defer to vim.lsp.buf.format() when supported.
      local opts = { silent = true, remap = false, unique = true }
      vim.keymap.set("n", "<leader>=b", ":FormatCode<CR>", opts)
      vim.keymap.set("n", "<leader>=", ":set opfunc=codefmt#FormatMap<CR>g@", opts)
      vim.keymap.set("n", "<leader>==", ":FormatLines<CR>", opts)
      vim.keymap.set("v", "<leader>=", ":FormatLines<CR>", opts)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("autoformat", {}),
        pattern = "bzl",
        command = "AutoFormatBuffer buildifier",
      })
    end,

    dependencies = {
      "google/vim-glaive",
      "google/vim-maktaba",
    },
  },
  {
    "google/vim-syncopate",
    dependencies = {
      "google/vim-maktaba",
    },
  },
}
