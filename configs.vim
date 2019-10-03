" themes -----------------------------------------------------------------
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
" let g:lightline.colorscheme = 'two'

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
let g:SuperTabClosePreviewOnPopupClose = 1

let g:deoplete#enable_at_startup = 1

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

let g:UltiSnipsExpandTrigger = '<c-l>'
" <c-j>, <c-k> to navigate

" set completeopt-=preview

" ale general settings -----------------------------------------------------

" \   'haskell': ['hlint'],
let g:ale_linters = {
            \ 'python': ['pylint', 'mypy'],
            \ 'haskell': [],
            \ 'rust': ['rls'],
            \ 'cpp': [],
            \ 'markdown': [],
            \ }
let g:ale_fixers = {
            \ 'python': ['yapf'],
            \ 'haskell': ['stylish-haskell'],
            \ 'rust': ['rustfmt'],
            \ '*': ['trim_whitespace']
            \ }

let g:ale_set_highlights = 1
" NOTE: use matchaddpos(..,..,-1) in ale highlighting (hlsearch: 0, default: 10)
hi ALEError term=underline cterm=underline gui=undercurl
hi ALEWarning term=underline cterm=underline gui=undercurl
hi ALEInfo term=underline cterm=underline gui=undercurl

map <silent><leader>af :ALEFix<CR>
map <silent><leader>ad :ALEDetail<CR>
map <silent><leader>an :ALENext -wrap<CR>
map <silent><leader>ae :ALENext -wrap -error<CR>
map <silent><leader>av :ALEPrevious -wrap -error<CR>

" Language Client (run install.sh) --------------------------------------------
" TODO remove LC and use ale LSP? coc? ???
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

" use ale diagnostics: LC diagnostics doesn't seem to have ALENext stuff and has
" very annoying default settings.
let g:LanguageClient_diagnosticsEnable = 0
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


" haskell -----------------------------------------------------------
let g:haskell_classic_highlighting = 1
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_indent_let_no_in = 0
let g:haskell_indent_if = 0
let g:haskell_indent_case_alternative = 1

au FileType haskell setlocal shiftwidth=2 tabstop=2
au FileType yaml setlocal shiftwidth=2 tabstop=2

let g:intero_start_immediately = 0
if has('nvim')
  augroup interoMaps
    au!
    au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
    au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>
    au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
    au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>
    " au BufWritePost *.hs InteroReload
    au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>
    au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
    au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>
    au FileType haskell map <silent> <leader>t <Plug>InteroGenericType
    au FileType haskell map <silent> <leader>T <Plug>InteroType
    au FileType haskell nnoremap <silent> <leader>ii :InteroInfo<CR>
    au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>
    au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>
    au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
  augroup END
endif

" rust -------------------------------------------------------------
" NOTE: External crate completion does't work without extern crate declaration


" python ------------------------------------------------------------
" this disables any other checks. but works when used from cmd.??????????
" -> just add `# type: ignore` annotation after the import stmt
" let g:ale_python_mypy_options = "-ignore-missing-imports"
let g:ale_python_mypy_options = "--check-untyped-defs"
let g:ale_python_pylint_options = "--disable=R,C,W0614,W0621"


" motion -------------------------------------------------------------

" HJKL for wrapped lines. <leader>J for joins
noremap <S-j> gj
noremap <S-k> gk
noremap <S-h> h
noremap <S-l> l
noremap <leader>J J

" space to navigate
noremap <space> <C-d>
noremap <c-space> <C-u>
" <s-space> does not work

" star without moving the cursor
noremap <silent>* :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>
vnoremap <silent>* :<C-u>call Searchgvy()\|set hlsearch<CR>
func! Searchgvy()
    let l:saved_reg = @"
    execute "normal! gvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

" insert mode CTRL-O$ to move to eol

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi Sneak guifg=black guibg=#afff00 ctermfg=black ctermbg=154

" etc ----------------------------------------------------------
map <leader>sw :set wrap<CR>
map <leader>snw :set nowrap<CR>
" indent the wrapped line, w/ `> ` at the start
set breakindent
set showbreak=>\ 

