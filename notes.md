# Notes
* `strcharpart(strpart(line, col - 1), 0, 1)`
* `<C-\><C-o><ESC>` to reset insert starting point after ins-special-special
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
* width of unicode characters: 가(2) vs ◯(1)
    * ambiguous width characters
        * gnome-terminal -> compatibility -> ambiguous-width characters = wide, and `set ambiwidth=double`
        * how to do this in emacs?
        * too intrusive
* vimtex text objects in markdown <https://github.com/lervag/vimtex/issues/1937>
* `call serverlist()` to refresh `$DISPLAY` (when not in sync due to e.g. ssh hang caused by xclip or whatever)
* how to make `Gdiffsplit`, `G blame` do `--follow`?
  e.g. git diff-ing a file that moved, without specifying the old name
    * <https://github.com/tpope/vim-fugitive/issues/2070>
* `CCR` <https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86>.
    * Related: `CmdlineLeave`. Vim doesn't support `v:event.abort`.
      ```
      au CmdlineLeave * if expand('<afile>') =~ '[/?]' && !get(v:event, 'abort', 0) | let g:search_mode = '/' | endif
      ```
* <https://www.reddit.com/r/neovim/comments/15c7rk3/quickfix_editing_tips_worth_resharing/>
  <https://github.com/itchyny/vim-qfedit>
  <https://github.com/jceb/vim-editqf>


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


Another annoying issue: It's not possible to set default highlight to NONE.
* Things like `hi! def link .. NONE`, `hi! def link .. DummyGroup`, and `hi ... key=NONE` don't work.
  They just clear the highlight, making it overridable with `hi def link`.
* Linking to Normal is not great, because it will keep using Normal even in floating windows.

## buffer-updates
```
lua vim.api.nvim_buf_attach(0, false, {on_lines = function(_, bufnr, tick, first, old_last, new_last, _, _, _) print('lines', tick, first+1, old_last+1, new_last+1) end})
lua vim.api.nvim_buf_attach(0, false, {on_bytes = function(_, bufnr, tick, srow, scol, sbyte, erow, ecol, ebyte, nrow, ncol, nbyte) print('bytes', tick, vim.inspect({ {srow, scol, sbyte}, {erow, ecol, ebyte}, {nrow, ncol, nbyte} })) end})
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
* Commentary is for quickly commenting out **lines of code** and reverting it.
    * Out of scope: fancy comments.
        * three-piece comment `/*\n *\n */`
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
* Doesn't work well with empty comment line.
  This is kinda reasonable because commentary doesn't add comment marker to empty lines.
  Fixed in my fork anyway.
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

note
* '--git-completion-helper'-based completion (fugitive #1265) doesn't complete many things for git log e.g. --grep

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
        * diagnostics vs. buf diagnostics
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
    * <https://github.com/evesdropper/dotfiles/tree/130676a682fda4cde5f28a28cf29028e16f2695c/nvim/luasnip#readme>
    * <https://www.ejmastnak.com/tutorials/vim-latex/luasnip.html>
* slow startup
* patch: add undo before expansion
* port snippets
    * Don't use snipmate format. Auto trigger, in-word expansion not supported in snipmate snippets? (snippy's support is proprietary)
    * for simple snippets without vim-specific stuff, use vscode snippet format. Reuse vsnip snippets.
        * note that they can have auto trigger (autotrigger), in-word expansion options (`wordTrig = false`) under `"luasnip"` key
    * for complex snippets (vim-specific, ...), use lua format
* <https://github.com/molleweide/LuaSnip-snippets.nvim>

## window-local mode
Vim doesn't have window/tab-local mapping, autocmd, etc.
* <https://github.com/neovim/neovim/issues/16263>
* <https://github.com/vim/vim/issues/9339>

Implementing in userspace:
autocmds + `<buffer>` + `b:`, `w:`
```
au BufLeave * unsilent echom 'BufLeave' bufnr() win_getid()
au WinLeave * unsilent echom 'WinLeave' bufnr() win_getid()
au WinEnter * unsilent echom 'WinEnter' bufnr() win_getid()
au BufEnter * unsilent echom 'BufEnter' bufnr() win_getid()
```
* BufEnter not triggerd when switching to window with the same buffer
* BufLeave → WinLeave → WinEnter → BufEnter
* Maintain a global registry of window-local job, then handle them using those autocmds.
* See my implementation of window-local lsp breadcrumb (`register_breadcrumb`)

See also
* <https://github.com/anuvyklack/hydra.nvim>

## automatic parenthesis closing
* no automatic balancing?
    * map opener to opener + closer
    * map `<C-g>` + opener (or double opener) to opener
    * don't map closer


## debugging
```
packadd termdebug
TermdebugCommand ./build/bin/nvim --headless --listen /tmp/nvim-debug.pipe
./build/bin/nvim --remote-ui --server /tmp/nvim-debug.pipe
```

Note that UI doesn't immediately reflect the editor state.
It should be `ui_flush`ed (i guess).
So editor state should be tracked with other methods.

can't control gdb window???

```
GDB: Failed to set controlling terminal
```
???

breakpoint condition on call stack
<https://stackoverflow.com/a/55358445>
Doesn't work???

For most of input this appears???
```
Detaching after vfork from child process N
```

# things that I should make more use of
* marks
* `:global`
    * `:g/foo/z=3`
    * `:g/^pat/y A` yank matching lines (run `qaq` first)
    * collapsing multiple blank lines
        * `:keepp g/^$/keepp,/./-j` (`:h collapse`, `:h range`). Need non-blank line at the end.
        * `:keepp g/^\_$\_s\+\_^$/d _`
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
    * editing macros:
        * ~~use digraph to input control characters? <BS> is not ^H~~
        * `let @q = "<C-r><C-r>=escape(@q, '\')<CR>`, ...
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
* select mode `<C-g>`. good for filling in snippet hole with default text. `<C-g>c<C-r>0`



