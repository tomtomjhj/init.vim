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
    silent! unmap crn
    silent! unmap crr
    silent! unmap <C-r><C-r>
    silent! unmap <C-r>r
    silent! unmap gr
    silent! iunmap <C-s>
endif

source ~/.vim/configs.vim
