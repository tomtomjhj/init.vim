" TODO
" * <Plug>CoqJumpToEnd blocks while processing
" * hlsearch disabled while processing
" * how to hide a buffer without error? (+ bdelete)
" * queries: if no session for current buffer, check if there is a session for
"   a visible buffer and use it.
" * auto layout breaks nerdtree
" * show a buffer with session in split without jumping to its current layout
" * `(` and `)` for sentence movement: not configurable ('sentence')
"   * sentence text object
"   * use coqtail's sentence parser?
" * string escape in sentence parsing
" * if a job failed, then clear the job queue
" * goal/info panel not updated when the main panel is displayed in another tab
" * disable path completion trigger (`/`)
" * show diff of unification error
" * completion source to get names from goal/info panel
" * make undo work more consistently in goal/info panel
" * compatibility with :Gedit

" NOTE:
" * hang → send SIGINT to coq

function! tomtomjhj#coq#mappings()
    command! -buffer -bang -nargs=1 CoqGotoDefSplit call tomtomjhj#coq#goto_def('split', <f-args>, <bang>0)

    " nvim may hang in `-- (insert) --` with `<C-\><C-o>:CoqNext<CR>` (vim somehow recovers).
    inoremap <buffer> <Plug>CoqNext        <Cmd>CoqNext<CR>
    inoremap <buffer> <Plug>CoqUndo        <Cmd>CoqUndo<CR>
    inoremap <buffer> <Plug>CoqToLine      <Cmd>CoqToLine<CR>
    inoremap <buffer> <Plug>CoqToTop       <Cmd>CoqToTop<CR>
    inoremap <buffer> <Plug>CoqJumpToEnd   <Cmd>CoqJumpToEnd<CR>
    inoremap <buffer> <Plug>CoqJumpToError <Cmd>CoqJumpToError<CR>

    nmap <buffer> <localleader>s <Plug>CoqInterrupt<Plug>CoqStop
    nmap <buffer> <localleader>i <Plug>CoqInterrupt

    " NOTE: [count]
    nmap <buffer> <localleader>j <Plug>CoqNext
    nmap <buffer> <C-M-j>        <Plug>CoqNext
    nmap <buffer> <C-M-n>        <Plug>CoqNext
    imap <buffer> <C-g>n         <Plug>CoqNext
    imap <buffer> <C-g><C-n>     <Plug>CoqNext
    imap <buffer> <C-M-j>        <Plug>CoqNext
    imap <buffer> <C-M-n>        <Plug>CoqNext

    nmap <buffer> <localleader>k <Plug>CoqUndo
    nmap <buffer> <C-M-k>        <Plug>CoqUndo
    imap <buffer> <C-g>p         <Plug>CoqUndo
    imap <buffer> <C-g><C-p>     <Plug>CoqUndo
    imap <buffer> <C-M-k>        <Plug>CoqUndo

    nmap <buffer> <localleader>. <Plug>CoqJumpToEnd
    nmap <buffer> <localleader>, <Plug>CoqJumpToError

    if &ft ==# 'coq'
        nmap <buffer> <localleader>l <Plug>CoqToLine
        nmap <buffer> <C-M-l>        <Plug>CoqToLine
        imap <buffer> <C-g>l         <Plug>CoqToLine
        imap <buffer> <C-g><C-l>     <Plug>CoqToLine
        imap <buffer> <C-M-l>        <Plug>CoqToLine
    endif

    nmap <buffer> <C-w>s <Cmd>call tomtomjhj#coq#split('split')<CR>
    nmap <buffer> <C-w>v <Cmd>call tomtomjhj#coq#split('vsplit')<CR>

    if &ft ==# 'coq'
        nmap <buffer> <M-]> <Plug>CoqGotoDef
    endif
    nmap <buffer><expr> <M-\> "\<Cmd>CoqGotoDefSplit " . coqtail#util#getcurword() . "\<CR>"

    nmap <buffer> <localleader>cs :<C-u>Coq Search<space>
    xmap <buffer> <localleader>cs <Plug>CoqSearch

    nmap <buffer> <localleader>ch :<C-u>Coq Check<space>
    xmap <buffer> <localleader>ch <Plug>CoqCheck

    nmap <buffer> <M-.>          <Plug>CoqAbout
    xmap <buffer> <M-.>          <Plug>CoqAbout
    nmap <buffer> <localleader>? :<C-u>Coq About<space>

    nmap <buffer> <M-,>          <Plug>CoqPrint
    xmap <buffer> <M-,>          <Plug>CoqPrint
    nmap <buffer> <localleader>p :<C-u>Coq Print<space>

    nmap <buffer> <localleader>lc :<C-u>Coq Locate<space>
    xmap <buffer> <localleader>lc :<C-u>Coq Locate "<C-r>=coqtail#util#getvisual()<CR>"

    nmap <buffer> <localleader>ll <Plug>CoqRestorePanels

    cmap <buffer> <C-r><C-w> <C-r>=coqtail#util#getcurword()<CR>

    nmap <buffer> <localleader>fd <Cmd>exe 'normal! zE'\|call tomtomjhj#coq#folds()<CR>

    nmap <buffer> gq   <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@
    nmap <buffer> gqq  <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@l
    nmap <buffer> gqgq <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@l
    vmap <buffer> gq   <cmd>call tomtomjhj#coq#gq(visualmode(), 1)<CR>

    nmap <buffer> <localleader><C-L> <Cmd>call tomtomjhj#coq#clearhl()<CR>

    nmap <buffer> [g <Plug>CoqGotoGoalPrevStart
    nmap <buffer> [G <Plug>CoqGotoGoalPrevEnd
    nmap <buffer> ]g <Plug>CoqGotoGoalNextStart
    nmap <buffer> ]G <Plug>CoqGotoGoalNextEnd
    if &ft ==# 'coq-goals'
        nmap <buffer> [[ <Cmd>call tomtomjhj#coq#goal_section(1)<CR>
        nmap <buffer> ]] <Cmd>call tomtomjhj#coq#goal_section(0)<CR>
    endif

    " (v : t) → v
    nmap <buffer> ds<M-;> <Cmd>call <SID>simpl_binder()<CR>
