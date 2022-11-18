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
* better 'paragraph' and 'sentence' (not customizable at all)
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
* how to make `Gdiffsplit`, `G blame` do `--follow`?
    * <https://github.com/tpope/vim-fugitive/issues/2070>
* Textobj plugins can be lazy-loaded with manual `s:lod_map`
* search without confirming search, window-local search, jump with `/_CTRL-G`, ...
* refreshing clipboard `call setenv('DISPLAY', '...')`: The new value can be obtained by launching another shell.. how to automate? Note: `call serverlist()` seems to work
    * https://stackoverflow.com/questions/13634697/openssh-client-hangs-on-logout-when-forwarding-x-connections
* Shouldn't `buftype=nofile` buffers be ignored from viminfo (so that they don't clutter oldfiles)?
    * It seems that the buffer is not added to viminfo if it doesn't have marks. Clear the marks when deleting nofile buffer?

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

# Notes
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
* overriding autoload: `:runtime` the autoload file in a matching autoload file https://www.reddit.com/r/vim/comments/oq82hg/overriding_a_single_autoloaded_package_function/
* `:match`
* http://vimcasts.org/blog/2013/03/combining-vimgrep-with-git-ls-files/
* https://vimways.org/2018/death-by-a-thousand-files/
* `\%V`
* `hitest.vim`
* Inserting text from script and return to insert mode without (1) moving the cursor and (2) delaying the actual input (like `feedkeys()`, `<expr>`)
  `<C-\><C-o>:exe 'normal!' . (col('.') > strlen(getline('.')) ? 'a' : 'i') . "TEXT\<C-\>\<C-o>"<CR>`
* https://www.reddit.com/r/vim/comments/r9s36f/what_are_some_of_your_insert_mode_mappings/hnekp5r/?utm_source=reddit&utm_medium=web2x&context=3

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

## Colorscheme customization
* Context: highlight = syntax (`syntax/`, `after/syntax/`) + colorscheme (`:colorscheme`, `au ColorScheme`).
    * Syntax definition includes the default highlight links.
      A default link should point to a syntactic group e.g. builtin groups like `Statement`.
      This also applies to overriding a default link.
      If users do not like a default link, they should override the default link in `after/syntax/`.
    * ColorScheme definition links syntax groups to a color group (or give a color to the syntax group).
      If users want to change highlight of a syntax group when this specific colorscheme is active, they should override the current link in `au ColorScheme`.
    * NOTE: `FileType` and `ftplugin/` is not a right place to do any customization because `:syn-include` does not know it.
* Problem: There is no way to modify the default highlight link ONLY.
    * `hi def link` has no effect if the default link is already set.
    * `hi! def link` always overrides the current link.
      So `hi! def link` in `after/syntax/` may override `:hi! link` customizations done in `ColorScheme`.
* Desired:
  `hi! def link` should override the current link only if the current link is the same with the default link.
  This is useful for customizing syntax/highlight without affecting/being affected by
  colorschemes that have their own customizations.
* Workaround:
    * ✗ At the end of `after/syntax/` (after all `hi! def link`s), source the current colorscheme, and `doautocmd <nomodeline> ColorScheme`.
      The end result is the same, but doesn't sound like a good idea..
    * ✗ Set up a `au ColorSchemePre *` that runs `hi! def link`s?
      `hi clear` changes the behavior of subsequent `hi def link`.
      This is clearly a bug.
      ```
      syn keyword Group word
      hi def link Group Todo
      hi clear
      hi def link Group Comment
      " "word" is highlighted as Comment
      " if hi clear is run again, "word" is highlighted as Todo
      ```
    * ✗ `hi clear Group` and then `hi def link`?
      `hi clear` does not clear the default link.
    * ✗ `hi def link Group NONE` and then `hi def link`?
      Clears the current link, but
      doesn't clear the default link and the subsequent `hi def link` (without `hi clear` in between) has no effect at all, ending up with no current highlight.
    * ✗ `hi! def link Group NONE` and then `hi def link`.
      Overrides the default link, but following `hi clear` and `hi def link` overrides the current link (but not the default link, like above).
    * ✗ Set up a `au ColorScheme *` that runs `hi! def link`s.
      It overrides the default link and is not affected by `hi clear`.
      However, it may override the links of the colorscheme, which should be re-overridden in another `au ColorScheme`.
      Quite ugly.
    * ✓ In `after/syntax/`, put `hi! def link`. Make a function that does per-colorscheme `hi! link`. Immediately call this function and register it to `au ColorScheme`.


