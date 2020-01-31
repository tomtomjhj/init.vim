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

The root cause was lazy-loading ultisnip at InsertEnter. Removed the hack.

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
* Convert magic to ripgrep regex. Probably impossible.
    - unescape: `\(abc\) -> (abc), \~ -> ~, \/ -> /`
    - escape: `(abc)->\(abc\), {abc} -> \{abc\}`
    - don't touch: `\., \$, \^, \\ `
* git diff arbitrary commits inside nvim, diff mode usage, git-gutter,...
* sudoedit settings: undodir, ...
* deoplete: filter prefix match and extract longest prefix
* `g]`-like commands can't be used in functions etc?


## Done
* auto-pairs adds weird indent if the previous line ends with `,`. Indent size if the size of the first word in the previous line.
    * reset `indentexpr` just before running `=k` in auto-pairs
* Restore default `iskeyword` inside pandoc code block: it's impossible.
* rust-analyzer provides better completion but doesn't have proper diagnostics
    - rust-analyzer source for deoplete? adapt vim-racer?
    - nvim lsp with rust-analyzer, use omnifunc only
    - ale rust-analyzer + cargo check (can't check unsaved buffer)
    * ✓ use LC for rust-analyzer completion only.
        * NOTE: rust-analyzer [adds unecessary `(…)` after
          method](https://github.com/rust-analyzer/rust-analyzer/blob/9712889ee4c6cffa37c2ace5da9b00bf29adab56/crates/ra_ide/src/completion/presentation.rs#L228).
          ALE somehow removes this but LC doesn't

# Tips
* `dw`: to remove whitespace from current position.
* `q.push(\w\+\w\@!,\@!`: enforce `\w\+` to consume all `\w`
* `strcharpart(strpart(line, col - 1), 0, 1)`
* `<C-\><C-o><ESC>` to reset insert starting point after ins-special-special
* cmdline-completion

# pitfalls
* `:h map-bar`
* Wrap `autocmd`s with `exec 'au ...'`: may not work as expected because of the interaction w/ `|`
* Matching `errorformat` may fail if the output from `:AsyncRun ...` is complex & quickfix is already open.
  Probably the output should be buffered.
* Loading ultisnip at `InsertEnter` fires `FileType` again. Why?????
  This breaks non-idempotent operations at `FileType` like `AutoPairsDefine({}, ["'"])`
    * Just disable lazy load as it turns out that loading ultisnip isn't slow.
    * The root cause might be related to loading something that contains filetype plugin.
* Terminals can't distinguish some keys e.g. `<ESC>` and `<C-[>`, ....
* `inoremap <C-w> <C-R>={-> execute("norm db")}()<CR><C-R>=col('.')==col('$')-1?"\<lt>C-G>U\<lt>Right>":""<CR>`
  This still breaks undo after ins-special-special and is still broken at the line end.
* `<C-w>]` doesn't open in new tab if `switchbuf=useopen` which is useful for quickfix stuff.

# hmm..
* I don't want to rely on `set whichwrap+=]` for quick jump but this doesn't
  work properly at the column `col('$')-1`
    ```vim
    inoremap <silent><C-j> <C-R>=QuickJumpRightKey()<CR>
    func! QuickJumpRightKey()
        return col('.') ==  col('$')
                    \ ? "\<C-\>\<C-O> "
                    \ : "\<C-\>\<C-O>:call search(g:quick_jump, 'ceW')\<CR>\<Right>"
    endfunc
    ```
    * use `<expr>`?
