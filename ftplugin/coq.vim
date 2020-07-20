function! g:CoqtailHighlight()
    hi def CoqtailChecked ctermbg=237
    hi def CoqtailSent ctermbg=60
endfunction

" TODO: :bd → error
" TODO: goal/info needs similar mappings and it should be aware of the source buffer
nmap <buffer>   <C-c>s     <Plug>CoqStop
" NOTE: use [count]
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
" TODO vmap for CoqCheck, Coq Locate, ...
nmap <buffer>        <M-.> <Plug>CoqCheck
nmap <buffer><leader>?     :<C-u>Coq Check<space>
nmap <buffer>        <M-,> <Plug>CoqPrint
nmap <buffer><leader>p     :<C-u>Coq Print<space>
nmap <buffer><leader>ca    <Plug>CoqAbout
nmap <buffer><leader>lc    :<C-u>Coq Locate<space>
nmap <buffer><leader>ll    <Plug>CoqRestorePanels

" nmap <buffer> <Plug>CoqGotoGoalStart :<C-U>execute v:count1 'CoqGotoGoal'<CR>
" nmap <buffer> <Plug>CoqGotoGoalEnd :<C-U>execute v:count1 'CoqGotoGoal!'<CR>
" nmap <buffer> <Plug>CoqGotoGoalNextStart :CoqGotoGoalNext<CR>
" nmap <buffer> <Plug>CoqGotoGoalNextEnd :CoqGotoGoalNext!<CR>
" nmap <buffer> <Plug>CoqGotoGoalPrevStart :CoqGotoGoalPrev<CR>
" nmap <buffer> <Plug>CoqGotoGoalPrevEnd :CoqGotoGoalPrev!<CR>

nmap <buffer><C-c><C-Leftmouse> <Leftmouse>zf%

" TODO , t p