## buffer-updates
```
lua vim.api.nvim_buf_attach(0, false, {on_lines = function(_, bufnr, tick, first, old_last, new_last, _, _, _) vim.pretty_print(tick, first+1, old_last+1, new_last+1) end})
```
```
asdf
asdf
asdfqwer < first
asdfqwer
    qwer < old_last
    qwer
         < new_last
```

## operators
* use `relativenumber` for operator pending mode?
* `:h omap-info`

## commenting
Commentary
* Commetary is for quickly commenting out **lines of code** and reverting it.
    * Out of scope: fancy comments.
        * three-piece comment `/*\n *\n */` (`:Commentary!` somewhat works, though)
        * Rust doc comment `///`, `//!`.
* text object: don't span multiple paragraphs by default?
    * Current behavior is ok since commentary doesn't add comment marker to empty lines.
    * Paragraph motion doesn't work well for this case → just add an empty line.
      ```
      // commented code 1

      // commented code 2
      code
      ```
    * Make a visual mode mapping for text object, so that this can be adjusted when needed?
* Distinguishing actual comment and commented out code is not necessary if the comment is nested:
  ```
  // // comment
  // code
  ```
* `/1* *1/` thing for non-nesting comments (`strlen(r) > 2`)
    * not compatible with other editors
    * uncommenting works well without it
    * doesn't work for html? <https://github.com/tpope/vim-commentary/issues/65> it actually works now
    * make it customizable?
* forcing comment? (reverse of `:Commentary!`)
* Doesn't work well with empty comment line. Note that commentary doesn't add comment marker to empty lines.
    * Doesn't strip leading whitespace of non-empty comment line.
      ```
      # comment
      #
      ```
    * Leaves whitespace when when uncommenting indented empty comment line
      ```
        # comment
        #
      ```

## git log viewer
* maps
    * [ ] `FlogVDiffSplitRight`
    * [ ] show more commits
* implementation
    * `:{range}Git! -p`
      ```
      command! -bang -nargs=? -range -complete=customlist,fugitive#LogComplete GL <mods> <line1>,<line2>Git<bang> -p log --graph --format=format:'%h %as [%an]%d %s' -1111 <args>
      ```
        * This still creates temp file..
        * It's async.
          ```
          E21: Cannot make changes, 'modifiable' is off: keepalt 1111read /tmp/v35WKhM/10|silent 1,1111delete_|diffupdate
          ```
    * `:Git log` everytime
        * Refreshing: Run `<Plug>fugitive:gq` and re-run command with previous options.
        * `++curwin`
    * ✗ `fugitive#LogCommand()`: This is for `Gclog`
    * `fugitive#Command()` runs the command, and returns string of commands to run (e.g. to see the result).
        * example: `fugitive#Command(0,0,0,0,0, 'log',)`
    * `FugitiveExecute(args : list string)`
        * It doesn't use `s:SplitExpandChain()` (splits `<q-args>`, expands `%` and `fugitive-object`)


## plain text diagrams
https://blog.regehr.org/archives/1653

tools
* asciiflow
* DrawIt
* venn.nvim
* artist-mode
* https://buttersquid.ink
* https://github.com/ArthurSonzogni/Diagon
* https://ivanceras.github.io/svgbob-editor

## statusline & tabline

NOTE
* Subseparator is not necessary, and its implementation is complex.
* Systematic spacing: `'%( a)%( b)%( c) '`
* `STLFunc()` should do `component_expand` thing... but that doesn't seem to be necessary.
* In default tabline, cmp's pum is also counted as a window.


What to do with "global" things?
* what's global?
    * "workspace" things: are they actually global?. There's :lcd.
        * git HEAD vs. file status (`status --porcelain`)
        * diagnotics vs. buf diagnotics
    * actually global
        * `g:` things, like asyncrun status
* implementation
    * global statusline + winbar: wastes a line (separator) for each horizontal split
    * put global stuff in tabline and `showtabline=2`
    * when persistence is not needed, notification also works

git
* bulk update on `FugitiveChanged` (needed for e.g. git reset)? This requires some work.
    1. Group buffers by FugitiveGitDir
    2. git-status each group
    3. Match the output. If no output for a buffer, then "no change".


## Snippet

