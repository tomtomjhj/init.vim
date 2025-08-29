set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

if has('nvim-0.9')
    lua vim.loader.enable()
endif

if has('nvim-0.8')
    aunmenu PopUp.How-to\ disable\ mouse
    if has('nvim-0.11')
        aunmenu PopUp.-2-
    else
        aunmenu PopUp.-1-
    endif

    " TODO: context
    anoremenu PopUp.Hover <Cmd>lua vim.lsp.buf.hover{border={'','','',' ','','','',' '}}<CR>
    anoremenu PopUp.Toggle\ breakpoint  <Cmd>DapToggleBreakpoint<CR>
    " TODO: just wipe out all the default menu and start over.
endif

if has('nvim-0.10')
    silent! unmap <C-w>d
    silent! unmap <C-w><C-d>
endif
if has('nvim-0.11')
    silent! unmap grn
    silent! unmap gra
    silent! unmap gri
    silent! unmap grr
    silent! unmap gO
    silent! iunmap <C-s>
    silent! sunmap <C-s>
    silent! iunmap <Tab>
    silent! sunmap <Tab>
    silent! iunmap <S-Tab>
    silent! sunmap <S-Tab>
endif

source ~/.vim/configs.vim
