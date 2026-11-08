return {
  settings = {
    ['rust-analyzer'] = {
      rustfmt = {
        extraArgs = {
          "+nightly",
        },
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = true,
      check = {
        overrideCommand = {"bazel-clippy", "$saved_file"},
      },
    }
  },
  on_attach = function(_, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
}