" clipboard.
if has('nvim')
  inoremap <C-v> <ESC>"+pa
  vnoremap <C-c> "+y
  vnoremap <C-x> "+d
endif

" filename
map <leader>fn :echo @%<CR>

noremap <F1> <Esc>
inoremap <F1> <Esc>

" just use <C-F> in cmd mode to see cmd history.
" just use gQ to enter ex mode.
" disable default macro key and use Q instead
noremap q: :
noremap q <nop>
noremap Q q

" delete without clearing regs
noremap x "_x

set spellfile=~/.vim_runtime/temp_dirs/en.utf-8.add

" pairs
" RainbowParentheses comments using parens e.g. ocaml, haskell, ..
let g:rainbow#pairs = [['(', ')'], ['{', '}']]
autocmd FileType c,cpp,rust,lisp RainbowParentheses
let g:AutoPairsMapSpace = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCh = 0
let g:AutoPairsShortcutFastWrap = '<M-w>'
let g:AutoPairsShortcutToggle = ''
func! ClosingPairJump()
    call search('["\]'')}$]','W')
endfunc
func! OpeningPairJump()
    "              v no `\` here
    call search('["[''({$]','bW')
endfunc
inoremap <silent> <C-k> <ESC>:call OpeningPairJump()<CR>a
inoremap <silent> <C-j> <ESC>:call ClosingPairJump()<CR>a
map <silent> <M-p> :call OpeningPairJump()<CR>
map <silent> <M-n> :call ClosingPairJump()<CR>
" digraph
inoremap <C-space> <C-k>

" fzf
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '~30%' }
map <C-b> :Buffers<CR>
map <C-f> :Files<CR>
map <leader>F :Files .
map <leader>hh :History<CR>
map <leader>h: :History:<CR>
map <leader>h/ :History/<CR>
map <leader>rg :Rg<space>
map <leader>r/ :<C-u>Rg <C-r>=substitute(@/,'\v\\[<>]','',"g")<CR>
if has("nvim")
    augroup fzf
        au!
        au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        au FileType fzf tunmap <buffer> <Esc>
    augroup END
endif

map <leader>ar :AsyncRun<space>
map <leader>as :AsyncStop<CR>
augroup open_quickfix
    au!
    au QuickFixCmdPost * botright copen 8
augroup END

" https://github.com/tpope/vim-surround/issues/55#issuecomment-4610756
" https://www.reddit.com/r/vim/comments/5l939k
" git submodule deinit
" vim-exchange, yankstack, vim-abolish

" tabs and splits --------------------------------------------------
map <leader>tt :tabedit<CR>

" duplicate tab
map <leader>td :tab split<CR>
map <leader>q :q<CR>
map q, :q<CR>

set splitright
set splitbelow

" I think it's more natural to return to the 'left' tab
" this breaks `:tabonly`.
" TODO: chrome-style return to last tab
au TabClosed * if g:lasttab > 1
  \ | exe "tabn ".(g:lasttab-1)
  \ | endif

" edit from the dir of cur buf. `<c-r>=`: append from expr register
map <leader>e :e! <c-r>=expand("%:p:h")<cr>/

" TODO see :help [range], &, g&
" :%s/pat/\r&/g. & matched str, \r newline
" TODO: marks

" refresh
map <leader>ef :e!<CR>

map <leader>co :copen 8<CR>
map <leader>cn :cn<CR>
map <leader>cN :cN<CR>
map <silent><leader>x :pc\|ccl\|lcl<CR>

" tags ------------------------------------------------------------
" TODO: CTRL-W commands

" open ctag in a new tab/vertical split
map <silent><C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <silent><leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <silent>g<Bslash> :tab split<CR>:exec("tselect ".expand("<cword>"))<CR>
map <silent><leader>g<Bslash> :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>

" open tag in preview window: <C-w>} and <C-w>g}
" use <leader>tc  (tabclose)

map <leader>tn :tnext<CR>
map <leader>tN :tNext<CR>

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!


