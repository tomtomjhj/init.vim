if &compatible | set nocompatible | endif
if has('win32')
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif

source ~/.vim/configs.vim

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

  " fix <M- mappings {{{
  " NOTE: vim-rsi does it very differently
  " NOTE: :h 'termcap' (e.g. arrows). Map only necessary stuff.
  " NOTE: <M- keys can be affected by 'encoding'.
  " NOTE: Run after VimEnter to avoid messing up terminal stuff.
  function! InitESCMaps() abort
    " TODO: when can I map <M-]> safely?
    for c in ['+', ',', '-', '.', '/', '0', '\', ']', 'i', 'j', 'k', 'l', 'n', 'o', 'p', 'q', 'w', 'y', '\|']
      exec 'map  <ESC>'.c '<M-'.c.'>'
      exec 'map! <ESC>'.c '<M-'.c.'>'
    endfor
    imap <ESC><BS> <M-BS>
    cnoremap <ESC><ESC> <C-c>
    map  <Nul> <C-space>
    map! <Nul> <C-space>
  endfunction
  " A hack to bypass <ESC> prefix map timeout stuff.
  function! ESCHack(mode)
    if mode(1) ==# 'niI'
      call feedkeys("\<ESC>", 'n')
      return
    endif
    exec a:mode . 'unmap <buffer><ESC>'
    let extra = ''
    while 1
      let c = getchar(0)
      if c == 0
        break
      endif
      let extra .= nr2char(c)
    endwhile
    " TODO: To support long maps starting with <ESC>, mapcheck("\<ESC>".extra)
    " and collect more characters interactively.
    if a:mode != 'i'
      let prefix = v:count ? v:count : ''
      let prefix .= '"'.v:register . (a:mode == 'v' ? 'gv' : '')
      if mode(1) == 'no'
        if v:operator == 'c'
          let prefix = "\<esc>" . prefix
        endif
        let prefix .= v:operator
      endif
      call feedkeys(prefix, 'n')
    endif
    call feedkeys("\<ESC>" . extra . "\<Plug>" . a:mode . "mapESC")
    return ''
  endfunction

  " TODO remove redundant commands
  imap <silent><Plug>imapESC <C-r>=ESCimap()<CR>
  map  <silent><Plug>imapESC      :<C-u>call ESCimap()<CR>
  imap <silent><Plug>nmapESC <C-r>=ESCnmap()<CR>
  map  <silent><Plug>nmapESC      :<C-u>call ESCnmap()<CR>
  imap <silent><Plug>vmapESC <C-r>=ESCvmap()<CR>
  map  <silent><Plug>vmapESC      :<C-u>call ESCvmap()<CR>
  imap <silent><Plug>omapESC <C-r>=ESComap()<CR>
  map  <silent><Plug>omapESC      :<C-u>call ESComap()<CR>

  function! ESCimap()
    imap <silent><buffer><nowait><ESC> <C-r>=ESCHack('i')<CR>
    return ''
  endfunction
  function! ESCnmap()
    nmap <silent><buffer><nowait><ESC> :<C-u>call ESCHack('n')<CR>
    return ''
  endfunction
  function! ESCvmap()
    vmap <silent><buffer><nowait><ESC> :<C-u>call ESCHack('v')<CR>
    return ''
  endfunction
  function! ESComap()
    omap <silent><buffer><nowait><ESC> :<C-u>call ESCHack('o')<CR>
    return ''
  endfunction
  " TODO: omap generates an empty change when aborted by <ESC>
  augroup TerminalVimSetup | au!
    au VimEnter * call InitESCMaps()
    au BufEnter * call ESCimap() | call ESCnmap() | call ESCvmap() | call ESComap()
    let g:cmdlines = 0
    au CmdlineEnter * let g:cmdlines += 1 | set timeoutlen=23
    au CmdlineLeave * let g:cmdlines -= 1 | if !g:cmdlines | set timeoutlen=987 | endif
  augroup END
  " }}}
else
  set guioptions=i
endif

" lazy clipboard setup :h -X {{{
if has('clipboard') && !has('gui_running')
  let s:clipboard = &clipboard
  set clipboard=exclude:.*
  function s:InitClipboard()
    let &clipboard = s:clipboard
    call serverlist()
    inoremap <C-v> <C-\><C-o>:setl paste<CR><C-r>+<C-\><C-o>:setl nopaste<CR>
    vnoremap <C-c> "+y
    return ''
  endfunction
  inoremap <silent> <C-v> <C-R>=<SID>InitClipboard()<CR><C-v>
  vnoremap <silent> <C-c> <ESC>:call <SID>InitClipboard()<CR>gv"+y
endif
" }}}

" vim: set sw=2 ts=2 fdm=marker fdl=0 noml:
