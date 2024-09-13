require 'lspconfig'.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        ruff = {
          enabled = true,
          formatEnabled = true,
        },
        pylsp_mypy = {
          overrides = {"--disallow-untyped-defs", true},
        },
      }
    }
  }
}