### snippet conversion
<https://github.com/smjonas/snippet-converter.nvim>
1. `source lua/tomtomjhj/snippets.lua`, `:ConvertSnippets`.
1. remove package.json
1. rename all.json → global.json
1. remove the empty pandoc snippet file
1.  fix `$VISUAL`
    ```
    vimgrep VISUAL vsnip/**
    cdo s/VISUAL/TM_SELECTED_TEXT
    cfdo update
    ```
1. manually port unconverted snippets

### vsnip
* bug: <https://github.com/hrsh7th/vim-vsnip/issues/254>
  vsnip detects out-of-snippet-placeholder edits by diffing.
  But diff cannot point out where I inserted char if the same char is repeated.

### CoC
* CoC can use vsnip snippets if it has package.json.
  (snippet-converter makes generates that.)
  Just add add `vsnip/` to rtp.
  CoC will recognize it as a CoC extension.

### LuaSnip
* many features comparable to ultisnips
* conversion
  <https://www.reddit.com/r/neovim/comments/xq8n3d/i_made_a_guide_on_converting_ultisnips_to_luasnip/>
  <https://github.com/evesdropper/dotfiles/tree/130676a682fda4cde5f28a28cf29028e16f2695c/nvim/luasnip#readme>
* slow startup
* patch: add undo before expansion
* port snippets
    * Don't use snipmate format. Auto trigger, in-word expansion not supported in snipmate snippets? (snippy's support is proprietary)
    * for simple snippets without vim-specific stuff, use vscode snippet format. Reuse vsnip snippets.
        * note that they can have auto trigger (autotrigger), in-word expansion options (`wordTrig = false`) under `"luasnip"` key
    * for complex snippets (vim-specific, ...), use lua format
* <https://github.com/molleweide/LuaSnip-snippets.nvim>


# things that I should make more use of
* marks
* `:global`
    * `:g/foo/z=3`
    * `:g/^pat/y A` yank matching lines (run `qaq` first)
    * `:keepp g/^$/keepp,/./-j` reduces multiple blank lines to a single line. (`:h range`)
* `zi`
* `i_CTRL-D`, `i_CTRL-T`, `i_CTRL-F`
* `:@`, `@:`
* `scroll-cursor`
* `g0`, `g$`, `g_`, `zH`, `zL`
* `g;`, `g,`
* `complete_CTRL-Y`, `complete_CTRL-E`
* wildmenu filename completion `<Left>` `<Right>` `<Down>` `<Up>`
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
* yanking a line character-wise (not using `yy`) so that I can paste without trailing newline
* appending to register to collect list of something + recording


# issues

## Not triaged
* While editing tex, something is doing async redraw. Incsearch highlight disappears.

## (n)vim pitfalls
* Cursor movement on concealed string: `set concealcursor=n` doesn't work as expected. <https://vi.stackexchange.com/questions/4530/moving-over-conceal>
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
    * `lightline#update()`
        * <https://github.com/itchyny/lightline.vim/issues/352>
        * <https://github.com/neovim/neovim/issues/16872>
* `expand()` before passing to `filereadable()` (for `~`)
* `useopen` applies to `CTRL-W_CTRL-]` and `:sfind` etc but I only want it for quickfix commands.
* `formatexpr` and `indentexpr` silence errors
* ftplugin runs before other `au FileType` because the `filetype plugin indent on` is usually invoked before defining other autocmds (so the order is not built-in).
* `:filetype on` runs ftdetect scripts. So `runtimepath` should be set before `:filetype on`. If `SYS_VIMRC_FILE` runs `:syntax on` (which runs `:filetype on`), it should be reset by `:filetype off`.
  This is unnecessary for `:packadd`-based plugin management.
* If `lazyredraw` is set, entering cmdline-mode with a mapping doesn't update the statusline.
    * Manually: `noremap <C-g> :<C-u>Grep <Cmd>redrawstatus<CR>`
    * `redrawstatus` on `CmdlineEnter`: Mappings that enter&exit cmdline mode also trigger this. Must use `<Cmd>`.
* vim-plug can't lazy-load lua plugins.
    * issues
        * `plug#load` only sources `.vim` files. <https://github.com/hrsh7th/nvim-cmp/issues/65>
        * Order of `setup()` and `plugin/*.lua` sourcing?
    * impatient.nvim makes lua plugin startup fast enough.
    * <https://github.com/junegunn/vim-plug/pull/1157>
