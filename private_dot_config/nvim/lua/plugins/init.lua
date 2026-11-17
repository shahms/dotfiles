return {
  {
    "folke/lazy.nvim",
    -- Already loaded by the time lazy.nvim installs `keys` handlers, so they
    -- would never fire.
    init = function()
      vim.keymap.set("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Lazy sync" })
    end,
  },
}
