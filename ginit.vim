if exists('g:GuiLoaded') " nvim-qt {{{
    GuiTabline 0
    GuiPopupmenu 0
    GuiFont Source Code Pro:h13

    func! FontSize(delta)
        let [name, size] = matchlist(g:GuiFont, '\v(.*:h)(\d+)')[1:2]
        let new_size = str2nr(size) + a:delta
        exe 'GuiFont ' . name . new_size
    endfunc

    map <C--> <Cmd>call FontSize(-v:count1)<CR>
    map <C-+> <Cmd>call FontSize(v:count1)<CR>
    map <C-=> <Cmd>call FontSize(v:count1)<CR>
" }}}
else
    " TODO: goneovim doesn't source ginit.vim?
    set guifont=Source\ Code\ Pro:h12
endif