* Once a map prefix is entered, single-char mapping doesn't take the effect.
  Example: With `map! <Nul> <C-Space>` and `noremap! <C-Space><C-Space> XXX`, `<Nul><Nul>` becomes `<C-Space><Nul>`.
* `vimgrep`, `*`, `gd`, etc ignore `smartcase`
* Vim TUI doesn't highlight empty cell as `Normal` in most cases. It seems to use terminal's default fg/bg.
    * This makes cursor less visible (or invisible) for light colorscheme vim + dark colorscheme terminal.
    * NeoVim highlights all cells as `Normal`.
    * Taking some actions (e.g. visual selection) adds `Normal` highlight.
* If `winfixheight` (e.g. preview, quickfix), making it vertical (e.g. `<C-w>L`) and then horizontal back makes it occupy almost entire screen.
    * Detect this on `WinScrolled` (new feature)?
      ```vim
      au WinScrolled * if &previewwindow && (winnr('j') != winnr() || winnr('k') != winnr())
                     \|  noautocmd exe 'normal! z' . &previewheight . "\<CR>"
                     \|  noautocmd vertical wincmd =
                     \|endif
      ```
      Bug? `WinScrolled` is fired when entering preview window for the first time.
    * For preview window, apply `previewheight`? Note: `:pedit` doesn't accept `{height}`, unlike `:copen`.
* NeoVim terminal slows down the UI if too much stuff is printed.
* `api-buffer-updates` is too fine-grained (triggered for each `b:changedtick` update). It's meant to be fine-grained, but it's too fine-grained for most use cases.
  ```
  lua vim.api.nvim_buf_attach(0, false, {on_lines = function(_, bufnr, tick, first, old_last, new_last, _, _, _) vim.pretty_print(tick, vim.api.nvim_buf_get_lines(bufnr, first, new_last, true)) end})
  au TextChanged *  unsilent echom 'TextChanged'  b:changedtick
  au TextChangedI * unsilent echom 'TextChangedI' b:changedtick
  au TextChangedP * unsilent echom 'TextChangedP' b:changedtick
  ```
    * comparison with other stuff
        * `TextChanged`/`TextChangedI`/`TextChangedP`: on each redraw (search `EVENT_TEXTCHANGED`; `normal_check`/`normal_check_text_changed`, `ins_redraw`)
        * changes `:changes`?
    * case study:
        * ins-completion and built-in pum: *very* frequent; 3 × length of completed item???
        * `<C-w>`/`<C-u>`: bump for each char
        * `gq`: more than once for each line
        * `=` without indentexpr
        * `:{range}s`: only once for the whole changes, even if not contiguous. But undo is per line.
        * undo/redo: ??
        * `:g`: for each matched line
    * problems
        * too much cpu usage: floods cmp-buffer indexer; noticeably slow when using native pum
        * Nvim lsp client reports diagnostics for each changedtick even if debouncing is used. Example: lua-language-server, `gq` on comments.
    * solutions
        * add coarser per-change event?
            * changes might not be contiguous
        * generic debouncing + event merging?
            * `changetracking.prepare` in `lsp.lua`: "This must be done immediately and cannot be delayed. The contents would further change and startline/endline may no longer fit"
                * maintain set of line numbers to be diffed, adjust like what cmp-buffer does
                * snapshot of buffer for each debounced period?
            * cmp-buffer: maintain set of line numbers to be indexed
    * see also?
        * <https://github.com/vim/vim/issues/679>
