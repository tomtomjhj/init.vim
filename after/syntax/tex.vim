hi! def link texMathDelim Delimiter
hi! def link texCmdStyle         texCmdType
hi! def link texCmdStyleBold     texCmdType
hi! def link texCmdStyleBoldItal texCmdType
hi! def link texCmdStyleItal     texCmdType
hi! def link texCmdStyleItalBold texCmdType
hi! def link texZone Special

syntax match texCmdTodo '\\jaehwang'

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

" Symbols
syntax match texMathSymbol "\\Box\>"                 contained conceal cchar=☐
syntax match texMathSymbol "\\Lleftarrow\>"          contained conceal cchar=⇚
syntax match texMathSymbol "\\Rrightarrow\>"         contained conceal cchar=⇛
syntax match texMathSymbol "\\impliedby\>"           contained conceal cchar=⇐
syntax match texMathSymbol "\\leftsquigarrow\>"      contained conceal cchar=⇜
syntax match texMathSymbol "\\leftrightsquigarrow\>" contained conceal cchar=↭
syntax match texMathSymbol "\\rightsquigarrow\>"     contained conceal cchar=⇝
syntax match texMathSymbol "\\triangleq\>"           contained conceal cchar=≜
syntax match texMathSymbol "\\trianglelefteq\>"      contained conceal cchar=⊴
syntax match texMathSymbol "\\trianglerighteq\>"     contained conceal cchar=⊵
