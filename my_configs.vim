let g:ale_emit_conflict_warnings = 0
set runtimepath+=~/.vim_runtime
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:ale_set_highlights = 0

set number

syntax on
"color dracula

colors zenburn

"let g:solarized_termcolors=256
"set background=light
"colorscheme solarized

"colorscheme gruvbox

"autocmd ColorScheme janah highlight Normal ctermbg=235
"colorscheme janah
"
filetype plugin indent on

au BufRead,BufNewFile *.k set filetype=kframework
au! Syntax kframework source kframework.vim
au BufRead,BufNewFile *.maude set filetype=maude
au! Syntax kframework source maude.vim
syn on
au BufRead,BufNewFile *.v set filetype=coq


set rtp^="~/.opam/4.06.1/share/ocp-indent/vim"

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["asm"] }


" haskell stuff
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

let g:haskellmode_completion_ghc = 1
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
let g:haskell_indent_let_no_in = 0
let g:haskell_indent_if = 0

" delete ghc.vim in ale_linters to avoid module import errors
""""""""""""""""""""""""""""""""

" wrap
map <S-j> gj
map <S-k> gk

let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["k"]


