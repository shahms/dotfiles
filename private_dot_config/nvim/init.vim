set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
set background=dark
" colorscheme desert
" colorscheme evening
" colorscheme torte
colorscheme slate

" LspInlayHint should look like comments
hi link LspInlayHint Comment

" Use the terminal emulator's color palette.
for i in range(16)
  let g:terminal_ansi_colors[i]= 'NONE'
  let g:terminal_color_{i} = 'NONE'
endfor

" TODO(shahms): Migrate this all to init.lua
source ~/.config/nvim/lua/config/lazy.lua
