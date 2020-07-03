function! g:CoqtailHighlight()
    hi def CoqtailChecked ctermbg=237
    hi def CoqtailSent ctermbg=60
endfunction

" TODO: this should be mapped on goal/info window and it must designate the source buffer
" nmap <buffer> <Plug>CoqStart :CoqStart<CR>
" nmap <buffer> <Plug>CoqStop :CoqStop<CR>
nmap <buffer><leader><c-c> <Plug>CoqInterrupt
nmap <buffer> <M-j> <Plug>CoqNext
nmap <buffer> <M-k> <Plug>CoqUndo
nmap <buffer> <M-l> <Plug>CoqToLine
" nmap <buffer> <Plug>CoqToTop :CoqToTop<CR>
" nmap <buffer> <Plug>CoqJumpToEnd :CoqJumpToEnd<CR>
imap <buffer> <M-j> <Plug>CoqNext
imap <buffer> <M-k> <Plug>CoqUndo
imap <buffer> <M-l> <Plug>CoqToLine
" imap <buffer> <Plug>CoqToTop <C-\><C-o>:CoqToTop<CR>
" imap <buffer> <Plug>CoqJumpToEnd <C-\><C-o>:CoqJumpToEnd<CR>
" nmap <buffer> <M-]> <Plug>CoqGotoDef
" nmap <buffer> <Plug>CoqSearch :Coq Search <C-r>=coqtail#util#getcurword()<CR><CR>
nmap <buffer> <M-.> <Plug>CoqCheck
" TODO vmap
" nmap <buffer> <Plug>CoqAbout :Coq About <C-r>=coqtail#util#getcurword()<CR><CR>
nmap <buffer> <M-,> <Plug>CoqPrint
nmap <buffer><leader>lc <Plug>CoqLocate
nmap <buffer><leader>ll <Plug>CoqRestorePanels
" nmap <buffer> <Plug>CoqGotoGoalStart :<C-U>execute v:count1 'CoqGotoGoal'<CR>
" nmap <buffer> <Plug>CoqGotoGoalEnd :<C-U>execute v:count1 'CoqGotoGoal!'<CR>
" nmap <buffer> <Plug>CoqGotoGoalNextStart :CoqGotoGoalNext<CR>
" nmap <buffer> <Plug>CoqGotoGoalNextEnd :CoqGotoGoalNext!<CR>
" nmap <buffer> <Plug>CoqGotoGoalPrevStart :CoqGotoGoalPrev<CR>
" nmap <buffer> <Plug>CoqGotoGoalPrevEnd :CoqGotoGoalPrev!<CR>
" nmap <buffer> <Plug>CoqToggleDebug :CoqToggleDebug<CR>
