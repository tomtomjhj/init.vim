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


# TODO:
* Better interaction of `hlsearch` and conceal?
    * disable conceal when hlsearch set?
* git diff arbitrary commits inside nvim, diff mode usage, git-gutter,...
* sudoedit settings: undodir, ...
* `g]`-like commands can't be used in functions etc?
* fzf: make a feature request for ivy-like actions
* <https://vimways.org/2018/from-vimrc-to-vim>
* read cmdline.txt
    * `[range]`
* prabirshrestha/asyncomplete.vim
* coq highlights covering whole line
    * how does DiffAdd work?
* close all folds under the cursor (sub-tree) `zC` doesn't do this
* clear undo,backup,swap,view
* sneak digraph? alias? timeout?
* `<C-r><C-v>` to getvisual in cmap
* better 'paragraph'
    * markdown list
    * code commend
* fzf preview: <S-down> slow -> key code 분해됨
* make repetitive jump commands' jumplist modification behave like `sneak-clever-s`
    * "n", "N", "(", ")", "[[", "]]", "{", "}", "L", "H"

## Done
* Loading ultisnip at `InsertEnter` fires `FileType` again. Why?????
  This breaks non-idempotent operations at `FileType` like `AutoPairsDefine({}, ["'"])`
    * Just disable lazy load as it turns out that loading ultisnip isn't slow.
    * The root cause might be related to loading something that contains filetype plugin.
* Restore default `iskeyword` inside pandoc code block: it's impossible.
* width of unicode characters: 가(2) vs ◯(1)
    * ambiguous width characters
        * gnome-terminal -> compatibility -> ambiguous-width characters = wide, and `set ambiwidth=double`
        * how to do this in emacs?
        * too intrusive

# Tips
* `strcharpart(strpart(line, col - 1), 0, 1)`
* `<C-\><C-o><ESC>` to reset insert starting point after ins-special-special
* absolute n/N <https://superuser.com/a/1454131/1089985>
* <https://blog.antoyo.xyz/vim-tips>
* editing shada <https://vi.stackexchange.com/questions/17227/>
* sub-replace-expression
* https://vim.fandom.com/wiki/Search_across_multiple_lines#Searching_over_multiple_lines_with_a_user_command
* http://karolis.koncevicius.lt/posts/porn_zen_and_vimrc/
* `cmdline-completion`, `c_CTRL-D`
* `/_CTRL-L`, `/_CTRL-G`, `/_CTRL-T`
* `\{-`, `\@>`, `\@=`, `\@!`, `\@<=`, `\@<!`
    * `if \(\(then\)\@!.\)*$` "if " not followed by "then"
    * `\(\/\/.*\)\@<!in` "in" which is not after "//"
* forced-motion
* `sub-replace-special`
* `i_CTRL-R_CTRL-O` is fast
* equalalways
* [profiling](https://stackoverflow.com/a/8347244)
  ```
  vim --cmd 'profile start profile.log' \
      --cmd 'profile func *' \
      --cmd 'profile file *' \
      -c 'profdel func *' \
      -c 'profdel file *' \
      -c 'qa!'
  ```

# things that I should make more use of
* marks
* `:global`
    * `:g/foo/z=3`
    * yank matching lines <https://stackoverflow.com/a/1475069>
* `zi`
* `i_CTRL-D`, `i_CTRL-T`, `i_CTRL-F`
* `:@`, `@:`
* `scroll-cursor`
* `g0`, `g$`, `zH`, `zL`
* `g;`, `g,`
* `complete_CTRL-Y`, `complete_CTRL-E"`
* `(`, `)`, `{`, `}`
* `/\C`
* macros
    * `:h 10.1`
    * record → (jump → execute)*
    * If there's a *function* to jump (e.g. `gn`), the repetition step can be
      merged (e.g. `gn@@`) or jump can be part of the macro.
    * TODO: easier mapping for `@q`, `@@`, ...
    * TODO: pre-selecting points to run macros like multicursor? (difficult)
    * editing macros: use digraph to input control characters? <BS> is not ^H

# pitfalls
* Cursor movement on concealed string: `set concealcursor=n` doesn't work as expected. <https://vi.stackexchange.com/questions/4530/moving-over-conceal>
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
    * `i_CTRL-C` doesn't trigger `InsertLeave`!
* `<Up>` is slightly different from `<C-p>`
* after/indent doesn't work as expected?
* function without `return` returns 0. insert explicit `return ''` for side-effect only function for `<C-R>=` trick.
* `c_<C-R>_<C-W>`
  > With CTRL-W the part of the word that was already typed is not inserted again.

  That is not true if it's run manually (not from a mapping)????
* `=` does `C-indenting` when `equalprg` is not set
    * auto-pairs adds weird indent if the previous line ends with `,`. Indent size if the size of the first word in the previous line.
        * `<CR><C-c>O` (`nosmartindent`) vs. `<CR><C-c>=ko` (`&indentexpr != ''`)
* stuff highlighted as `Normal` -> bg doesn't match in floatwin
* lightline + cursorline + lazyredraw + large &lines = performance drop


# notes
* terminal reflow https://github.com/neovim/neovim/issues/2514

# stuff
* https://arxiv.org/abs/2006.03103
* https://teukka.tech/vimloop.html