endfunction

" NOTE: repeating didn't work when not using function
function! s:simpl_binder() abort
    exe "normal vab\<Esc>dF:hxdss"
    call repeat#set("ds\<M-;>", v:count)
endfunction

" TODO: normal gotodef-ing in aux buf makes it 'buflisted'
" TODO case when the target's source file already has a session
function! tomtomjhj#coq#goto_def(split, target, bang) abort
    call coqtail#panels#switch(g:coqtail#panels#main)
    call tomtomjhj#coq#split(a:split)
    call coqtail#gotodef(a:target, a:bang)
endfunction

" NOTE: split inherits winvar → weird residual highlight
" TODO: clearhl should be called when a coq buf without coqtail session is
" attached to window. BufWinEnter might not work! Maybe WinEnter?
" On FileType, register and manually trigger once?
function! tomtomjhj#coq#split(split)
    " Don't trigger WinNew (runs `s:call('refresh', '', 0, {})`) so that
    " coqtail doesn't highlight the new window.
    set eventignore+=WinNew
    exe a:split
    set eventignore-=WinNew
    call tomtomjhj#coq#clearhl()
endfunction

function! tomtomjhj#coq#clearhl()
    let win = win_getid()
    for l:var in ['coqtail_checked', 'coqtail_sent', 'coqtail_error']
        let l:val = getwinvar(win, l:var, -1)
        if l:val != -1
            call matchdelete(l:val, win)
            call setwinvar(win, l:var, -1)
        endif
    endfor
endfunction

function! tomtomjhj#coq#folds()
    let save_cursor = getcurpos()
    keepjumps keeppatterns global/\v^\s*\zs(End|Qed|Defined|Abort|Admitted|Save).*\./normal zf%
    normal! zM
    call setpos('.', save_cursor)
endfunction

function! tomtomjhj#coq#goal_section(back) abort
    call search('\v^(\=+ \(\d|-+[□∗])', a:back ? 'bW' : 'W') " )
endfunction

" prevent indentexpr from breaking gq on comments
function! tomtomjhj#coq#gq(type, ...)
    setl indentexpr=
    let sel_save = &selection
    let &selection = "inclusive"

    if a:0
        call feedkeys('gq', 'nx')
    elseif a:type == 'line'
        exe "normal! '[V']gq"
    else
        exe "normal! `[v`]gq"
    endif

    let &selection = sel_save
    setl indentexpr=GetCoqIndent()
endfunction

function! tomtomjhj#coq#ctags() abort
    !coqtags $(fd -e v)
    lua require'tomtomjhj/etags2ctags'()
    !rm TAGS
    split tags
    keeppatterns g/iris.proofmode\|Build_/d
endfunction
