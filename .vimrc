source ~/.vim/configs.vim

" fix <M- mappings
" NOTE: :h 'termcap' (e.g. arrows). Map only necessary stuff.
for c in [',', '.', '/', '0', '\', ']', 'i', 'j', 'k', 'l', 'n', 'o', 'p', 'y', '\|']
  exec 'map  <ESC>'.c '<M-'.c.'>'
  exec 'map! <ESC>'.c '<M-'.c.'>'
endfor
cnoremap <ESC><ESC> <C-c>
map  <Nul> <C-space>
map! <Nul> <C-space>

" A hack to bypass <ESC> prefix map timeout stuff.
function! s:ESCHack(mode)
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
endfunction

" TODO remove redundant commands
imap <silent><Plug>imapESC <C-o>:<C-u>call ESCimap()<CR>
map  <silent><Plug>imapESC      :<C-u>call ESCimap()<CR>
imap <silent><Plug>nmapESC <C-o>:<C-u>call ESCnmap()<CR>
map  <silent><Plug>nmapESC      :<C-u>call ESCnmap()<CR>
imap <silent><Plug>vmapESC <C-o>:<C-u>call ESCvmap()<CR>
map  <silent><Plug>vmapESC      :<C-u>call ESCvmap()<CR>
imap <silent><Plug>omapESC <C-o>:<C-u>call ESComap()<CR>
map  <silent><Plug>omapESC      :<C-u>call ESComap()<CR>

function! ESCimap()
  imap <silent><buffer><nowait><ESC> <C-o>:<C-u>call <SID>ESCHack('i')<CR>
endfunction
function! ESCnmap()
  nmap <silent><buffer><nowait><ESC> :<C-u>call <SID>ESCHack('n')<CR>
endfunction
function! ESCvmap()
  vmap <silent><buffer><nowait><ESC> :<C-u>call <SID>ESCHack('v')<CR>
endfunction
function! ESComap()
  omap <silent><buffer><nowait><ESC> :<C-u>call <SID>ESCHack('o')<CR>
endfunction
" TODO: omap generates an empty change when aborted by <ESC>


" lazy clipboard setup :h -X
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

" set to xterm in tmux, which doesn't support window resizing with mouse
set ttymouse=sgr

augroup VimSpecificSetup | au!
  au BufEnter * call ESCimap() | call ESCnmap() | call ESCvmap() | call ESComap()
  au BufWritePost ~/.vimrc source ~/.vimrc
  au BufWritePost ~/.vim/.vimrc source ~/.vim/.vimrc
  au CmdlineEnter * set timeoutlen=23
  au CmdlineLeave * set timeoutlen=432
augroup END
" vim: set sw=2 ts=2 nomodeline:
