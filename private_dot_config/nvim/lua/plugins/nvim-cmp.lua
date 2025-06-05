local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local function jump_forward(cmp)
  return cmp.mapping({
    -- c = function()
    --   if cmp.visible() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    --   else
    --     cmp.complete()
    --   end
    -- end,
    i = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
      else
        fallback()
      end
    end,
    s = function(fallback)
      if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), "m", true)
      else
        fallback()
      end
    end
  })
end
local function jump_backward(cmp)
  return cmp.mapping({
    -- c = function()
    --   if cmp.visible() then
    --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    --   else
    --     cmp.complete()
    --   end
    -- end,
    i = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
      else
        fallback()
      end
    end,
    s = function(fallback)
      if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), "m", true)
      else
        fallback()
      end
    end
  })
end
local function next_or_down(cmp)
  return cmp.mapping({
    -- c = function()
    --   if cmp.visible() then
    --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
    --   end
    -- end,
    i = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end
  })
end
local function prev_or_up(cmp)
  return cmp.mapping({
    -- c = function()
    --   if cmp.visible() then
    --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --   else
    --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
    --   end
    -- end,
    i = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end
  })
end
local function select_item(cmp, which)
  return cmp.mapping(cmp.mapping["select_" .. which .. "_item"]({ behavior = cmp.SelectBehavior.Select }), { "i" })
end
return {
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        enabled = false,
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use the built-in completion for ":".
      cmp.setup.cmdline(':', {
        enabled = false,

        -- But keep the recommended configuration in case.
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
      return {
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
          end,
        },
        window = {
        },
        mapping = {
          ["<Tab>"] = jump_forward(cmp),
          ["<S-Tab>"] = jump_backward(cmp),
          ["<Down>"] = select_item(cmp, "next"),
          ["<Up>"] = select_item(cmp, "prev"),
          ["<C-n>"] = next_or_down(cmp),
          ["<C-p>"] = prev_or_up(cmp),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping(
            cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }), { "i", "c" }
          ),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "ultisnips" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
    enabled = false,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    opts = function()
      --vim.lsp.config("*", {
      --  capabilities = require("cmp_nvim_lsp").default_capabilities()
      --})
      return {}
    end,
    enabled = false,
  },
  {
    "hrsh7th/cmp-buffer",
    enabled = false,
  },
  {
    "hrsh7th/cmp-path",
    enabled = false,
  },
  {
    "hrsh7th/cmp-cmdline",
    enabled = false,
  },
  {
    "quangnguyen30192/cmp-nvim-ultisnips",
    enabled = false,
  },
}