" Comments ------------------------
let g:NERDCreateDefaultMappings = 0
xmap ,c<Space> <Plug>NERDCommenterToggle
nmap ,c<Space> <Plug>NERDCommenterToggle
xmap ,cs <Plug>NERDCommenterSexy
nmap ,cs <Plug>NERDCommenterSexy
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
            \ 'python' : { 'left': '#', 'leftAlt': '#' },
            \ 'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
            \}
let g:NERDDefaultAlign = 'both'

map <leader>sf :syn sync fromstart<CR>

" pandoc, tex ------------------------------------
let g:tex_flavor = "latex"
let g:tex_noindent_env = 'document\|verbatim\|lstlisting\|align.\?'
au FileType tex setlocal conceallevel=2
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#twxtwidth = 80
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
augroup Pandocs
    au!
    au FileType pandoc nmap <buffer><silent><leader>pd :call RunPandoc(0)<CR>
    au FileType pandoc nmap <buffer><silent><leader>po :call RunPandoc(1)<CR>
    au FileType pandoc nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    au FileType pandoc let b:AutoPairs = AutoPairsDefine({'$':'$', '$$':'$$'})
    " set to notoplevel in haskell.vim
    au FileType pandoc syntax spell toplevel
augroup END
func! RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    let params = '-Vurlcolor=cyan'
    let post = a:open ? "-post=call\\ Zathura('" . l:out . "',!g:asyncrun_code)" : ''
    " set manually or by local vimrc
    if exists('b:custom_pandoc_include_file')
        " --include-in-header overrides header-includes in the yaml metadata
        let l:params .= ' --include-in-header=' . b:custom_pandoc_include_file
    endif
    let cmd = 'pandoc ' . l:src . ' -o ' . l:out . ' ' . l:params
    exe 'AsyncRun -save=1 -cwd=' . expand("%:p:h") l:post l:cmd
endfunc
func! Zathura(file, ...)
    let check = get(a:, 1, 1)
    if l:check
        call jobstart(['zathura', a:file, '--fork'])
    endif
endfunc

" TODO: `gq` wrt bullet points gets broken after some operations
" TODO pandoc filetype for LC hover buffer

" ctrl-shift-t of chrome --------------------------------------------------
" TODO: debug(non-existent buf), save filenames when :qa'd and restore
map <silent><leader><C-t> :call PopQuitBufs()<CR>
" works only for buffers of closed windows
au QuitPre * call PushQuitBufs(expand("<abuf>"))
" push if clean and empty. remove preceding one if exists
let g:quitbufs = []
func! PushQuitBufs(buf)
    if !IsCleanEmptyBuf(a:buf)
        call tlib#list#Remove(g:quitbufs, a:buf)
        call add(g:quitbufs, a:buf)
    endif
endfunc
" TODO: more options. cur window, new split, remember the layout, ...
func! PopQuitBufs()
    if len(g:quitbufs) > 0
        exec "tabnew +".(remove(g:quitbufs, -1))."buf"
    endif
endfunc

" automatically remove garbage buffers -----------------------------------------
" bw, bd, setlocal bufhidden=delete don't work on the buf being hidden
" defer it until BufEnter to another buf
let g:lasthidden = 0
au BufHidden * let g:lasthidden = expand("<abuf>")
au BufEnter * call CheckAndBW(g:lasthidden)
func! CheckAndBW(buf)
    if IsCleanEmptyBuf(a:buf)
        exec("bw ".a:buf)
    endif
endfunc

" utilities ---------------------------------------------------------
" https://stackoverflow.com/questions/6552295
" TODO: `+` signs??
func! IsCleanEmptyBuf(buf)
    return a:buf > 0 && buflisted(+a:buf) && empty(bufname(+a:buf)) && !getbufvar(+a:buf, "&mod")
endfunc

func! CleanGarbageBufs()
    let bufs = filter(range(1, bufnr('$')), 'IsCleanEmptyBuf(v:val) && bufwinnr(v:val)<0')
    if !empty(bufs)
        exe 'bw ' . join(bufs, ' ')
    endif
endfunc
