# Tex

## Tex conceal

### do not conceal sub/superscript block

Why?: many math symbols do not have sub/superscript variant unicode.

In `sytax/tex.vim`, around line 981, comment out following lines.

```vim
   syn region texSuperscript	matchgroup=Delimiter start='\^{'	skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
   syn region texSubscript	matchgroup=Delimiter start='_{'		skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
```

### do not conceal `$$` of math block
remvoe concealends

```vim
syn region texMathZoneY	matchgroup=Delimiter start="\$\$" matchgroup=Delimiter	end="\$\$"	end="%stopzone\>"	keepend concealends contains=@texMathZoneGroup
```

### TODO

* correctly conceal things like this: `\sum_n`. Need to ignore `_`. Do this without modifying `s:texMathList=[` if possible.
    * actually this works in tex but not in pandoc.


## Tex BeginEnd

```vim
 syn match texBadMath		"\\end\s*{\s*\(displaymath\|equation\|eqnarray\|math\|align\)\*\=\s*}"
 ...
 call TexNewMathZone("E","align",1)
```


## cursor movement on concealed string

```
setlocal concealcursor=n
```

This doesn't work as expected.

https://vi.stackexchange.com/questions/4530/moving-over-conceal


## conceal for each projects

Conceal commands defined for specific projects.
Just list up the string-cchar pair in local .vimrc and do some magic.


# TODO:
make patch files for above changes

# Chrome-style restore tab?

# motions

`:help motion`

* `[(`
* `v_iw`
* `v_ab`, `v_aB`, `v_ib`, `v_iB`
* `v_O`, `v_o`
* `gn`, `gN`

* `dw`: to remove whitespace from current pos

* TODO: get more used to operator & motion composition
* TODO: Insert-mode stuff
