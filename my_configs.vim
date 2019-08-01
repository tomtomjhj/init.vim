set runtimepath+=~/.vim_runtime

" themes ---------------------------------------------
" colorscheme dracula
colorscheme zen
" colorscheme one
" set background=light
" call one#highlight('Normal', '1c1c1c', '', '')
" call one#highlight('Comment', '767676', '', '')
" call one#highlight('SpecialComment', '767676', '', '')
" call one#highlight('Conceal', '767676', '', '')
" call one#highlight('rustCommentLine',         '767676', '', '')
" call one#highlight('rustCommentLineDoc',      '767676', '', '')
" call one#highlight('rustCommentLineDocError', '767676', '', '')
" call one#highlight('rustCommentBlock',        '767676', '', '')
" call one#highlight('rustCommentBlockDoc',     '767676', '', '')
" call one#highlight('rustCommentBlockDocError','767676', '', '')
" call one#highlight('gitcommitComment','767676', '', '')
" call one#highlight('vimCommentTitle','767676', '', '')
" call one#highlight('vimLineComment','767676', '', '')
" call one#highlight('Todo', 'fafafa', 'ffafd7', 'bold')
" call one#highlight('SpellBad'  , 'FF5555', 'fafafa', 'underline')
" call one#highlight('SpellLocal', 'FFB86C', 'fafafa', 'underline')
" call one#highlight('SpellCap'  , 'FFB86C', 'fafafa', 'underline')
" call one#highlight('SpellRare' , 'FFB86C', 'fafafa', 'underline')
" TODO: clean way to customize palette? just fork?
" let g:lightline.colorscheme = 'one1'
" TODO: how to change colorscheme including lightline without restarting: remove all syntax links...

"
set mouse=a
set number
set tabstop=4
set shiftwidth=4

filetype plugin indent on

au BufRead,BufNewFile *.k set filetype=k
au BufRead,BufNewFile *.v set filetype=coq
au BufRead,BufNewFile *.ll set filetype=llvm

" general completion
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
" close preview after completion
let g:SuperTabClosePreviewOnPopupClose = 1
" let g:SuperTabDefaultCompletionType = '<c-n>'

" TODO: deoplete snippets integration??

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
" set completeopt-=preview
" TODO: how to check preview info manually?


" ale general settings --------------------------

" \   'haskell': ['hlint'],
" TODO: cargo check?
let g:ale_linters = {
            \ 'python': ['pylint', 'mypy'],
            \ 'haskell': [],
            \ 'rust': ['rls'],
            \ 'cpp': [],
            \ }
let g:ale_fixers = {
            \ 'python': ['yapf'],
            \ 'haskell': ['stylish-haskell'],
            \ 'rust': ['rustfmt'],
            \ '*': ['trim_whitespace']
            \ }

let g:ale_set_highlights = 1
hi ALEError term=underline cterm=underline gui=undercurl
hi ALEWarning term=underline cterm=underline gui=undercurl
hi ALEInfo term=underline cterm=underline gui=undercurl

map <silent><leader>af :ALEFix<CR>
map <silent><leader>ad :ALEDetail<CR>
map <silent><leader>an :ALENext -wrap<CR>
map <silent><leader>ae :ALENext -wrap -error<CR>
map <silent><leader>av :ALEPrevious -wrap -error<CR>

" Language Client -----------------------------

" TODO: fzf?
" run install.sh
" :LanguageClientStart to start
"
map <leader>lcs :LanguageClientStart<CR>
let g:LanguageClient_autoStart = 0
let g:LanguageClient_useVirtualText = 0
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'], 'rust':['rls'] }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <silent><Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <silent><Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <silent><Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <silent><Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <silent><Leader>lb :call LanguageClient#textDocument_references()<CR>
map <silent><Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <silent><Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

