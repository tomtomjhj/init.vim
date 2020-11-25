set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vim/configs.vim

augroup NvimStuff | au!
    " NOTE: on_visual=false disables highlighting for custom omap & text
    " object (uses on_visual yank) but it's good for visualstar
    au TextYankPost * silent! lua require'vim.highlight'.on_yank { on_visual = false }
augroup END
