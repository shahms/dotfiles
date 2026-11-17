-- Load trusted per-project configurations.
vim.o.exrc = true

-- Share ~/.vim and ~/.vimrc with Vim.
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")
vim.o.packpath = vim.o.runtimepath
vim.cmd.source("~/.vimrc")

require("config.lazy")

-- Match Vim, whose terminal windows take <C-w> as the window prefix.
-- <C-w>. sends a literal <C-w> to the shell.
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])
vim.keymap.set("t", "<C-w>.", "<C-w>")
-- Also like Vim, return to a terminal in terminal mode.
vim.api.nvim_create_autocmd("BufEnter", { pattern = "term://*", command = "startinsert" })

-- Alt+{h,j,k,l} moves between windows from any mode, per :help terminal-input.
for _, key in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set({ "t", "i" }, "<A-" .. key .. ">", [[<C-\><C-n><C-w>]] .. key)
  vim.keymap.set("n", "<A-" .. key .. ">", "<C-w>" .. key)
end

-- Keep in step with the theme in ~/.config/ghostty/config.
-- slate, the previous choice, ships with Neovim but has no matching
-- terminal theme, so the two drifted apart.
vim.o.background = "dark"
vim.cmd.colorscheme("jellybeans")
-- GitHub and Ayu have light variants. Drop the background line above and
-- Neovim follows the terminal's background, which arrives after startup:
-- local colorschemes = { dark = "github_dark_dimmed", light = "github_light" }
-- -- local colorschemes = { dark = "ayu-mirage", light = "ayu-light" }
-- local function pick_colorscheme()
--   vim.cmd.colorscheme(colorschemes[vim.o.background])
-- end
-- pick_colorscheme()
-- vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", callback = pick_colorscheme })

-- Inlay hints read as comments.
vim.api.nvim_set_hl(0, "LspInlayHint", { link = "Comment" })

-- Use the terminal emulator's color palette.
for i = 0, 15 do
  vim.g["terminal_color_" .. i] = "NONE"
end
