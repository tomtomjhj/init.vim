set runtimepath+=~/.vim_runtime

set mouse=a
set number
"colorscheme dracula
" colorscheme zen
colorscheme one
set background=light

" in lightline/colorscheme/one.vim,
" let s:p.tabline.tabsel = [[['#494b53',23], ['#fafafa',255], 'bold']]
" TODO: how to customize light this
" let g:lightline#colorscheme#one#palette.tabline.tabsel =[['#494b53', '#fafafa', 23, 255, 'bold']]
" call lightline#colorscheme()

"
set tabstop=4
set shiftwidth=4

filetype plugin indent on

au BufRead,BufNewFile *.k set filetype=k
au BufRead,BufNewFile *.v set filetype=coq
au BufRead,BufNewFile *.ll set filetype=llvm

"" general completion
" let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
let g:SuperTabDefaultCompletionType = '<c-n>'
" S L O W
let g:deoplete#enable_at_startup = 1

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" NO preview window for autocompletion stuff
set completeopt-=preview

" haskell
let g:haskell_classic_highlighting = 1
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1

let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

" let g:haskellmode_completion_ghc = 1
" autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
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
    au FileType haskell nnoremap <silent> <leader>ii :InteroInfo<CR>
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


" ale general settings --------------------------
let g:ale_linters = {
\   'haskell': ['hlint'],
\   'python': ['pylint', 'mypy'],
\}

let g:ale_fixers = {'haskell': ['stylish-haskell'], '*': ['trim_whitespace']}

let g:ale_emit_conflict_warnings = 0
let g:ale_set_highlights = 0

map <leader>af :ALEFix<CR>
map <leader>ad :ALEDetail<CR>
map <leader>an :ALENext<CR>
map <leader>av :ALEPrevious<CR>


" python ------------------------------------
" TODO: this disables any other checks. but works when used from cmd.??????????
" -> just add `# type: ignore` annotation after the import stmt
" let g:ale_python_mypy_options = "-ignore-missing-imports"
let g:ale_python_mypy_options = "--check-untyped-defs"

let g:ale_python_pylint_options = "--disable=R,C"

" wrap
map <S-j> gj
map <S-k> gk
map <S-h> h
map <S-l> l
map <leader>sw :set wrap<CR>
map <leader>snw :set nowrap<CR>
" indent the wrapped line, w/ `> ` at the start
set breakindent
set showbreak=>\ 

" space to navigate
map <space> <C-d>
map <c-space> <C-u>
" <s-space> does not work
" map <s-space> <C-u>

" clipboard
if has('nvim')
  inoremap <C-v> <ESC>"+pa
  vnoremap <C-c> "+y
  vnoremap <C-x> "+d
endif

" filename
map <leader>fn :echo @%<CR>

map <F1> <Esc>
imap <F1> <Esc>

" tabs and splits ----------------------------
ca tt tabedit
map <leader>tt :tabedit<CR>

" duplicate tab
map <leader>td :tab split<CR>
map <leader>q :q<CR>

set splitright
set splitbelow

" I think it's more natural to return to the 'left' tab
" this breaks `:tabonly`.
au TabClosed * if g:lasttab > 1
  \ | exe "tabn ".(g:lasttab-1)
  \ | endif

" undo closed tab. TODO: broken
map <silent><leader><C-t> :BufExplorer<CR><Down>t

" edit from the dir of cur buf
map <leader>e :e! <c-r>=expand("%:p:h")<cr>/
" map <leader>te ...

" :%s/pat/\r&/g. & matched str, \r newline

" refresh
map <leader>ef :e!<CR>


" tags ----------------------------------------

" open ctag in a new tab/vertical split
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map g<Bslash> :tab split<CR>:exec("tselect ".expand("<cword>"))<CR>
map <leader>g<Bslash> :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>

map <leader>tn :tnext<CR>
map <leader>tN :tNext<CR>

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" //_
" TODO just use commentary
let g:NERDSpaceDelims = 1

" pandoc
let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["k", "haskell", "python", "llvm", "cpp", "rust"]
let g:pandoc#modules#disabled = ["folding"]
au FileType pandoc syntax spell toplevel
" set to notoplevel in haskell.vim
