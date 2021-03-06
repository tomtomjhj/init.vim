" TODO
" * removing error highlight
" * <Plug>CoqJumpToEnd blocks while processing
" * how to hide a buffer without error? (+ bdelete)
" * spell
" * queries: if no session for current buffer, use existing one
"   * one-session mode (like PG)
" * auto layout breaks nerdtree
" * show a buffer with session in split without jumping to its current layout
" * `(` and `)` for sentence movement: not configurable ('sentence')
"   * sentence text object
"   * use coqtail's sentence parser?
" * string escape in sentence parsing
" * CoqGotoDef on id containing `'` is broken
" * if a job failed, then clear the job queue
" * goal/info panel not updated when the main panel is displayed in another tab
" * tradewind breaks coqtail and nvim
" * disable coc path completion trigger (`/`)
" * show diff of unification error

" NOTE:
" * hang → send SIGINT to coq

function! tomtomjhj#coq#mappings()
    command! -buffer -bang -nargs=1 CoqGotoDefSplit call tomtomjhj#coq#goto_def('split', <f-args>, <bang>0)

    " nvim may hang in `-- (insert) --` with `<C-\><C-o>:CoqNext<CR>` (vim somehow recovers).
    " Use <C-y> to prevent race between CoqNext and <Plug>CocRefresh when pumvisible.
    inoremap <buffer><expr> <Plug>CoqNext        (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqNext\<CR>"
    inoremap <buffer><expr> <Plug>CoqUndo        (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqUndo\<CR>"
    inoremap <buffer><expr> <Plug>CoqToLine      (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqToLine\<CR>"
    inoremap <buffer><expr> <Plug>CoqToTop       (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqToTop\<CR>"
    inoremap <buffer><expr> <Plug>CoqJumpToEnd   (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqJumpToEnd\<CR>"
    inoremap <buffer><expr> <Plug>CoqJumpToError (pumvisible() ? "\<C-y>" : "") . "\<Cmd>CoqJumpToError\<CR>"

    nmap <buffer>   <C-c>s     <Plug>CoqInterrupt<Plug>CoqStop
    " NOTE: [count]
    nmap <buffer><leader><C-c> <Plug>CoqInterrupt
    nmap <buffer>        <M-j> <Plug>CoqNext
    nmap <buffer>        <M-k> <Plug>CoqUndo
    nmap <buffer><leader>c.    <Plug>CoqJumpToEnd
    nmap <buffer><leader>c,    <Plug>CoqJumpToError
    imap <buffer>        <M-j> <Plug>CoqNext
    imap <buffer>        <M-k> <Plug>CoqUndo
    nmap <buffer>   <C-c>j     <Plug>CoqNext
    nmap <buffer>   <C-c>k     <Plug>CoqUndo
    imap <buffer>   <C-c>j     <Plug>CoqNext
    imap <buffer>   <C-c>k     <Plug>CoqUndo
    nmap <buffer>   <C-c>.     <Plug>CoqJumpToEnd
    nmap <buffer>   <C-c>,     <Plug>CoqJumpToError
    nmap <buffer>   <C-c><C-j> <Plug>CoqNext
    nmap <buffer>   <C-c><C-k> <Plug>CoqUndo
    imap <buffer>   <C-c><C-j> <Plug>CoqNext
    imap <buffer>   <C-c><C-k> <Plug>CoqUndo
    nmap <buffer>      <C-M-j> <Plug>CoqNext
    nmap <buffer>      <C-M-k> <Plug>CoqUndo
    imap <buffer>      <C-M-j> <Plug>CoqNext
    imap <buffer>      <C-M-k> <Plug>CoqUndo

    if &ft ==# 'coq'
        nmap <buffer>        <M-l> <Plug>CoqToLine
        imap <buffer>        <M-l> <Plug>CoqToLine
        nmap <buffer>   <C-c>l     <Plug>CoqToLine
        imap <buffer>   <C-c>l     <Plug>CoqToLine
        nmap <buffer>   <C-c><C-l> <Plug>CoqToLine
        imap <buffer>   <C-c><C-l> <Plug>CoqToLine
        nmap <buffer>      <C-M-l> <Plug>CoqToLine
        imap <buffer>      <C-M-l> <Plug>CoqToLine
    endif

    nmap <buffer>       <C-w>s :<C-u>call tomtomjhj#coq#split('split')<CR>

    nmap <buffer>        <M-]> <Plug>CoqGotoDef
    nmap <buffer>        <M-\> :<C-u>CoqGotoDefSplit <C-r>=coqtail#util#getcurword()<CR><CR>

    nmap <buffer><leader>cs    :<C-u>Coq Search<space>
    xmap <buffer><leader>cs    <Plug>CoqSearch

    nmap <buffer><leader>ch    :<C-u>Coq Check<space>
    xmap <buffer><leader>ch    <Plug>CoqCheck

    nmap <buffer>        <M-.> <Plug>CoqAbout
    xmap <buffer>        <M-.> <Plug>CoqAbout
    nmap <buffer><leader>?     :<C-u>Coq About<space>

    nmap <buffer>        <M-,> <Plug>CoqPrint
    xmap <buffer>        <M-,> <Plug>CoqPrint
    nmap <buffer><leader>p     :<C-u>Coq Print<space>

    nmap <buffer><leader>lc    :<C-u>Coq Locate<space>
    xmap <buffer><leader>lc    :<C-u>Coq Locate "<C-r>=coqtail#util#getvisual()<CR>"

    nmap <buffer><leader>ll    <Plug>CoqRestorePanels

    nmap <buffer><C-c><C-Leftmouse> <Leftmouse>zf%

    cmap <buffer><C-r><C-w> <C-r>=coqtail#util#getcurword()<CR>

    nmap <buffer><leader>fd    :<C-u>exe 'normal! zE'\|call tomtomjhj#coq#folds()<CR>

    nmap <buffer>gq   <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@
    nmap <buffer>gqq  <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@l
    nmap <buffer>gqgq <cmd>set opfunc=tomtomjhj#coq#gq<CR>g@l
    vmap <buffer>gq   <cmd>call tomtomjhj#coq#gq(visualmode(), 1)<CR>
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
    exe a:split
    " NOTE: wait until `s:call('refresh', '', 0, {})` finishes
    sleep 21ms
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
    " `zo` prevents unintended nested folds
    " TODO: sometimes fastfold deletes folds??
    keepjumps keeppatterns global/\v^\s*\zs(End|Qed|Defined|Abort|Admitted|Save).*\./normal zf%
    " TODO: bullets
    normal! zM
    call setpos('.', save_cursor)
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
