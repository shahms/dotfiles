return {
  {
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
      -- Better key bindings for UltiSnipsExpandTrigger
      -- vim.g.UltiSnipsExpandTrigger = '<tab>'
      -- vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
      -- vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    end,
  },
}
