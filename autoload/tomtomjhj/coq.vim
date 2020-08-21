function! tomtomjhj#coq#mappings()
    " TODO: :bd → error
    nmap <buffer>   <C-c>s     <Plug>CoqStop
    " NOTE: [count]
    nmap <buffer><leader><C-c> <Plug>CoqInterrupt
    nmap <buffer>        <M-j> <Plug>CoqNext
    nmap <buffer>        <M-k> <Plug>CoqUndo
    nmap <buffer>        <M-l> <Plug>CoqToLine
    nmap <buffer><leader>c.    <Plug>CoqJumpToEnd
    imap <buffer>        <M-j> <Plug>CoqNext
    imap <buffer>        <M-k> <Plug>CoqUndo
    imap <buffer>        <M-l> <Plug>CoqToLine
    nmap <buffer>   <C-c>j     <Plug>CoqNext
    nmap <buffer>   <C-c>k     <Plug>CoqUndo
    nmap <buffer>   <C-c>l     <Plug>CoqToLine
    imap <buffer>   <C-c>j     <Plug>CoqNext
    imap <buffer>   <C-c>k     <Plug>CoqUndo
    imap <buffer>   <C-c>l     <Plug>CoqToLine
    nmap <buffer>   <C-c>.     <Plug>CoqJumpToEnd
    nmap <buffer>   <C-c><C-j> <Plug>CoqNext
    nmap <buffer>   <C-c><C-k> <Plug>CoqUndo
    nmap <buffer>   <C-c><C-l> <Plug>CoqToLine
    imap <buffer>   <C-c><C-j> <Plug>CoqNext
    imap <buffer>   <C-c><C-k> <Plug>CoqUndo
    imap <buffer>   <C-c><C-l> <Plug>CoqToLine

    " TODO: consistent mappings for word version and ex command version
    " TODO this populates quickfix, tagfunc --> fzf?
    nmap <buffer>        <M-]> <Plug>CoqGotoDef

    nmap <buffer><leader>cs    <Plug>CoqSearch
    xmap <buffer><leader>cs    <Plug>CoqSearch

    nmap <buffer>        <M-.> <Plug>CoqCheck
    xmap <buffer>        <M-.> <Plug>CoqCheck
    nmap <buffer><leader>?     :<C-u>Coq Check<space>

    nmap <buffer>        <M-,> <Plug>CoqPrint
    xmap <buffer>        <M-,> <Plug>CoqPrint
    nmap <buffer><leader>p     :<C-u>Coq Print<space>

    nmap <buffer><leader>ca    <Plug>CoqAbout
    xmap <buffer><leader>ca    <Plug>CoqAbout

    nmap <buffer><leader>lc    :<C-u>Coq Locate<space>
    xmap <buffer><leader>lc    :<C-u>Coq Locate "<C-r>=coqtail#util#getvisual()<CR>"

    nmap <buffer><leader>ll    <Plug>CoqRestorePanels

    nmap <buffer><C-c><C-Leftmouse> <Leftmouse>zf%

    cmap <buffer><C-r><C-w> <C-r>=coqtail#util#getcurword()<CR>
    " TODO , t p
endfunction
