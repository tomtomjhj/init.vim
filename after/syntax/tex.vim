" per-colorscheme customization
function! s:colors()
    if index(['quite', 'graey'], get(g:, 'colors_name', '')) < 0
        hi! def link texMathDelim Delimiter
        hi! def link texZone Special
    endif
endfunction
call s:colors()
augroup AfterSyntaxTex | au!
  au ColorScheme * call s:colors()
augroup END

syntax match texCmdTodo '\\jaehwang'

syntax clear texCommentTodo
syntax keyword texCommentTodo TODO
    \ containedin=texComment contained

" Don't conceal \[..\] and $$..$$, since they usually delimit longer complex math stuff.
syntax clear texMathZoneLD texMathZoneTD
execute 'syntax region texMathZoneLD matchgroup=texMathDelimZoneLD'
        \ 'start="\\\["'
        \ 'end="\\]"'
        \ 'contains=@texClusterMath'
execute 'syntax region texMathZoneTD matchgroup=texMathDelimZoneTD'
        \ 'start="\$\$"'
        \ 'end="\$\$"'
        \ 'contains=@texClusterMath keepend'

" Symbols. TODO: upstream
syntax match texMathSymbol "\\Box\>"                 contained conceal cchar=☐
syntax match texMathSymbol "\\impliedby\>"           contained conceal cchar=⇐
syntax match texMathSymbol "\\leftsquigarrow\>"      contained conceal cchar=⇜
" defined in vimtex/autoload/vimtex/syntax/p/amssymb.vim, but vimtex doesn't detect this package when using acmart?
syntax match texMathSymbol "\\rightsquigarrow\>"      contained conceal cchar=⇝
