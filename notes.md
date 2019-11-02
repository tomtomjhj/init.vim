# Tex & pandoc

## Tex conceal

### do not conceal sub/superscript block

Why?: many math symbols do not have sub/superscript variant unicode.

In `sytax/tex.vim`, around line 981, comment out following lines.

```vim
   syn region texSuperscript	matchgroup=Delimiter start='\^{'	skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSuperscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
   syn region texSubscript	matchgroup=Delimiter start='_{'		skip="\\\\\|\\[{}]" end='}'	contained concealends contains=texSpecialChar,texSubscripts,texStatement,texSubscript,texSuperscript,texMathMatcher
```

### do not conceal `$$` of math block
Remove `concealends`

```vim
syn region texMathZoneY	matchgroup=Delimiter start="\$\$" matchgroup=Delimiter	end="\$\$"	end="%stopzone\>"	keepend concealends contains=@texMathZoneGroup
```

### Note

* correctly conceal things like this: `\sum_n`. Need to ignore `_`. Do this without modifying `s:texMathList=[` if possible.
    * removing `_` from `syn iskeyword` fixes it.


## Tex Begin-End

```vim
 syn match texBadMath		"\\end\s*{\s*\(displaymath\|equation\|eqnarray\|math\|align\)\*\=\s*}"
 ...
 call TexNewMathZone("E","align",1)
```

## pandoc math highlight is broken in numbered lists, hard-wrapped lines
List itself is not broken. Because of the preceding 4 spaces, the line is recognized as a code block.
`let g:pandoc#syntax#protect#codeblocks = 0` fixes it.

## `gq` in pandoc lists is broken
Vim runs `undo_ftplugin` for pandoc because default `Filetype markdown` gets triggered at first `InsertEnter`.
This will reset several format-related settings, which breaks `gq` for markdown lists.
To fix this, manually reset all of the relevant settings in `Filetype pandoc`.

# cursor movement on concealed string

```
setlocal concealcursor=n
```

This doesn't work as expected.

<https://vi.stackexchange.com/questions/4530/moving-over-conceal>

# local `.nvimrc`

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
* Better interaction of `hlsearch` and conceal?
* Restore default `iskeyword` inside pandoc code block: it's impossible.
* Convert magic to ripgrep regex. Probably impossible.
  - unescape: `\(abc\) -> (abc), \~ -> ~, \/ -> /`
  - escape: `(abc)->\(abc\), {abc} -> \{abc\}`
  - don't touch: `\., \$, \^, \\ `


# Tips
* `dw`: to remove whitespace from current position.

# pitfalls
* `:h map-bar`
* Wrap `autocmd`s with `exec 'au ...'`: may not work as expected because of the interaction w/ `|`
* Matching `errorformat` may fail if the output from `:AsyncRun ...` is complex & quickfix is already open.
  Probably the output should be buffered.

