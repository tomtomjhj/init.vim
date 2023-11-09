hi! def link texMathDelim Delimiter
hi! def link texZone Special

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
