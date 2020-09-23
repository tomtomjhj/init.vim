setlocal matchpairs-=<:>

" vim-markdown-mappings {{{1
function! s:nvmap(lhs, rhs)
    execute 'nmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
    execute 'vmap <buffer>' . a:lhs . ' <Plug>' . a:rhs
endfunction
call s:nvmap(']]', 'Markdown_MoveToNextHeader')
call s:nvmap('[[', 'Markdown_MoveToPreviousHeader')
call s:nvmap('][', 'Markdown_MoveToNextSiblingHeader')
call s:nvmap('[]', 'Markdown_MoveToPreviousSiblingHeader')
call s:nvmap(']u', 'Markdown_MoveToParentHeader')
call s:nvmap(']h', 'Markdown_MoveToCurHeader')
call s:nvmap('gx', 'Markdown_OpenUrlUnderCursor')
delfunction s:nvmap

" text object {{{1
let s:mkd_textobj = {
            \   'code': {
            \     'select-a-function': 'tomtomjhj#markdown#FencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'tomtomjhj#markdown#FencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \ }
call textobj#user#plugin('markdown', s:mkd_textobj)
" TODO:
" * list item text object
" * make paragraph, sentence text object list-aware

" folding {{{1
" adapted tpope/vim-markdown/ftplugin/markdown.vim + plasticboy/vim-markdown pythonic foldtext
" NOTE: doesn't handle yaml front matter

function! s:NotCodeBlock(lnum) abort
    return !InSynStack('^mkd\%(Code\|Snippet\)', synstack(a:lnum, 1))
endfunction

function! MarkdownFoldExpr() abort
    let line = getline(v:lnum)
    let hashes = matchstr(line, '^\s\{,3}\zs#\+')
    if !empty(hashes) && s:NotCodeBlock(v:lnum)
        return ">" . len(hashes)
    endif
    let nextline = getline(v:lnum + 1)
    if (line =~ '^.\+$') && (nextline =~ '^=\+$') && s:NotCodeBlock(v:lnum + 1)
        return ">1"
    endif
    if (line =~ '^.\+$') && (nextline =~ '^-\+$') && s:NotCodeBlock(v:lnum + 1)
        return ">2"
    endif
    return "="
endfunction

function! MarkdownFoldText()
    let line = getline(v:foldstart)
    let has_numbers = &number || &relativenumber
    let nucolwidth = &fdc + has_numbers * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 6
    let foldedlinecount = v:foldend - v:foldstart
    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let line = substitute(line, '\%("""\|''''''\)', '', '')
    let fillcharcount = windowwidth - strdisplaywidth(line) - len(foldedlinecount) + 1
    return line . ' ' . repeat("-", fillcharcount) . ' ' . foldedlinecount
endfunction

setlocal foldexpr=MarkdownFoldExpr()
setlocal foldmethod=expr
setlocal foldtext=MarkdownFoldText()
" let b:undo_ftplugin .= " foldexpr< foldmethod< foldtext<"

" surrounders {{{1
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

" mappings {{{1
nmap     <buffer>             <leader>pd :set ft=pandoc\|unmap <lt>buffer><lt>leader>pd<CR>
nmap     <buffer><silent>     <leader>py vid:AsyncRun python3<CR>:CW<CR>
nnoremap <buffer><silent><localleader>b  :set opfunc=SurroundStrong<cr>g@
vnoremap <buffer><silent><localleader>b  :<C-U>call SurroundStrong(visualmode())<CR>
nmap     <buffer>          <MiddleMouse> <LeftMouse><localleader>biw
vmap     <buffer>          <MiddleMouse> <localleader>b
nnoremap <buffer><silent>     <leader>tf :TableFormat<CR>
" vim: set fdm=marker fdl=0:
