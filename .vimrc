if &compatible | set nocompatible | endif
if has('win32')
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif

" stuff from sensible that are not in my settings {{{
set nrformats-=octal
set ttimeout ttimeoutlen=50
set display+=lastline
set tags-=./tags tags-=./tags; tags^=./tags;
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif
set tabpagemax=50
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif
" }}}

if !has('gui_running')
  " term=tmux-256color messes up ctrl-arrows
  if $TERM =~ '\(tmux\|screen\)-256' | set term=xterm-256color | endif
  " set to xterm in tmux, which doesn't support window resizing with mouse
  set ttymouse=sgr

  " NOTE: <M- keys can be affected by 'encoding'.
  " NOTE: Characters that come after <Esc> in terminal codes: [ ] P \ M O
  " (see term.c and `set termcap`)
  " These terminal options (gnome-terminal) conflict with my <M- mappings.
  " Fortunately, they are not important and can be disabled.
  set t_IS= t_RF= t_RB= t_SC= t_ts= t_Cs= " uses <Esc>]
  set t_RS= " uses <Esc>P and <ESC>\
  for c in ['+', '-', '/', '0', ';', 'P', 'c', 'n', 'p', 'q', 'y'] + [',', '.', '\', ']', '\|']
    exe 'set <M-'.c.'>='."\<Esc>".c
    exe 'noremap  <M-'.c.'>' c
    exe 'noremap! <M-'.c.'>' c
  endfor
  " NOTE: "set <C-M-j>=\<Esc>\<NL>" breaks stuff. So use <C-M-n> instead.
  exe "set <C-M-n>=\<Esc>\<C-n>"
  exe "set <C-M-k>=\<Esc>\<C-k>"
  exe "set <C-M-l>=\<Esc>\<C-l>"
  " <M-BS>, <C-space> are not :set-able. So there is no nice way to use them
  " in multi-char mapping that both vim and nvim understand.
  exe "set <F34>=\<Esc>\<C-?>"
  map! <F34> <M-BS>
  map  <Nul> <C-Space>
  map! <Nul> <C-Space>

  " :h undercurl
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
else
  set guioptions=i
endif

source ~/.vim/configs.vim

" lazy clipboard setup :h -X {{{
if has('clipboard') && !has('gui_running')
  let s:clipboard = &clipboard
  set clipboard=exclude:.*
  function s:InitClipboard()
    let &clipboard = s:clipboard
    call serverlist()
    inoremap <C-v> <C-g>u<C-r><C-p>+
    noremap <M-c> "+y
    return ''
  endfunction
  inoremap <silent> <C-v> <C-R>=<SID>InitClipboard()<CR><C-v>
  nnoremap <silent> <M-c> <ESC>:call <SID>InitClipboard()<CR>"+y
  xnoremap <silent> <M-c> <ESC>:call <SID>InitClipboard()<CR>gv"+y
endif
" }}}

" vim: set sw=2 ts=2 fdm=marker fdl=0 noml:
