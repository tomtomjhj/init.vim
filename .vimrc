source ~/.vim/configs.vim

noremap  <ESC><ESC> <ESC>
inoremap <ESC><ESC> <ESC>
cnoremap <ESC><ESC> <C-c>
" <M-O> conflicts with arrows
for c in map(range(65,78) + range(80,90) + range(97,122), 'nr2char(v:val)') + [',', '.', ']', '0']
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

augroup VimSpecificSetup | au!
    au InsertEnter,CmdlineEnter * set timeoutlen=32
    au InsertLeave,CmdlineLeave * set timeoutlen=432
augroup END
