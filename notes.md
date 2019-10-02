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

### Note

* correctly conceal things like this: `\sum_n`. Need to ignore `_`. Do this without modifying `s:texMathList=[` if possible.
    * removing `_` from `syn iskeyword` fixes it.


## Tex BeginEnd

```vim
 syn match texBadMath		"\\end\s*{\s*\(displaymath\|equation\|eqnarray\|math\|align\)\*\=\s*}"
 ...
 call TexNewMathZone("E","align",1)
```


# cursor movement on concealed string

```
setlocal concealcursor=n
```

This doesn't work as expected.

<https://vi.stackexchange.com/questions/4530/moving-over-conceal>

# local nvimrc

```vim
fun s:c()
    " ....
endfun

augroup ft_c
  autocmd!
  autocmd Syntax c call s:c()
augroup end
```

# TODO:

* pandoc: command is broken: can't run it on multiple buffers
* pandoc: math highlighting is broken in enumerate, in hard-wrapped lines
    * enumerate itself is not broken. Because of the preceding 4 spaces, the line is recognized as a code block.
    * `let g:pandoc#syntax#protect#codeblocks = 0` fixes it
* Better interaction of hlsearch and conceal?
* Pair highlighting in insert mode makes the cursor indiscernible.

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

# pitfalls
* because of E10, need to use `'\|'` here, even though `'\v'` is used

    ```vim
    map <leader>r/ :<C-u>Rg <C-r>=substitute(@/,'\v(\\\<\|\\\>)','',"g")<CR>
    ```
