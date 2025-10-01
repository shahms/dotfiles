return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'linrongbin16/lsp-progress.nvim',
    },
    opts = {
      options = {
        theme = "iceberg",
      },
      sections = {
        lualine_c = {
          { "filename", path = 1, },
          function()
            return require('lsp-progress').progress()
          end
        },
      }
    },
    config = function(_, opts)
      local lualine = require('lualine')
      lualine.setup(opts)

      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = lualine.refresh,
      })
    end,
  },
}
