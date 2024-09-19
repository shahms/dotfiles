return {
  "nvim-neotest/neotest",
  opts = function()
    return {
      adapters = {
        require("neotest-python")({
          python = "python3.11",
        }),
        require("neotest-plenary"),
        require("neotest-vim-test")({
          ignore_file_types = {"python", "vim", "lua"},
        }),
      },
    }
  end,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters.
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-vim-test",
  },
}
