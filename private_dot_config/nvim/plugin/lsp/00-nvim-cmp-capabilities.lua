-- Override the default lspconfig capabilities with those provided by cmp-nvim-lsp.
local lspconfig = require 'lspconfig'
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    capabilities = require 'cmp_nvim_lsp'.default_capabilities()
  }
)