# pitfalls
* Cursor movement on concealed string: `set concealcursor=n` doesn't work as expected. <https://vi.stackexchange.com/questions/4530/moving-over-conceal>
* Wrap `autocmd`s with `exec 'au ...'`: may not work as expected because of the interaction w/ `|`.
  Fixed in 8.2.3626.
* Matching `errorformat` may fail if the output from `:AsyncRun ...` is complex & quickfix is already open.
  Probably the output should be buffered.
* Terminals can't distinguish some keys e.g. `<ESC>` and `<C-[>`, .. . `<M-[>` is prefix of `<PageUp>`, ...
    * vim won't receive `<C-q>` if `<C-q>`,`<C-s>` is enabled in the terminal
* `<C-w>]` doesn't open in new tab if `switchbuf=useopen` which is useful for quickfix stuff.
* `<ESC>` is somewhat different from `CTRL-C`: c (`/`, `?`), i, v, ..
    * `i_CTRL-C` doesn't trigger `InsertLeave`!
    * `c_<Esc>` executes command when run from a map
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
* vim-plug does `doautocmd BufRead` when lazy-loaded plugin is loaded, which re-triggers `FileType`, etc.
  My patch 0f8833a682d1c07564927905efc49e5859c8b2e3.
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
    * 9.0.0917 `WinResized`?
    * For preview window, apply `previewheight`? Note: `:pedit` doesn't accept `{height}`, unlike `:copen`.
* NeoVim terminal slows down the UI if too much stuff is printed.
* `api-buffer-updates` is too fine-grained (triggered for each `b:changedtick` update). It's meant to be fine-grained, but it's too fine-grained for most use cases.
  ```
  lua vim.api.nvim_buf_attach(0, false, {on_lines = function(_, bufnr, tick, first, old_last, new_last, _, _, _) vim.print(tick, vim.api.nvim_buf_get_lines(bufnr, first, new_last, true)) end})
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
        * Vim's listener callback (`:h listener_add`) is called on redraw, or when the recorded changes are about to be invalidated.
* Nvim silences errors in autocmd. This is not related to [`shortmess`](https://github.com/neovim/neovim/wiki/FAQ#calling-inputlist-echomsg--in-filetype-plugins-and-autocmd-does-not-work). This makes debugging ftplugin difficult.
* `filename-modifiers` should be provided in the order defined in the documentation. `fnamemodify(name, ':h:~')` is wrong.
* ([#10900](https://github.com/vim/vim/issues/10900)) In vim, handling the output of `:!`, `:write_c`, etc is UI-specific. It's not possible to uniformly capture the output using `execute()`. Must use `system()` for shell commands.
* `-complete=file` et al. triggers expansion of `cmdline-special` in args.
  What about backtick-expansion?
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
  Use `gettabwinvar(win_id2tabwin(w)[0], w, ...)` instead.
* filetype.lua makes it difficult to debug vim ftplugin
* Many nvim lua plugins don't set `loaded_X`.
  So loading plugins is not idempotent.
  E.g. cmp source registration.
* window-local options are unintuitive
    * Window split may copy `:setlocal`-ed window-local options (`:h local-options`).
    * <https://github.com/neovim/neovim/issues/11525>
    * options
        * fold
        * **diff**
            * when using diff mode, it's impossible to create a new clean window/tab
        * ...
* How does modeline and OptionSet, FileType, ... interact?
  vim.secure.trust() should take account of modeline?
* https://vi.stackexchange.com/questions/37660/how-can-i-echo-a-message-with-newlines-so-it-is-displayed-with-line-breaks-and-i
* `cnoremap <CR> do-something-and-then-<CR>` (e.g., CCR) can't work correctly.
    * It should should send `<CR>` with `feedkeys("\<C-]>\<CR>", 'nt')`.
        * `<C-]>`: noremap prevents abbreviation expansion, so explicitly expand.
        * `feedkeys(.., 'nt')`:
          Ensures history update, which requires `some_key_typed`.
          A command may not have been typed, e.g., when `<Up>` is used...
          But why doesn't `<Up>` count as a typed key? File an issue?
    * Problem: `feedkeys()` may break non-noremap maps that use cmdline.
      There are quite many of them.
      There is no clean way to ensure that they use real `<CR>`.
      So just don't do this thing...
    * See also: <https://github.com/tpope/vim-repeat/issues/63>
* nvim winblend in terminal puts characters from the below window in the cell, so they are copied with terminal's functionality


# bugs

## terminal reflow
<https://github.com/neovim/neovim/issues/2514>
* best: make it work like normal buffer with `nowrap`
* running tmux inside the termianl:
    * reflow works but scrolling is broken
    * `set shell=tmux` <https://www.reddit.com/r/neovim/comments/umy4gb/tmux_in_neovim/>
* vim: big `termwinsize` width? ⇒ After the job finishes, highlight position is wrong.
* <https://github.com/neovim/neovim/pull/21124>

## `gq`-ing three-piece comment

When `gq`-ing three-piece comment, the line on which a start/end piece lies is treated specially.
Not documented in fo-table 'q'.
Related? <https://github.com/vim/vim/issues/1696>.

These lines are not joined properly by `gq`.
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

`formatlistpat` is not properly applied if the visual block contains the first line
```coq
(* Lorem
- ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,
*)
```

## treesitter integration low-level bugs
* breaks `<cword>`?
* `:range!` does not emit proper on_bytes <https://github.com/neovim/neovim/blob/d667e0e4142ba8eb8623971539b0f9eec78b7529/src/nvim/ex_cmds.c#L1200-L1202>

## treesitter grammar/query issues
* c: `preproc_arg → @function.macro` highlights macro definition body.
* `@function` → `@function.definition`?

## cannot control composition of extmark-based highlights
If multiple captures apply, their hightlights overlap.
Only the most precise one should be applied.
Maybe it should be configurable, because overlapping is sometimes useful.
Examples
* In `Box::new()`, "Box" is `@variable`, `@type`, `@namespace`, `@type`, and all of those highlights are applied.
  Only `@type` should be applied.
* Markdown fenced code block: `@text.literal` + highlights of the injected language.
  If `@text.literal` is bg-only, then should overlap.
* If title is underlined, it should overlap.

`hl_mode` (`:h nvim_buf_set_extmark`) supports `"replace"`, `"combine"`, `"blend"`, but only for virt text.
There's also `"hl_eol"`

Priority is configurable:
<https://github.com/nvim-treesitter/nvim-treesitter/blob/1b5a7334bb9862abafcf6676d2a2a6973d15ae3a/CONTRIBUTING.md#priority>.


## vim: mapping that starts with `<Esc>`
Without tmux, in gnome-terminal,
`vim --clean -c 'map <ESC>] <M-]>'`.

See also: https://github.com/neovim/neovim/issues/14298

## `previewheight` ignored in small window
`pedit` on horizontal split ignores `previewheight` if `winheight(0) < previewheight + 1`
```
vim --clean # previewheight=12
wincmd s | exe "norm! z13\<CR>" | pedit file
wincmd s | exe "norm! z14\<CR>" | pedit file
```

## gvim clears clipboard when exiting??
related? <https://github.com/neovim/neovim/issues/5799>

## `hi def link` + `hi clear`
Somewhat broken. See [note on colorscheme customization](#colorscheme-customization).

## typing imap prefix
When typing a prefix of imap, the typed char is displayed during the timeout. Is this intended?

## nvim lazyredraw affects visual mode highlight
In nvim, tex, `lazyredraw`, cursor on `\` of `\someTexCommand`, type `ve` instantaneously. Highlighted region is not drawn and the cursor is not redrawn at proper position. The statusline is redrawn (FixCursorHold.nvim triggers redraw after a while.)
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

## lazyredraw breaks cursor redrawing
If `'lazyredraw'`, when spamming j/k, cursor is not redrawn at the proper position.
Un-conceal works properly.

Sometimes reproducible with vimtex with large `'lines'`.

## matchit/matchup in markdown
In markdown, if line is like this: `< cursor ( )`, `%` doesn't work. `<` should be matched with `>`???

Not related to 2022-07-25 html ftplugin update.

## `:syn-include` bug

* `:syn-include` lua (e.g. lua heredoc, markdown) broken after recent lua syntax update:
  <https://github.com/neovim/neovim/pull/20240/files#diff-2419d762b0d117afe1c1f9c392b9ea3e2ba4270341e576ea6b0533d1ff583351>
  <https://github.com/marcuscf/vim-lua>.
  <https://github.com/vim/vim/issues/11277>

## `^@` in statusline
If a statusline compotent contains newline ("^@"), highlight is shifted.

## cmp-buffer dies
Sometimes cmp-buffer dead.
Can be fixed by `:edit`.
Happened when editing latex file.

## duplication of inserted text
Sometimes, nvim falls into a weird state in which exiting insert mode duplicates the inserted text.
`:bdelete` and reloading fixed the issue.
Happened when editing latex file.
Not related to count.
This happens after using `\begin{} ... \end{}` snippet.


Problem: `unlink_current_if_deleted()` can't detect partially deleted snippet
```
ibeg<C-l>name<Esc>ddPi<Esc>
```
```
\begin{name}

\end{\begin{name}
}
```
solution?:
* `active_update_dependents()` should fail if a dependent had been destroyed
* unlink_current on ++once InsertLeave?
* manually unlink? `:LuaSnipUnlinkCurrent`

## interaction of inline virtual text and visual-block insert
```
fn func1() -> usize { 0 }
fn func2() -> usize { 1 }
fn main() {
    let var1 = func1();
    let var2 = func1();
}
```
Enable LSP inlay_hint.
Change `func1` to `func2` with `v_b_c`.

## screen inconsistency
* rarely, screenpos  all zeros.
    * after modifying window layout? after diff? happens without diff.
    * skipcol seemed to be wrong when entering diff mode in this state
* rarely, displayed lines and the actual lines not consistent in diff mode
* when `'wrap'`, the displayed cursor position is not consistent with the actual cursor position (e.g., insert mode input, j/k, ...)
* unset/seting `'wrap'` seems to fix all the above issue
* https://github.com/vim/vim/issues/13528 이거랑 비슷한 문제 또있음.. breakindent 관련?
* smoothscroll still has topline problem. 2024-02-14
    * sometimes topline is wrapped even if there is nothing to be wrapped? interesting interaction with virtual text (e.g., diagnostics)

## treesitter problem
* perf tracking issue https://github.com/neovim/neovim/issues/22426
* treesitter doesn't report tree changes if nodes are only removed https://github.com/neovim/neovim/issues/23286

## cmp
sometimes cmp falls into the state where `<C-n>` doesn't insert the text.
`<C-y>` works.

In that case, check `require'cmp.view.custom_entries_view'._insert`.
Indeed the `pending` was `true`. Setting it back to `false` fixes the problem.
Sometimes indentkeys are messed up too.
So `feedkeys.call` is somehow failing during execution???

## :G blame scrollbind
affected by the cursor of the other window displaying the same buffer

## botright split window size
* botright split changes height of existing window even if it's winfixheight
    * winfixheight should be number option?
* but it doesn't change the height of quickfix window. the new window's height is too small

## lsp format
Sometimes lsp format falls into a state where `vim.lsp.buf.format` messes up the buffer text.

## leak?
* After opening huge file and :bwipe-ing it, the memory usage doesn't reduce.
* 10 min cpu time, memory 200 MB
* keep `:e`-ing 1000 line markdown buffer increase mem usage by several MB???
  Very likely to be related to treesitter.
  just call `vim.treesitter.start()` repeatedly..

```
rm -f /tmp/nvim-debug.pipe; heaptrack nvim --clean --headless --listen /tmp/nvim-debug.pipe
nvim --remote-ui --server /tmp/nvim-debug.pipe
```

## writing shada
```
Error detected while processing BufReadCmd Autocommands for "*.shada"..BufReadCmd Autocommands for "*.shada":
E605: Exception not caught: ++opt not supported
```

## lsp changetracking whole buffer
<https://github.com/neovim/neovim/issues/27383>

That seems to be the reason texlab crashes after `ggdGudG`.

# annoyances ingrained in vi(m)
* `ge` ... design of inclusive/exclusive stuff
* `^` vs `0`
* `Y`
* `n`, `;` is relative
  ```vim
  nnoremap <expr> n 'Nn'[v:searchforward]
  nnoremap <expr> N 'nN'[v:searchforward]
  nnoremap <expr> ; getcharsearch().forward ? ';' : ','
  nnoremap <expr> , getcharsearch().forward ? ',' : ';'
  ```
* `whichwrap` option. Why not absolute commands?
* `backspace=nostop` is not default
* `ignorecase` affects tag, ins-completion, ...


# improvement/plugin idea

## command for deleting whitespace block
There are user-level alternatives, but it's difficult to make it not break undo.
See my `FineGrainedICtrlW()`.

## hlsearch + conceal
Better interaction of `hlsearch` and conceal?
* disable conceal when hlsearch set?

I don't recall what I meant by this.

## better 'paragraph' and 'sentence'
* sentence is not customizable at all
* syntax-aware, e.g., markdown list, statement

## Timeout for built-in multi-char commands
Timeout for built-in multi-char commands so that it doesn't interfere with user mappings.

Emulation <https://stackoverflow.com/questions/12089482>.
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

## custom command modifier
(`<mods>`).
For smart splitting based on current window layout.

## unified framework for pair matching
surround/sandwich + matchit/matchup + auto-pairs/pear-tree + nvim-ts-rainbow ...

## multiple clients for single nvim instance
good for multi-monitor setup.
<https://github.com/neovim/neovim/issues/2161>.

## nofile no viminfo
`buftype=nofile` buffers be ignored from viminfo so that they don't clutter `oldfiles`.

Alternative:
It seems that the buffer is not added to viminfo if it doesn't have marks.
Clear the marks when deleting nofile buffer?

## flexible search
`/` without moving cursor:
If stuff to be found is not below the cursor, `/` will wrap, which is annoying.
Sometimes I just want to locate/highlight stuff that may be above the cursor without jumping, and jump when necessary.
I can use `?`, but that's even more annoying because that changes flips direction of `n`/`N`.

Jump without confirming search:
Sometimes I want to jump to something but maintain current search highlight.

Or, maybe the problem is that I'm using `/` for those purposes.
* `:match` is not incremental and window-local only.
* vim-mark: add nvim `:command-preview` and more ergonomic mappings

Related? <https://github.com/hrsh7th/vim-searchx>

## don't set jump for repetitive jump
Make repetitive jump commands' jumplist modification behave like `sneak-clever-s`.
Add jump only once so that jumplist is not cluttered with irrelevant locations.

For `n`/`N`, there are `/_CTRL-G`/`/_CTRL-T`.

Debounce?

## emacs-like character classes
word ≠ identifier

Other details
* make 𝓥 a word char? <https://github.com/vim/vim/commit/d489c9801b3aaf284d42643507bbfb9ce3bc0f2f>
    * if spellcheck is the problem, do something similar to `set spelllang=cjk`

## fold
nvim's optimization: don't update fold in insert mode.
* <https://github.com/neovim/neovim/pull/5299>,
  <https://github.com/vim/vim/pull/1045>,
  <https://github.com/neovim/neovim/issues/24324>,
  FastFold README,
  <https://vim.fandom.com/wiki/Keep_folds_closed_while_inserting_text>
* why?
    * slow computation
    * premature computation resulting in wrong folds that open during edit
* original: update the fold in the changed ranged
* nvim:
    * no fold update in insert mode.
    * no update fold after insert leave if fdm is syntax or expr... otherwise, need full buffer fold update, which would be slow. so insert mode edits can't ever update folds???
        * This sounds broken, but I've not been affected since I use treesitter fold and previously FastFold.
        * possible fix: in insert mode, collect ranges for which fold should be recomputed (or take over-approx), and recompute on InsertLeave
* fastfold: don't update folds during edits; update fold on fold cmd, write, ...
    * I think this should be implemented in vim. This is much saner than what vim and nvim does.
* nvim and fastfold optimizations don't fully fix the problem. vimtex fold is slow even during normal mode and `:w`. traditional expr fold is just too slow.
* treesitter fold
    * fast enough to eagerly compute
    * folds still can be wrong during edit
    * fold computation uses api, which requires deferral.
      So the deferred computation must always manually trigger fold update, regardless of insert mode.
      Currently this is done with `vim._foldupdate`, which does whole buffer update.
      `vim._foldupdate` is fast enough because it just reads the cache.
        * possible improvement: track the changed range and pass to `vim._foldupdate`
        * don't defer if not textlocked? is this possible?

FastFold problems
* expr fold (e.g. markdown) → Gdiffsplit → close diff → nofoldenable with residual diff fold when enabled.
  :diffoff disables fold if fdm was manual (FastFold sets fdm=manual).
  <https://github.com/vim/vim/blob/3ea8a1b1296af5b0c6a163ab995aa16d49ac5f10/src/diff.c#L1591-L1595>
* <https://github.com/Konfekt/FastFold/pull/74>

Some minor stuff:
* close all folds under the cursor (sub-tree) `zC` doesn't do this.
  solution: visual mode.
* ignore folded region while `/`-searching

## `:syn`-based highlight in extmark region
Use case:
When using treesitter-based syntax highlighting for markdown,
I want to use regex-based syntax highlighting for code block
if there's no treesitter parser for that language.

See `nvim_set_decoration_provider()`

In general, extmark-local anything.
* settings: `iskeyword`
* mappings (see also [window-local mode](#window-local-mode))

## window-local
See note on [window-local mode](#window-local-mode).

## recovering the view after `v_:`
something like this?
```
noremap : <Cmd>let _view = winsaveview()<CR>:
```

## `.` is not extensible
* "repeatable change" should be extensible at the core
* the command must be added to redo buffer
* `.` doesn't respect the map's `<silent>`

## composing operator-pending motions
Problem
* operator-pending motions and text objects should be predefined
* sometimes, what I want to do is not expressible in predefined stuff
* in that case, visual mode works, but that's not repeatable

Workaround: q-recording

Solution: composing omap on-the-fly?

## treesitter git conflict
Problem: git conflict marker breaks parsers

Solution:
If conflict marker detected, make top-level language tree with "git conflict" parser.
In does injection.combined to the original language.

## inactive stl if nvim is not focused
Problem: FocusLost/FocusGained are not reliable?

## zed's multi buffer
similar stuff
* quickfix-based: no support for multi-line entry
    * <https://github.com/stefandtw/quickfix-reflector.vim>
    * <https://github.com/gabrielpoca/replacer.nvim>
* dedicated buffer
    * <https://github.com/AndrewRadev/writable_search.vim>
    * <https://github.com/dyng/ctrlsf.vim> edit-mode

scribble
* "projection": it should behave as if the edits are happening inside the listed buffer
    * this can be applied to other things, e.g., narrowing,
* "multi-window": it's like a window containing multiple windows
    * multi-window itself should be scrollable, because it may contain a lot of windows
    * things that apply to whole buffer (e.g., `%` range) should apply to all contained windows' viewport
        * introducing some wrapper is ok-ish. `:Mw %s/x/y`. But making it seamless would be quite difficult
    * maybe can be simulated with floating windows


## multi select
it's like generalized version of `v_@-default` or `:g/pat/normal! @{reg}`
* why? avoid manual execution of `@` when movement to target position is not trivial (can't be part of macro)
* basically a nice interface to extmark management
* select regions and record them as extmarks
    * region can be either just a position or range
        * if range, replay with visual selection
    * commands to add/remove selection:
        * a normal mode command (for position)
        * an operator (for region)
    * presets: cword, cword matches, search, lsp reference, diagnostics, ..
    * command to move to next/prev selection (and visual select)
    * multiple set of selections, designated by count (conflicts with navigation)
* macro utils
    * provide simple wrapper that runs macro on each selections (using the navigation command)
    * need special case for the selection on which the macro is recorded
* alternatives
    * quickfix: provides similar primitives, but doesn't support ranges
    * vim-mark: only supports patterns

# todo

TODO: `yy` → non-linewise paste that collapses indent. Something like `pkJ`


# stuff
* https://arxiv.org/abs/2006.03103
* https://teukka.tech/vimloop.html
* https://blog.fsouza.dev/prettierd-neovim-format-on-save/
* http://nikhilm.github.io/uvbook/ https://github.com/luvit/luv/tree/master/examples/uvbook
* https://github.com/tweekmonster/helpful.vim https://www.arp242.net/vimlog/ https://axelf.se/vim-helptag-versions/
* https://zignar.net/2022/11/06/structuring-neovim-lua-plugins/
* https://gpanders.com/blog/state-of-the-terminal/

## plugins
* https://github.com/mg979/vim-visual-multi
* https://github.com/inkarkat/vim-visualrepeat
* https://github.com/chrisbra/unicode.vim
* https://github.com/chaoren/vim-wordmotion
* https://github.com/tpope/vim-obsession
* https://github.com/lpinilla/vim-codepainter
* https://github.com/kshenoy/vim-signature marks
* https://github.com/Konfekt/vim-compilers
* https://mg979.github.io/tasks.vim
* https://github.com/tpope/vim-tbone
* https://github.com/mikeslattery/nvim-defaults.vim https://github.com/tpope/dotfiles/blob/master/.vimrc
* lsp stuff
    * https://github.com/j-hui/fidget.nvim
    * https://git.sr.ht/%7Ewhynothugo/lsp_lines.nvim
    * https://github.com/ii14/lsp-command/
    * https://github.com/hrsh7th/nvim-gtd
    * https://github.com/SmiteshP/nvim-navic
    * https://github.com/utilyre/barbecue.nvim
    * https://github.com/kevinhwang91/nvim-ufo
* ale-like stuff
    * <https://github.com/jose-elias-alvarez/null-ls.nvim> (dead).
      Revived: <https://github.com/nvimtools/none-ls.nvim>
    * <https://github.com/stevearc/conform.nvim>
      Produces text edits, so preserves extmarks, etc.
      ale doesn't seem to do this (`ale#util#SetBufferContents`).
    * <https://github.com/mfussenegger/nvim-lint>
      Not necessary. ale now uses `vim.diagnostics`.
    * <https://github.com/neovim/neovim/pull/24338> ?
* treesitter
    * https://github.com/RRethy/nvim-treesitter-textsubjects
    * https://github.com/vigoux/architext.nvim
    * https://github.com/abecodes/tabout.nvim
    * https://github.com/Wansmer/treesj
    * https://github.com/drybalka/tree-climber.nvim
* git
      https://github.com/akinsho/git-conflict.nvim
    * https://github.com/pwntester/octo.nvim
    * https://github.com/TimUntersberger/neogit
    * https://github.com/lewis6991/gitsigns.nvim
    * https://github.com/sindrets/diffview.nvim
    * https://github.com/ldelossa/gh.nvim
* dir
    * https://github.com/stevearc/oil.nvim
* https://github.com/nvim-telescope/telescope.nvim
  https://github.com/nvim-telescope/telescope-frecency.nvim
* note
    * https://github.com/vhyrro/neorg
    * https://github.com/kristijanhusak/orgmode.nvim
    * https://github.com/epwalsh/obsidian.nvim
    * https://github.com/jakewvincent/mkdnflow.nvim
* selector
    * https://github.com/stevearc/dressing.nvim
    * https://github.com/lifepillar/vim-zeef
    * https://github.com/mfussenegger/nvim-qwahl
* https://github.com/jbyuki/instant.nvim
  https://github.com/jbyuki/nabla.nvim
* https://github.com/mfussenegger/nvim-dap
* https://github.com/lukas-reineke/indent-blankline.nvim NOTE: conflict with tab listchar
* motion
    * https://github.com/phaazon/hop.nvim/
    * https://github.com/ggandor/leap.nvim
    * https://github.com/chrisgrieser/nvim-spider
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
* https://github.com/kevinhwang91/nvim-bqf
* https://github.com/nvim-pack/nvim-spectre
* https://github.com/folke/neoconf.nvim
* https://github.com/habamax/vim-shout (vim9 only). vs. asyncrun?

## new (n)vim stuff
* (8.2.1978) `<cmd>` can simplify `<C-r>=` stuff e.g. sword jump.
