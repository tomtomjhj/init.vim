hi! link texMathDelim Delimiter
hi! link texCmdStyle         texCmdType
hi! link texCmdStyleBold     texCmdType
hi! link texCmdStyleBoldItal texCmdType
hi! link texCmdStyleItal     texCmdType
hi! link texCmdStyleItalBold texCmdType

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

syntax match texMathSuper /\^\\top\>/ contained conceal cchar=ᵀ contains=texMathOper

" https://github.com/vim/vim/blob/cd67059c0c3abf1e28aa66458abdf6f338252eb2/runtime/doc/todo.txt#L1893-L1895
" syn region texBarMathText matchgroup=texStatement start='\\\(bar\|overline\){' end='}' concealends cchar=‾ contains=@texMathZoneGroup containedin=texMathMatcher
syn match texBarMathText '\\bar\>' contained conceal cchar=‾ containedin=texMathMatcher
syn match texBarMathText '\\overline\>' contained conceal cchar=‾ containedin=texMathMatcher
hi link texBarMathText texMathSymbol
syn cluster texMathZoneGroup add=texBarMathText

" syn region texSansMathText matchgroup=texCmdStyle start='\\\(textsf\|texttt\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher
" syn cluster texMathZoneGroup add=texSansMathText