" use ale diagnostics: LC diagnostics doesn't seem to have ALENext stuff and has very annoying default settings
" TODO full ale functionalities for LC
let g:LanguageClient_diagnosticsEnable = 0
" src/language_server_protocol.rs:define_signs overrides ale sign definition
" highlights.  The default value itself seems to be fine but the highlighting
" doesn't work if LanguageClientStart runs before default ale starts. Below is
" the default hi link before LC starts.
hi link ALEErrorSign Error
hi link ALEStyleErrorSign ALEErrorSign
hi link ALEWarningSign Todo
hi link ALEStyleWarningSign ALEWarningSign
hi link ALEInfoSign ALEWarningSign
let g:LanguageClient_diagnosticsDisplay =
\   {
\       1: {
\           "name": "Error",
\           "texthl": "ALEError",
\           "signText": ">>",
\           "signTexthl": "ALEErrorSign",
\           "virtualTexthl": "Error",
\       },
\       2: {
\           "name": "Warning",
\           "texthl": "ALEWarning",
\           "signText": "--",
\           "signTexthl": "ALEWarningSign",
\           "virtualTexthl": "Todo",
\       },
\       3: {
\           "name": "Information",
\           "texthl": "ALEInfo",
\           "signText": "--",
\           "signTexthl": "ALEInfoSign",
\           "virtualTexthl": "Todo",
\       },
\       4: {
\           "name": "Hint",
\           "texthl": "ALEInfo",
\           "signText": "!",
\           "signTexthl": "ALEInfoSign",
\           "virtualTexthl": "Todo",
\       },
\   }



" haskell ------------------------------------------
let g:haskell_classic_highlighting = 1
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_indent_let_no_in = 0
let g:haskell_indent_if = 0
let g:haskell_indent_case_alternative = 1

let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

au FileType haskell setlocal shiftwidth=2 tabstop=2
au FileType yaml setlocal shiftwidth=2 tabstop=2

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

" rust --------------------------------------------
" use language client


" python ------------------------------------
" TODO: this disables any other checks. but works when used from cmd.??????????
" -> just add `# type: ignore` annotation after the import stmt
" let g:ale_python_mypy_options = "-ignore-missing-imports"
let g:ale_python_mypy_options = "--check-untyped-defs"
let g:ale_python_pylint_options = "--disable=R,C"


" etc ---------------------------------------
" HJKL navigation for wrapped lines. <leader>J for joins
noremap <leader>J J
noremap <S-j> gj
noremap <S-k> gk
noremap <S-h> h
noremap <S-l> l
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

" star without moving the cursor. ~Actually, move the cursor to cword's first letter~
" TODO: idempotent motion?
" TODO: vim-sneak?
nmap <silent>* :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>
" TODO: do this for vmap

" TODO: maybe broken
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

" <C-BS> doesn't work
" imap <C-BS> <C-W>
" imap <C-S-BS> <C-U>

" insert mode CTRL-O$ to move to eol

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


" open last closed buf
" TODO: lastbuf_stack. remove from stack when BufEnter?
" TODO: more options. cur window, new split, ....
let g:lastbuf = 0
au BufLeave * let g:lastbuf = bufnr("%")
map <silent><leader><C-t> :exec("if g:lastbuf>0 \| tabnew +".(g:lastbuf)."buf \| endif")<CR>

" edit from the dir of cur buf
map <leader>e :e! <c-r>=expand("%:p:h")<cr>/
" map <leader>te ...

" :%s/pat/\r&/g. & matched str, \r newline

" refresh
map <leader>ef :e!<CR>


" tags ----------------------------------------
" TODO: CTRL-W commands

" open ctag in a new tab/vertical split
map <silent><C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <silent><leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <silent>g<Bslash> :tab split<CR>:exec("tselect ".expand("<cword>"))<CR>
map <silent><leader>g<Bslash> :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>

" open in preview window: <C-w>} and <C-w>g}
" close preview with :pclose, <C-w>z
map <silent><leader>x :pc<CR>
" use <leader>tc  (tabclose)

map <leader>tn :tnext<CR>
map <leader>tN :tNext<CR>

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!


" Comments ------------------------
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = { 'python' : { 'left': '#', 'leftAlt': '', 'rightAlt': '' }}
let g:NERDDefaultAlign = 'both'

map <leader>sf :syn sync fromstart<CR>

" pandoc ------------------------------------
let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["haskell", "python", "cpp", "rust"]
let g:pandoc#modules#disabled = ["folding"]
au FileType pandoc syntax spell toplevel
" set to notoplevel in haskell.vim
