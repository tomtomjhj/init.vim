# Install

```sh
git clone https://github.com/tomtomjhj/init.vim ~/.vim
```

## nvim
```vim
" ~/.config/nvim/init.vim
set runtimepath+=~/.vim
set runtimepath+=~/.vim/after
source ~/.vim/configs.vim
```

```sh
pip3 install --user pynvim
nvim -c PlugInstall
```

## terminal vim
```vim
" ~/.vimrc
source ~/.vim/configs.vim

noremap  <ESC><ESC> <ESC>
noremap! <ESC><ESC> <ESC>
for c in map(range(65,90) + range(97,122), 'nr2char(v:val)') + [',', '.', ']', '0']
    exec 'map  <ESC>'.c '<M-'.c.'>'
    exec 'map! <ESC>'.c '<M-'.c.'>'
endfor

" :h -X
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
    au InsertEnter,CmdlineEnter * set timeoutlen=43
    au InsertLeave,CmdlineLeave * set timeoutlen=432
augroup END
```
