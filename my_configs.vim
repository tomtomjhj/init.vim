set runtimepath+=~/.vim_runtime
let g:ale_emit_conflict_warnings = 0
let g:ale_set_highlights = 0

set mouse=a
set number
syntax on
"colorscheme dracula
colorscheme zen
set tabstop=2
set shiftwidth=2
syn sync minlines=200


"let g:zenburn_high_Contrast = 1
"colors zenburn


"let g:solarized_termcolors=256
"set background=light
"colorscheme solarized

filetype plugin indent on

au BufRead,BufNewFile *.k set filetype=k
au BufRead,BufNewFile *.kore set filetype=kore
au BufRead,BufNewFile *.maude set filetype=maude
au! Syntax kframework source maude.vim
syn on
au BufRead,BufNewFile *.v set filetype=coq
au BufRead,BufNewFile *.ll set filetype=llvm

"" general completion
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
" SLOW
let g:deoplete#enable_at_startup = 1

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" haskell
let g:haskell_classic_highlighting = 1

let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:haskell_indent_let_no_in = 0
let g:haskell_indent_if = 0
let g:haskell_indent_case_alternative = 1

let g:intero_start_immediately = 0
if has('nvim')
  augroup interoMaps
    au!
    " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.

    " Background process and window management
    au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
    au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

    " Open intero/GHCi split horizontally
    au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
    " Open intero/GHCi split vertically
    au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
    au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>

    " Reloading (pick one)
    " Automatically reload on save
    " au BufWritePost *.hs InteroReload
    " Manually save and reload
    au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>

    " Load individual modules
    au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
    au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

    " Type-related information
    " Heads up! These next two differ from the rest.
    au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
    au FileType haskell map <silent> <leader>T <Plug>InteroType
    au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

    " Navigation
    au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

    " Managing targets
    " Prompts you to enter targets (no silent):
    au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>

    " focus out
    tnoremap <Esc> <C-\><C-n>
  augroup END
endif


" delete ghc.vim in ale_linters to avoid module import errors
""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'haskell': ['hlint'],
\}

let g:ale_fixers = {'haskell': ['stylish-haskell'], '*': ['trim_whitespace']}

" wrap
map <S-j> gj
map <S-k> gk

" clipboard
if has('nvim')
  inoremap <C-v> <ESC>"+pa
  vnoremap <C-c> "+y
  vnoremap <C-d> "+d
endif

ca tt tabedit

map <F1> <Esc>
imap <F1> <Esc>

" duplicate tab
map <leader>td :tab split<CR>

" open ctag in a new tab/vertical split
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" //_
let g:NERDSpaceDelims = 1

let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["k", "haskell", "python", "llvm"]
au FileType pandoc syntax spell toplevel
" set to notoplevel in haskell.vim


