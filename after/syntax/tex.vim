if !has('conceal')
    finish
endif

" https://github.com/vim/vim/blob/cd67059c0c3abf1e28aa66458abdf6f338252eb2/runtime/doc/todo.txt#L1893-L1895
" syn region texBarMathText matchgroup=texStatement start='\\\(bar\|overline\){' end='}' concealends cchar=‾ contains=@texMathZoneGroup containedin=texMathMatcher
syn match texBarMathText '\\bar\>' contained conceal cchar=‾ containedin=texMathMatcher
syn match texBarMathText '\\overline\>' contained conceal cchar=‾ containedin=texMathMatcher
hi link texBarMathText texStatement
syn cluster texMathZoneGroup add=texBarMathText

syn region texSansMathText matchgroup=texStatement start='\\\(textsf\|texttt\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher
syn cluster texMathZoneGroup add=texSansMathText
