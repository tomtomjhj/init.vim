set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

if has('nvim-0.9')
    lua vim.loader.enable()
endif

if has('nvim-0.8')
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
endif

if has('nvim-0.10')
    silent! unmap <C-w>d
    silent! unmap <C-w><C-d>
endif
if has('nvim-0.11')
    silent! unmap grn
    silent! unmap gra
    silent! unmap grr
    silent! iunmap <C-s>
endif

source ~/.vim/configs.vim
