function! g:CoqtailHighlight()
    hi def CoqtailChecked ctermbg=237
    hi def CoqtailSent ctermbg=60
endfunction

" TODO: this should be mapped on goal/info window and it must designate the source buffer
" nmap <buffer> <Plug>CoqStart :CoqStart<CR>
" nmap <buffer> <Plug>CoqStop :CoqStop<CR>
" NOTE: use [count]
nmap <buffer><leader><c-c> <Plug>CoqInterrupt
nmap <buffer>        <M-j> <Plug>CoqNext
nmap <buffer>        <M-k> <Plug>CoqUndo
nmap <buffer>        <M-l> <Plug>CoqToLine
" nmap <buffer><leader>cG    <Plug>CoqJumpToEnd
imap <buffer>        <M-j> <Plug>CoqNext
imap <buffer>        <M-k> <Plug>CoqUndo
imap <buffer>        <M-l> <Plug>CoqToLine
" TODO this populates quickfix, tagfunc --> fzf?
nmap <buffer>        <M-]> <Plug>CoqGotoDef

nmap <buffer><leader>cs    <Plug>CoqSearch
" TODO vmap
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
