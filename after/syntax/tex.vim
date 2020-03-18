if has('conceal')
  syn match texMathSymbol '\^{-1}' contained conceal contains=texSuperscripts
  syn match texMathSymbol '\^\\mathrm{T}' contained conceal contains=texSuperscripts
  syn match texMathSymbol '\^\\mathrm{-T}' contained conceal contains=texSuperscripts
  syn match texSuperscripts '1' contained conceal cchar=¹
  syn match texSuperscripts '-' contained conceal cchar=⁻

  " \mathbb characters
  syn match texMathSymbol '\\mathbb{A}' contained conceal cchar=𝔸
  syn match texMathSymbol '\\mathbb{B}' contained conceal cchar=𝔹
  syn match texMathSymbol '\\mathbb{C}' contained conceal cchar=ℂ
  syn match texMathSymbol '\\mathbb{D}' contained conceal cchar=𝔻
  syn match texMathSymbol '\\mathbb{E}' contained conceal cchar=𝔼
  syn match texMathSymbol '\\mathbb{F}' contained conceal cchar=𝔽
  syn match texMathSymbol '\\mathbb{G}' contained conceal cchar=𝔾
  syn match texMathSymbol '\\mathbb{H}' contained conceal cchar=ℍ
  syn match texMathSymbol '\\mathbb{I}' contained conceal cchar=𝕀
  syn match texMathSymbol '\\mathbb{J}' contained conceal cchar=𝕁
  syn match texMathSymbol '\\mathbb{K}' contained conceal cchar=𝕂
  syn match texMathSymbol '\\mathbb{L}' contained conceal cchar=𝕃
  syn match texMathSymbol '\\mathbb{M}' contained conceal cchar=𝕄
  syn match texMathSymbol '\\mathbb{N}' contained conceal cchar=ℕ
  syn match texMathSymbol '\\mathbb{O}' contained conceal cchar=𝕆
  syn match texMathSymbol '\\mathbb{P}' contained conceal cchar=ℙ
  syn match texMathSymbol '\\mathbb{Q}' contained conceal cchar=ℚ
  syn match texMathSymbol '\\mathbb{R}' contained conceal cchar=ℝ
  syn match texMathSymbol '\\mathbb{S}' contained conceal cchar=𝕊
  syn match texMathSymbol '\\mathbb{T}' contained conceal cchar=𝕋
  syn match texMathSymbol '\\mathbb{U}' contained conceal cchar=𝕌
  syn match texMathSymbol '\\mathbb{V}' contained conceal cchar=𝕍
  syn match texMathSymbol '\\mathbb{W}' contained conceal cchar=𝕎
  syn match texMathSymbol '\\mathbb{X}' contained conceal cchar=𝕏
  syn match texMathSymbol '\\mathbb{Y}' contained conceal cchar=𝕐
  syn match texMathSymbol '\\mathbb{Z}' contained conceal cchar=ℤ

  " \mathcal characters
  syn match texMathSymbol '\\math\(scr\|cal\){A}' contained conceal cchar=𝓐
  syn match texMathSymbol '\\math\(scr\|cal\){B}' contained conceal cchar=𝓑
  syn match texMathSymbol '\\math\(scr\|cal\){C}' contained conceal cchar=𝓒
  syn match texMathSymbol '\\math\(scr\|cal\){D}' contained conceal cchar=𝓓
  syn match texMathSymbol '\\math\(scr\|cal\){E}' contained conceal cchar=𝓔
  syn match texMathSymbol '\\math\(scr\|cal\){F}' contained conceal cchar=𝓕
  syn match texMathSymbol '\\math\(scr\|cal\){G}' contained conceal cchar=𝓖
  syn match texMathSymbol '\\math\(scr\|cal\){H}' contained conceal cchar=𝓗
  syn match texMathSymbol '\\math\(scr\|cal\){I}' contained conceal cchar=𝓘
  syn match texMathSymbol '\\math\(scr\|cal\){J}' contained conceal cchar=𝓙
  syn match texMathSymbol '\\math\(scr\|cal\){K}' contained conceal cchar=𝓚
  syn match texMathSymbol '\\math\(scr\|cal\){L}' contained conceal cchar=𝓛
  syn match texMathSymbol '\\math\(scr\|cal\){M}' contained conceal cchar=𝓜
  syn match texMathSymbol '\\math\(scr\|cal\){N}' contained conceal cchar=𝓝
  syn match texMathSymbol '\\math\(scr\|cal\){O}' contained conceal cchar=𝓞
  syn match texMathSymbol '\\math\(scr\|cal\){P}' contained conceal cchar=𝓟
  syn match texMathSymbol '\\math\(scr\|cal\){Q}' contained conceal cchar=𝓠
  syn match texMathSymbol '\\math\(scr\|cal\){R}' contained conceal cchar=𝓡
  syn match texMathSymbol '\\math\(scr\|cal\){S}' contained conceal cchar=𝓢
  syn match texMathSymbol '\\math\(scr\|cal\){T}' contained conceal cchar=𝓣
  syn match texMathSymbol '\\math\(scr\|cal\){U}' contained conceal cchar=𝓤
  syn match texMathSymbol '\\math\(scr\|cal\){V}' contained conceal cchar=𝓥
  syn match texMathSymbol '\\math\(scr\|cal\){W}' contained conceal cchar=𝓦
  syn match texMathSymbol '\\math\(scr\|cal\){X}' contained conceal cchar=𝓧
  syn match texMathSymbol '\\math\(scr\|cal\){Y}' contained conceal cchar=𝓨
  syn match texMathSymbol '\\math\(scr\|cal\){Z}' contained conceal cchar=𝓩

  syn match texStatement '``' contained conceal cchar=“
  syn match texStatement '\'\'' contained conceal cchar=”
  syn match texStatement '\\item\>' contained conceal cchar=•
  syn match texMathSymbol '\\dd' contained conceal cchar=d
  syn match texDelimiter '\\{' contained conceal cchar={
  syn match texDelimiter '\\}' contained conceal cchar=}
  syn match texMathSymbol '\\setminus\>' contained conceal cchar=\
  syn match texMathSymbol '\\,' contained conceal cchar= 
  syn match texMathSymbol '\\ ' contained conceal cchar= 
  syn match texMathSymbol '\\quad' contained conceal cchar= 
  syn match texMathSymbol '\\qquad' contained conceal cchar= 
  syn match texMathSymbol '\\sqrt' contained conceal cchar=√
  syn match texMathSymbol '\\where\>' contained conceal cchar=|
  syn match texMathSymbol '\\\!' contained conceal

  " hide \text delimiter etc inside math mode
  if !exists("g:tex_nospell") || !g:tex_nospell
    syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=mathrm\)\s*{'     end='}' concealends keepend contains=@texFoldGroup containedin=texMathMatcher
    syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\)\s*{' end='}' concealends keepend contains=@texFoldGroup,@Spell containedin=texMathMatcher
  else
    syn region texMathText matchgroup=texStatement start='\\\(\(inter\)\=text\|mbox\|mathrm\)\s*{' end='}' concealends keepend contains=@texFoldGroup containedin=texMathMatcher
  endif

  syn region texBoldMathText matchgroup=texStatement start='\\\(mathbf\|bm\|symbf\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher
  syn cluster texMathZoneGroup add=texBoldMathText

  " https://github.com/vim/vim/blob/cd67059c0c3abf1e28aa66458abdf6f338252eb2/runtime/doc/todo.txt#L1893-L1895
  " syn region texBarMathText matchgroup=texStatement start='\\\(bar\|overline\){' end='}' concealends cchar=‾ contains=@texMathZoneGroup containedin=texMathMatcher
  syn match texBarMathText '\\bar\>' contained conceal cchar=‾ containedin=texMathMatcher
  syn match texBarMathText '\\overline\>' contained conceal cchar=‾ containedin=texMathMatcher
  hi link texBarMathText texStatement
  syn cluster texMathZoneGroup add=texBarMathText

  syn region texSansMathText matchgroup=texStatement start='\\\(mathsf\|textsf\|texttt\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher
  syn cluster texMathZoneGroup add=texSansMathText


  syn region texBoldItalStyle     matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup
  syn region texItalStyle  matchgroup=texTypeStyle start="\\emph\s*{" end="}" concealends contains=@texItalGroup

  set ambiwidth=single
  hi texBoldMathText cterm=bold gui=bold
endif

