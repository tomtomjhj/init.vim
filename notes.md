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
    * "n", "N" (→ `/_CTRL-G`, `/_CTRL-T`), "(", ")", "[[", "]]", "{", "}", "L", "H"
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
          " timeout? set of built-in and mappings
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
* ignore folded region while searching
* unified framework for pair matching: surround/sandwich + matchit/matchup + auto-pairs/pear-tree + nvim-ts-rainbow ...
* automatically apply patches for plugins that I don't want to fork
    * pre-PlugUpdate command
    * command to checkout,PlugUpdate,patch
* abbrev tex commands with unicode
* https://github.com/lervag/vimtex/issues/1937
* `debug-mode`?
* how to make `Gdiffsplit` do `--follow`?
* Textobj plugins can be lazy-loaded with manual `s:lod_map`

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
* `:match`
* http://vimcasts.org/blog/2013/03/combining-vimgrep-with-git-ls-files/
* https://vimways.org/2018/death-by-a-thousand-files/

## dictionary (`i_CTRL-X_CTRL-K`)
```vim
" e.g. https://github.com/first20hours/google-10000-english/blob/master/20k.txt
let frequent = {}
for w in getbufline(bufnr('20k.txt'), 1, '$')
    let frequent[w] = 1
endfor

Execute g/^/if get(g:frequent, getline('.'), 0) | echo getline('.') | endif

g/\v(\W|\u|[^ius]s$|ed$)/d
g!/.\{6,\}/d
```
```sh
fd -t f -e EXT -x cat {} | tr '[:punct:]' ' ' | tr 'A-Z' 'a-z' | tr -s ' ' | tr ' ' '\n' | sort | uniq -c | sort -rn
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
* `i_CTRL-R_CTRL-` `R/O/P`
* surround `f/F/^F`
* grep + `:cdo s/../..`
* `:cabove`
* `backtick-expansion`

# pitfalls
* Cursor movement on concealed string: `set concealcursor=n` doesn't work as expected. <https://vi.stackexchange.com/questions/4530/moving-over-conceal>
* `:h map-bar`
* Wrap `autocmd`s with `exec 'au ...'`: may not work as expected because of the interaction w/ `|`
* Matching `errorformat` may fail if the output from `:AsyncRun ...` is complex & quickfix is already open.
  Probably the output should be buffered.
* Terminals can't distinguish some keys e.g. `<ESC>` and `<C-[>`, .. . `<M-[>` is prefix of `<PageUp>`, ...
    * vim won't receive `<C-q>` if `<C-q>`,`<C-s>` is enabled in the terminal
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
* recording doesn't work well with async completion → **TODO** `wildcharm`?
* `gq` internal formatting uses `indentexpr` (not documented?)
* `<C-k><space><space>` is non-break space! Can't disable with
    * `exe "digraph \<Space>\<Space> 32"`
    * `exe "inoremap \u00A0 <Space>"`
    * check patch 8.2.3184: cannot add a digraph with a leading space
* lightline
    * separator highlighting is optimized for fancy stuff like `'separator': { 'left': '', 'right': '' }, 'subseparator': { 'left': '', 'right': '' }` ([issue](https://github.com/itchyny/lightline.vim/issues/85)) → using `' '` for separator results in some odd whitespaces
    * `component_expand` is not per-window
* `expand()` before passing to `filereadable()` (for `~`)
* `useopen` applies to `CTRL-W_CTRL-]` and `:sfind` etc but I only want it for quickfix commands.
* `formatexpr` and `indentexpr` silence errors
* ftplugin runs before other `au FileType` because the `filetype plugin indent on` is usually invoked before defining other autocmds (so the order is not built-in).
* `:filetype on` runs ftdetect scripts. So `runtimepath` should be set before `:filetype on`. If `SYS_VIMRC_FILE` runs `:syntax on` (which runs `:filetype on`), it should be reset by `:filetype off`.
  This is unnecessary for `:packadd`-based plugin management.

# (n)vim problem
* terminal reflow https://github.com/neovim/neovim/issues/2514
    * best: make it work like normal buffer with `nowrap`
    * running tmux inside the termianl:
        * reflow works but scrolling is broken
        * automation? maybe check `$VIM` in bashrc
* nvim creates empty undo when editorconfig TrimTrailingWhitespace is used (https://github.com/neovim/neovim/issues/11987) (https://github.com/neovim/neovim/pull/11988)
* nvim's `CursorMoved` is differrent from vim's. This makes `vimtex_matchparen` wrongly hightlight fzf floatwin.
* shada merging bad https://github.com/neovim/neovim/issues/4295
    * impossible to wipe marks, registers, jumplist...
    * `:wshada!` https://vi.stackexchange.com/a/26540
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
* treesitter
    * sometimes both vim syntax and treesitter hightlighting are on
    * breaks `<cword>`?
* https://github.com/neovim/neovim/issues/14298
  Similar issue in vim without tmux when mapping `<M-]>`.
  `vim --clean -c 'map <ESC>] <M-]>'` to reproduce.
* previewheight is ignored if pedit is run on window with
  `vim --clean`, `set lines=74`
  ```
  wincmd s | wincmd j | set wfh | exe "norm! z13\<CR>" | pedit file
  wincmd s | wincmd j | set wfh | exe "norm! z14\<CR>" | pedit file
  ```
* In diff mode, editing in insert mode keeps moving the view. Triggered by `<CR>` and inserting a character for the first time after the last `<CR>` or entering the insert mode. Not related to `set diffopt+=algorithm:histogram,indent-heuristic`.

# stuff
* https://arxiv.org/abs/2006.03103
* https://teukka.tech/vimloop.html
* https://blog.fsouza.dev/prettierd-neovim-format-on-save/
* http://nikhilm.github.io/uvbook/ https://github.com/luvit/luv/tree/master/examples/uvbook
* https://github.com/tweekmonster/helpful.vim https://www.arp242.net/vimlog/ https://axelf.nu/vim-helptag-versions/

## plugins
* https://github.com/machakann/vim-sandwich
* https://github.com/mg979/vim-visual-multi
* https://github.com/chrisbra/unicode.vim
* https://github.com/chaoren/vim-wordmotion
* https://github.com/tpope/vim-obsession
* https://github.com/lpinilla/vim-codepainter
* https://github.com/kshenoy/vim-signature marks
* https://github.com/lambdalisue/fern.vim
* lsp stuff
    * https://github.com/jose-elias-alvarez/null-ls.nvim
    * https://github.com/RishabhRD/nvim-lsputils
    * https://github.com/ray-x/lsp_signature.nvim
    * https://github.com/simrat39/rust-tools.nvim
    * https://github.com/weilbith/nvim-lsp-smag
* https://github.com/RRethy/nvim-treesitter-textsubjects
  https://github.com/vigoux/architext.nvim
* git
    * https://github.com/junegunn/gv.vim
    * https://github.com/rhysd/conflict-marker.vim
    * https://github.com/pwntester/octo.nvim
    * https://github.com/TimUntersberger/neogit
    * https://github.com/lewis6991/gitsigns.nvim
* https://github.com/nvim-telescope/telescope.nvim
  https://github.com/nvim-telescope/telescope-frecency.nvim
* https://github.com/vhyrro/neorg
  https://github.com/kristijanhusak/orgmode.nvim
* https://github.com/vijaymarupudi/nvim-fzf
* https://github.com/jbyuki/instant.nvim
  https://github.com/jbyuki/nabla.nvim
  https://github.com/jbyuki/venn.nvim
* https://github.com/mfussenegger/nvim-dap
* https://github.com/lukas-reineke/indent-blankline.nvim NOTE: conflict with tab listchar
* https://github.com/phaazon/hop.nvim/
  https://github.com/ggandor/lightspeed.nvim
* https://github.com/rktjmp/lush.nvim interesting lua hack for DSL
* https://github.com/hkupty/iron.nvim
* https://github.com/Julian/lean.nvim

# new (n)vim stuff
* (8.2.1978) `<cmd>` can simplify `<C-r>=` stuff e.g. sword jump.
