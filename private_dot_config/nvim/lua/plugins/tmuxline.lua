return {
  {
    "edkolev/tmuxline.vim",
    init = function()
      -- Use simple separators.
      vim.g.tmuxline_powerline_separators = 0
      -- tmuxline can't follow lualine or the colorscheme, so pin the theme
      -- that matches init.lua's. Without it, tmuxline falls back to its
      -- fixed "powerline" colors. After changing it, regenerate
      -- ~/.tmux/tmuxline.snapshot. tmuxline has no GitHub or Ayu theme.
      vim.g.tmuxline_theme = "jellybeans"
    end,
  },
}
