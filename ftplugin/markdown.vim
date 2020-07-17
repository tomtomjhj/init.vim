setlocal matchpairs-=<:>

function! s:nvmap(lhs, rhs)
    execute 'nmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
    execute 'vmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
endfunction
call s:nvmap(']]', 'Markdown_MoveToNextHeader')
call s:nvmap('[[', 'Markdown_MoveToPreviousHeader')
call s:nvmap('][', 'Markdown_MoveToNextSiblingHeader')
call s:nvmap('[]', 'Markdown_MoveToPreviousSiblingHeader')
call s:nvmap(']u', 'Markdown_MoveToParentHeader')
call s:nvmap(']c', 'Markdown_MoveToCurHeader')
call s:nvmap('gx', 'Markdown_OpenUrlUnderCursor')
delfunction s:nvmap

func! MkdFencedCodeBlocka()
    if !InSynStack('mkdSnippet') && !InSynStack('mkdCode')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    let head_pos[2] = 1
    if !search('```', 'W') | return 0 | endif
    exec 'norm! E'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! MkdFencedCodeBlocki()
    if !InSynStack('mkdSnippet') && !InSynStack('mkdCode')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    exec 'norm! W'
    let head_pos = getpos('.')
    let head_pos[2] = 1
    if !search('```', 'W') | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc

let s:mkd_textobj = {
            \   'code': {
            \     'select-a-function': 'MkdFencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'MkdFencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \ }
call textobj#user#plugin('markdown', s:mkd_textobj)

function! s:MarkdownSetupFolding()
    if get(g:, "vim_markdown_folding_style_pythonic", 0)
        if get(g:, "vim_markdown_override_foldtext", 1)
            setlocal foldtext=Foldtext_markdown()
        endif
    endif
    setlocal foldexpr=Foldexpr_markdown(v:lnum)
    setlocal foldmethod=expr
endfunction

function! Surrounder(type, ends) abort
    let sel_save = &selection
    let &selection = 'old'
    let reg_save = getreg('"')
    if a:type ==# 'v'
        " handle the cursor on eol
        let l:p = (col([line("'>"), "$"]) - col("'>") <= 1) ? 'p' : 'P'
        execute 'normal! `<v`>x'
    elseif a:type ==# 'char'
        let l:p = (col([line("']"), "$"]) - col("']") <= 1) ? 'p' : 'P'
        execute 'normal! `[v`]x'
    else
        return
    endif
    call setreg('"', a:ends.getreg('"').a:ends)
    execute 'normal!' l:p
    call setreg('"', reg_save)
    let &selection = sel_save
endfunction

function! SurroundStrong(type)
    return Surrounder(a:type, '**')
endfunction

nmap <buffer>zM :call <SID>MarkdownSetupFolding()\|unmap <lt>buffer>zM<CR>zM
nmap <buffer><leader>pd :set ft=pandoc\|unmap <lt>buffer><lt>leader>pd<CR>
noremap  <buffer><silent><localleader>b :set opfunc=SurroundStrong<cr>g@
vnoremap <buffer><silent><localleader>b  :<C-U>call SurroundStrong(visualmode())<CR>
nmap <MiddleMouse> <LeftMouse><localleader>biw
vmap <MiddleMouse> <localleader>b
