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
* fzf: make a feature request for ivy-like actions
* <https://vimways.org/2018/from-vimrc-to-vim>

## Done
* Loading ultisnip at `InsertEnter` fires `FileType` again. Why?????
  This breaks non-idempotent operations at `FileType` like `AutoPairsDefine({}, ["'"])`
    * Just disable lazy load as it turns out that loading ultisnip isn't slow.
    * The root cause might be related to loading something that contains filetype plugin.
* auto-pairs adds weird indent if the previous line ends with `,`. Indent size if the size of the first word in the previous line.
    * reset `indentexpr` just before running `=k` in auto-pairs
* Restore default `iskeyword` inside pandoc code block: it's impossible.
* rust-analyzer provides better completion but doesn't have proper diagnostics
    * use coc-rust-analyzer

# Tips
* `dw`: to remove whitespace from current position.
* `q.push(\w\+\w\@!,\@!`: enforce `\w\+` to consume all `\w`
    * `\@<!`
* `strcharpart(strpart(line, col - 1), 0, 1)`
* `<C-\><C-o><ESC>` to reset insert starting point after ins-special-special
* cmdline-completion
* <https://superuser.com/a/1454131/1089985>
* <https://blog.antoyo.xyz/vim-tips>
* `/_CTRL-L`, `/_CTRL-G`, `/_CTRL-T`
* yank matching lines <https://stackoverflow.com/a/1475069>
* <https://vi.stackexchange.com/questions/17227/>
* sub-replace-expression
* `c_<C-R>_<C-W>`
* https://vim.fandom.com/wiki/Search_across_multiple_lines#Searching_over_multiple_lines_with_a_user_command
* http://karolis.koncevicius.lt/posts/porn_zen_and_vimrc/
    ```vim
    nnoremap <silent> J :<c-u>call <sid>Move(0, 0)<cr>
    nnoremap <silent> K :<c-u>call <sid>Move(1, 0)<cr>
    vnoremap <silent> J :<c-u>call <sid>Move(0, 1)<cr>
    vnoremap <silent> K :<c-u>call <sid>Move(1, 1)<cr>
    onoremap J V:call <sid>Move(0, 0)<cr>
    onoremap K V:call <sid>Move(1, 0)<cr>
    " paragraph edge
    func! s:Move(isUp, isInVisual)
      if a:isInVisual
        normal! gv
      end
      let curpos = getcurpos()
      let firstline='\(^\s*\n\)\zs\s*\S\+'
      let lastline ='\s*\S\+\ze\n\s*$'
      let flags = 'Wn'. (a:isUp ? 'b' : '')
      " Move to first or last line of paragraph, or to the beginning/end of file
      let pat = '\('.firstline.'\|'.lastline.'\)\|\%^\|\%$'
      " make sure cursor moves and search does not get stuck on current line
      call cursor(line('.'), a:isUp ? 1 : col('$'))
      let target=search(pat, flags)
      if target > 0
        let curpos[1]=target
        let curpos[2]=curpos[4]
      end
      call setpos('.', curpos)
    endfunc
    ```

# pitfalls
* `:h map-bar`
* Wrap `autocmd`s with `exec 'au ...'`: may not work as expected because of the interaction w/ `|`
* Matching `errorformat` may fail if the output from `:AsyncRun ...` is complex & quickfix is already open.
  Probably the output should be buffered.
* Terminals can't distinguish some keys e.g. `<ESC>` and `<C-[>`, .. . `<M-[>` is prefix of `<PageUp>`, ...
    * vim won't receive `<C-q>` if `<C-q>`,`<C-s>` is enabled in the terminal
* `inoremap <C-w> <C-R>=execute("norm db")<CR><C-R>=col('.')==col('$')-1?"\<lt>C-G>U\<lt>Right>":""<CR>`
  This still breaks undo after ins-special-special and is still broken at the line end.
* `<C-w>]` doesn't open in new tab if `switchbuf=useopen` which is useful for quickfix stuff.
* `<ESC>` is somewhat different from `CTRL-C`: c (`/`, `?`), i, v, ..
* `<Up>` is slightly different from `<C-p>`
* after/indent doesn't work as expected?
* function without `return` returns 0. insert explicit `return ''` for side-effect only function for `<C-R>=` trick.

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
