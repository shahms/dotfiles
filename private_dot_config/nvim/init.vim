set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
set background=dark
" colorscheme desert
" colorscheme evening
" colorscheme torte
colorscheme slate


" TODO(shahms): Migrate this all to init.lua
source ~/.config/nvim/lua/config/lazy.lua
