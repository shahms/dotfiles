return {
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {},
    dependencies = { "williamboman/mason.nvim" },
  },
}
