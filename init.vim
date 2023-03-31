set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

if has('nvim-0.9')
    lua vim.loader.enable()
endif

source ~/.vim/configs.vim

if has('nvim-0.8')
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
endif
