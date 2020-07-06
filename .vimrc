source ~/.vim/configs.vim

" fix mappings
noremap  <ESC><ESC> <ESC>
inoremap <ESC><ESC> <ESC>
cnoremap <ESC><ESC> <C-c>
" NOTE: :h 'termcap'.
" map only necessary stuff
for c in [',', '.', '/', '0', '\', ']', 'i', 'j', 'k', 'l', 'o', 'p', 'y', '\|']
    exec 'map  <ESC>'.c '<M-'.c.'>'
    exec 'map! <ESC>'.c '<M-'.c.'>'
endfor
map  <Nul> <C-space>
map! <Nul> <C-space>

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
imap <silent> <C-v> <C-R>=<SID>InitClipboard()<CR><C-v>
vmap <silent> <C-c> <ESC>:call <SID>InitClipboard()<CR>gv"+y

" set to xterm in tmux, which doesn't support window resizing with mouse
set ttymouse=sgr

" TODO: visual mode <ESC>
augroup VimSpecificSetup | au!
    au InsertEnter,CmdlineEnter * set timeoutlen=23
    au InsertLeave,CmdlineLeave * set timeoutlen=432
augroup END
