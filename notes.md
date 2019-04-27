## Tex conceal

### do not conceal sub/superscript block

Why?: many math symbols do not have sub/superscript variant unicode.

In `sytax/tex.vim`, around line 981, comment out following lines.

```vim
   syn region texSuperscript	matchgroup=Delimiter start='\^{'	skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
   syn region texSubscript	matchgroup=Delimiter start='_{'		skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
```

### TODO

* correctly conceal things like this: `\sum_n`. Need to ignore `_`. Do this without modifying `s:texMathList=[` if possible.


## markdown

### TODO

* do not conceal `$$` of math block

