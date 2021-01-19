# Tex & pandoc
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
* close all folds under the cursor (sub-tree) `zC` doesn't do this
* `<C-r><C-v>` to getvisual in cmap
* better 'paragraph'
    * markdown list
* fzf preview: <S-down> slow -> key code 분해됨
* make repetitive jump commands' jumplist modification behave like `sneak-clever-s`
    * "n", "N", "(", ")", "[[", "]]", "{", "}", "L", "H"
* Make prefix of built-in and user map time out <https://stackoverflow.com/questions/12089482>. 
  ```vim
  " breaks built in
  noremap <C-w> <C-w>
  noremap <C-w><C-q> <C-w><C-q>
  noremap g g
  noremap z z
  noremap [ [
  noremap ] ]
  " maybe it requires a whole new *mode*
  function s:CtrlW()
      let extra = ''
      while 1
          " TODO: timeout? set of built-in and mappings
          let c = getchar()
          if c == 0
              break
          endif
          let extra .= nr2char(c)
      endwhile
      return "\<C-w>" . extra
  endfunction
  nnoremap <expr> <C-w> <SID>CtrlW()
  ```
* make 𝓥 a word char? <https://github.com/vim/vim/commit/d489c9801b3aaf284d42643507bbfb9ce3bc0f2f>
    * if spellcheck is the problem, do something similar to `set spelllang=cjk`
* multiple clients for single nvim instance? good for multi-monitor setup. <https://github.com/neovim/neovim/issues/2161>
* bullet list block textobj, somewhat similar to haskell layout rule
* `/` without moving cursor
* custom command modifier? (`<mods>`) for smart splitting based on current window layout

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
* `equalalways`, `winfixheight`, ...
* [profiling](https://stackoverflow.com/a/8347244)
  ```
  vim --cmd 'profile start profile.log' \
      --cmd 'profile func *' \
      --cmd 'profile file *' \
      -c 'profdel func *' \
      -c 'profdel file *' \
      -c 'qa!'
  ```
* `arglist`
* overriding autoload
    ```vim
    " .vim/plugin/sneak/util.vim
    call sneak#util#strlen('')
    ...
    ```
  Maybe this is the only way to override autoload function. `:runtime` doesn't
  register the file as autoload file (?), so the file will be sourced again.
  https://groups.google.com/g/vim_dev/c/k9wRhNMNIFc/m/vpFvud0mo9UJ?pli=1

# things that I should make more use of
* marks
* `:global`
    * `:g/foo/z=3`
    * yank matching lines <https://stackoverflow.com/a/1475069>
* `zi`
* `i_CTRL-D`, `i_CTRL-T`, `i_CTRL-F`
* `:@`, `@:`
* `scroll-cursor`
* `g0`, `g$`, `g_`, `zH`, `zL`
* `g;`, `g,`
* `complete_CTRL-Y`, `complete_CTRL-E`
* `(`, `)`, `{`, `}`
* `/\C`
* `g<Tab>`
* `gJ`
* macros
    * `:h 10.1`
    * record → (jump → execute)*
    * If there's a *function* to jump (e.g. `gn`), the repetition step can be
      merged (e.g. `gn@@`) or jump can be part of the macro.
    * editing macros: use digraph to input control characters? <BS> is not ^H
* `g&`
* `g<`
* `_` without count is equivalent to `^`

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
* recording doesn't work well with async completion
* `gq` internal formatting uses `indentexpr` (not documented?)


# (n)vim problem
* terminal reflow https://github.com/neovim/neovim/issues/2514
    * best: make it work like normal buffer with `nowrap`
    * running tmux inside the termianl:
        * reflow works but scrolling is broken
        * automation? maybe check `$VIM` in bashrc
* nvim lsp, completion performance?
    * need some kind of delay before doing something
    * <https://github.com/nvim-lua/completion-nvim/issues/203>, <https://github.com/nvim-lua/completion-nvim/issues/231>
    * https://github.com/neovim/neovim/issues/13049
* nvim creates empty undo when editorconfig TrimTrailingWhitespace is used (https://github.com/neovim/neovim/issues/11987) (https://github.com/neovim/neovim/pull/11988)
* nvim's `CursorMoved` is differrent from vim's. This makes `vimtex_matchparen` wrongly hightlight fzf floatwin.
* showbreak breaks many things: blockwise paste, ..?
* copying window-local variables on split is not synchronous??
* jumplist is crazy
    ```vim
    0
    let [lnum, col] = searchpos('^\s*\zsProof\.', 'cnW')
    while lnum
        " this creates jumps????
        exe lnum
        exe 'normal! ' . col . '|'
        normal zf%
        normal! $
        let [lnum, col] = searchpos('^\s*\zsProof\.', 'cnW')
        " This prevents creating jumps ???????
        ju
    endwhile
    ```
  (just use `:global` for this specific task)
* shada merging bad https://github.com/neovim/neovim/issues/4295
    * impossible to wipe marks, registers, jumplist...
    * `:wshada!` https://vi.stackexchange.com/a/26540
* nvim fold click is (sometimes) broken
* nvim diff sync is broken: do diff (the buffer should be fresh e.g. wiped), jump to other window, enter insert → cursor position is wrong!
* The line on which a three-piece comment's start/end piece lies is treated specially by `gq`. Not documented in fo-table 'q'. Related? <https://github.com/vim/vim/issues/1696>.
    * These lines are not joined properly by `gq`.
      ```coq
      (* Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
      invidunt
      *)
      (* Lorem
      ipsum
      *)
      (* Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
      invidunt *)
      ```
    * `formatlistpat` is not properly applied if the visual block contains the first line
      ```coq
      (* Lorem
      - ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,
      *)
      ```

# stuff
* https://arxiv.org/abs/2006.03103
* https://teukka.tech/vimloop.html

# new (n)vim stuff
* (8.2.0590) `backspace+=nostop`
* (8.2.1978) `<cmd>` can simplify `<C-r>=` stuff e.g. sword jump.
