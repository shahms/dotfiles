return {
  "julienvincent/hunk.nvim",
  cmd = { "HunkDiffView", "HunkDiffEditor" },
  config = function()
    require("hunk").setup()
  end,
  dependencies = {
    "MunifTanjim/nui.nvim"
  },
}
