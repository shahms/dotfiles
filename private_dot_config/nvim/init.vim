set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
colorscheme vim

" TODO(shahms): Migrate this all to init.lua
source ~/.config/nvim/lua/config/lazy.lua
