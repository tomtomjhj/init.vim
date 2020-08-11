set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vim/configs.vim

augroup NvimStuff | au!
    au TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