* `map` includes `smap`
* Nvim silences errors in autocmd. This is not related to [`shortmess`](https://github.com/neovim/neovim/wiki/FAQ#calling-inputlist-echomsg--in-filetype-plugins-and-autocmd-does-not-work). This makes debugging ftplugin difficult.
* `filename-modifiers` should be provided in the order defined in the documentation. `fnamemodify(name, ':h:~')` is wrong.
* ([#10900](https://github.com/vim/vim/issues/10900)) In vim, handling the output of `:!`, `:write_c`, etc is UI-specific. It's not possible to uniformly capture the output using `execute()`. Must use `system()` for shell commands.
* `-complete=file` et al. triggers expansion of `cmdline-special` in args.
  ```
  command! -nargs=* Asdf echo [<f-args>]
  command! -nargs=* -complete=file Asdf echo [<f-args>]
  command! -nargs=* -complete=dir Asdf echo [<f-args>]
  ```
* `:map` includes select mode.
* escaping
    * escaping functions: `escape()`, `fnameescape()`, `shellescape()`
    * avoid using Ex-command when possible
    * `:command` parsing options: `<f-args>`, `-bar`, `-complete=file`, `-nargs`, ...
    * `:set` escaping
    * `++opt`, `+cmd` options for e.g. `:edit`
        * `:file` and `:cd` don't take those options but works fine when `+` is escaped.
    * `map-bar`
    * ...
* `bufadd()` doesn't trigger `BufAdd`. What you want is `BufNew`.
* `getwinvar()` doesn't work for window ID of window in different tab.
* filetype.lua makes it difficult to debug vim ftplugin
* Many nvim lua plugins don't set `loaded_X`.
  So loading plugins is not idempotent.
  E.g. cmp source registration.


## (n)vim bugs
* terminal reflow https://github.com/neovim/neovim/issues/2514
    * best: make it work like normal buffer with `nowrap`
    * running tmux inside the termianl:
        * reflow works but scrolling is broken
        * `set shell=tmux` <https://www.reddit.com/r/neovim/comments/umy4gb/tmux_in_neovim/>
    * vim: big `termwinsize` width? ⇒ After the job finishes, hightlight position is wrong.
* nvim's `CursorMoved` is differrent from vim's. This makes `vimtex_matchparen` wrongly highlight fzf floatwin.
* shada merging bad https://github.com/neovim/neovim/issues/4295
    * impossible to wipe marks, registers, jumplist...
    * `:wshada!` https://vi.stackexchange.com/a/26540
    * Edit shada, `:rshada!`, exit.
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
    * frequently broken by diff mode
* https://github.com/neovim/neovim/issues/14298
  Similar issue in vim without tmux when mapping `<M-]>`.
  `vim --clean -c 'map <ESC>] <M-]>'` to reproduce.
* `pedit` on horizontal split ignores `previewheight` if `winhight(0) < previewheight + 1`
  ```
  vim --clean # previewheight=12
  wincmd s | exe "norm! z13\<CR>" | pedit file
  wincmd s | exe "norm! z14\<CR>" | pedit file
  ```
* gvim clears clipboard when exiting??
    * related? <https://github.com/neovim/neovim/issues/5799>
* `hi def link` + `hi clear` is somewhat broken
* nvim: If there's a mapping that starts with `<C-c>` in current mode (but not exactly `<C-c>`), `<C-c>` does not interrupt vimscript (loop, `:sleep`, ...). <https://github.com/neovim/neovim/issues/15258>
* When typing a prefix of imap, the typed char is displayed during the timeout. Is this intended?
* In nvim, tex, `lazyredraw`, cursor on `\` of `\someTexCommand`, type `ve` instantaneously. Highlighted region is not drawn and the cursor is not redrawn at proper position. The statusline is redrawn (FixCursorHold.nvim triggers redraw after a while.)
    * bisected: https://github.com/neovim/neovim/pull/17913 a9665bb12cd8cbacbc6ef6df66c1989b0c6f9fcc
    * Reproduction: `:highlight` when evaluating statusline (lightline), in buffer with a lot of text and complex syntax like latex or markdown
      ```vim
      let s:count = 0
      function! Hi()
          exe 'hi StatusLine' ('cterm=NONE') ('ctermfg=' . s:count) ('ctermbg=' . s:count)
          let s:count = (s:count + 1) % 256
          return ''
      endfunction
      set statusline=%{Hi()}
      set lazyredraw
      ```
    * analysis
        * `update_screen()` redraws the statusline
        * After typing `e`, the buggy version doesn't call `grid_cursor_goto` and `inbuf_poll`.
    * related? <https://github.com/neovim/neovim/pull/20582>
* matchit, matchup: In markdown, if line is like this: `< cursor ( )`, `%` doesn't work. `<` should be matched with `>`???
    *  Not related to 2022-07-25 html ftplugin update.
* `:syn-include` lua (e.g. lua heredoc, markdown) broken after recent lua syntax update:
  <https://github.com/neovim/neovim/pull/20240/files#diff-2419d762b0d117afe1c1f9c392b9ea3e2ba4270341e576ea6b0533d1ff583351>
  <https://github.com/marcuscf/vim-lua>.
  <https://github.com/vim/vim/issues/11277>
* if a statusline compotent contains newline ("^@"), highlight is shifted

## ...
* `ge` ... design of inclusive/exclusive stuff
* `^` vs `0`
* `Y`
* `n`, `;` is relative
* `whichwrap` option. Why not absolute commands?
* `backspace=nostop` is not default
* no command for deleting whitespace block

## wishlist
* timeout for built-in multi-char commands so that it doesn't interfere with user mappings
* character classes (like emacs); word ≠ identifier
* smarter folding


# stuff
* https://arxiv.org/abs/2006.03103
* https://teukka.tech/vimloop.html
* https://blog.fsouza.dev/prettierd-neovim-format-on-save/
* http://nikhilm.github.io/uvbook/ https://github.com/luvit/luv/tree/master/examples/uvbook
* https://github.com/tweekmonster/helpful.vim https://www.arp242.net/vimlog/ https://axelf.nu/vim-helptag-versions/

## plugins
* https://github.com/mg979/vim-visual-multi
* https://github.com/chrisbra/unicode.vim
* https://github.com/chaoren/vim-wordmotion
* https://github.com/tpope/vim-obsession
* https://github.com/lpinilla/vim-codepainter
* https://github.com/kshenoy/vim-signature marks
* https://github.com/Konfekt/vim-compilers
* https://github.com/dkarter/bullets.vim
* https://mg979.github.io/tasks.vim
* https://github.com/tpope/vim-tbone
* https://github.com/mikeslattery/nvim-defaults.vim https://github.com/tpope/dotfiles/blob/master/.vimrc
* lsp stuff
    * https://github.com/jose-elias-alvarez/null-ls.nvim
    * https://github.com/RishabhRD/nvim-lsputils
    * https://github.com/ray-x/lsp_signature.nvim
    * https://github.com/stevearc/aerial.nvim
    * https://github.com/gfanto/fzf-lsp.nvim
    * https://github.com/j-hui/fidget.nvim
    * https://git.sr.ht/%7Ewhynothugo/lsp_lines.nvim
    * https://github.com/ii14/lsp-command/
* https://github.com/RRethy/nvim-treesitter-textsubjects
  https://github.com/vigoux/architext.nvim
  https://github.com/abecodes/tabout.nvim
* git
    * https://github.com/rhysd/conflict-marker.vim
      https://github.com/akinsho/git-conflict.nvim
    * https://github.com/pwntester/octo.nvim
    * https://github.com/TimUntersberger/neogit
    * https://github.com/lewis6991/gitsigns.nvim
    * https://github.com/sindrets/diffview.nvim
    * https://github.com/ldelossa/gh.nvim
* https://github.com/nvim-telescope/telescope.nvim
  https://github.com/nvim-telescope/telescope-frecency.nvim
* https://github.com/vhyrro/neorg
  https://github.com/kristijanhusak/orgmode.nvim
* selector
    * https://github.com/vijaymarupudi/nvim-fzf
    * **<https://github.com/ibhagwan/fzf-lua>**
        * live_grep ↔ grep!
        * Preview buffer's ftdetect uses `:filetype detect`, which is somewhat broken? `*.v` file doesn't get recognized as coq.
        * Does not reuse the buffer for preview <https://github.com/ibhagwan/fzf-lua/issues/208#issuecomment-962550013>...
        * `require'fzf-lua'.setup` takes 5 ms. Fixed? https://github.com/ibhagwan/fzf-lua/issues/511
    * https://github.com/stevearc/dressing.nvim
    * https://github.com/lifepillar/vim-zeef
    * https://github.com/mfussenegger/nvim-qwahl
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
* https://github.com/gelguy/wilder.nvim
* https://github.com/chipsenkbeil/distant.nvim
* https://github.com/tomtom/tcomment_vim
  https://github.com/numToStr/Comment.nvim
  https://github.com/tyru/caw.vim
* https://github.com/mcchrish/vim-no-color-collections
  https://github.com/fxn/vim-monochrome
  https://git.sr.ht/~romainl/vim-bruin
  https://github.com/jeffkreeftmeijer/vim-dim
  https://github.com/noahfrederick/vim-noctu
  https://github.com/cocopon/iceberg.vim
* https://github.com/stevearc/gkeep.nvim
* https://github.com/m00qek/baleia.nvim
    * TODO: Use this for better syntax highlighting for diff filetype?

## new (n)vim stuff
* (8.2.1978) `<cmd>` can simplify `<C-r>=` stuff e.g. sword jump.
