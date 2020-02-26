" vim: set foldmethod=marker foldlevel=0 nomodeline:
" TODO: filetype specific stuff in ftplugin

" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug '~/.vim/my_plugins/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'lifepillar/vim-solarized8'

" general
if !has('nvim') | Plug 'tpope/vim-sensible' | endif
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterToggle' }
Plug 'preservim/nerdcommenter', { 'on': ['<plug>NERDCommenterComment', '<plug>NERDCommenterToggle', '<plug>NERDCommenterInsert', '<plug>NERDCommenterSexy'] }
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug '~/.vim/my_plugins/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment'
Plug 'rhysd/git-messenger.vim'
Plug 'Konfekt/FastFold'

Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
augroup SetupNerdTree | au!
    au VimEnter * silent! au! FileExplorer
    au BufEnter,VimEnter *
                \ if get(g:, 'loaded_nerd_tree', 0) |
                \   exec 'au! SetupNerdTree' |
                \ elseif isdirectory(expand("<amatch>")) |
                \   call plug#load('nerdtree') |
                \   call nerdtree#checkForBrowse(expand("<amatch>")) |
                \   exec 'au! SetupNerdTree' |
                \ endif |
augroup END

" completion
Plug 'ervandew/supertab'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'ncm2/float-preview.nvim' | set completeopt-=preview
else
  Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'Shougo/deoplete.nvim'
endif
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

augroup Completions | au!
  au InsertEnter * call deoplete#enable() | au! Completions
augroup END

" lanauges
Plug 'tomtomjhj/ale'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', 'for': 'rust' }
Plug '~/.vim/my_plugins/vim-pandoc-syntax' | Plug 'vim-pandoc/vim-pandoc'
Plug '~/.vim/my_plugins/tex-conceal.vim'
Plug 'rust-lang/rust.vim'
Plug '~/.vim/my_plugins/vim-ocaml'
Plug '~/.vim/my_plugins/haskell-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
Plug 'Shougo/deoplete-clangx'
" Plug 'parsonsmatt/intero-neovim'
" Plug 'tomlion/vim-solidity'
" Plug 'LumaKernel/coquille'
" Plug 'https://framagit.org/tyreunom/coquille', { 'do': ':UpdateRemotePlugins' }
" NOTE: doesn't work in nvim, not async
Plug 'let-def/vimbufsync' | Plug 'whonore/Coqtail'

call plug#end()
" }}}

" Basic {{{
set mouse=a
set number ruler
set foldcolumn=1 foldnestmax=5
set scrolloff=2
set showtabline=1

set tabstop=4 shiftwidth=4
set expandtab smarttab
set autoindent smartindent
" TODO: insert indents at InsertEnter

" indent the wrapped line, w/ `> ` at the start
set wrap linebreak breakindent showbreak=>\ 
set backspace=eol,start,indent
set whichwrap+=<,>,[,],h,l

let mapleader = ","
set timeoutlen=420

let $LANG='en'
set langmenu=en
set encoding=utf8
" TODO: project spell file
set spellfile=~/.vim/spell/en.utf-8.add

set wildmenu wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc,*.pdf,*.v.d,*.vo,*.glob
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

set magic
set ignorecase smartcase
set hlsearch incsearch

set noerrorbells novisualbell t_vb=

set nobackup nowritebackup noswapfile
set undofile undodir=~/.vim/undodir
set history=500
if has('nvim') | set shada=!,'150,<50,s30,h | endif

set autoread
set splitright splitbelow
set switchbuf=useopen,usetab
set hidden
set lazyredraw

set exrc secure

let &pumheight = min([&window/4, 20])

augroup BasicSetup | au!
    " Return to last edit position when opening files
    au BufWinEnter * if line("'\"") > 1 && line("'\"") <= line("$") | exec "norm! g'\"" | endif
    au BufWritePost ~/.vim/configs.vim source ~/.vim/configs.vim
    au BufRead,BufNewFile *.k set filetype=k
    au BufRead,BufNewFile *.ll set filetype=llvm
    au BufRead,BufNewFile *.mir set filetype=rust
    au FileType lisp if !exists('b:AutoPairs') | let b:AutoPairs = AutoPairsDefine({}, ["'"]) | endif
    au VimResized * let &pumheight = min([&window/4, 20])
augroup END

let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" }}}

" Themes {{{
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'shortrelpath', 'modified'] ],
      \   'right': [ ['lineinfo'], ['percent'], ['linter_checking', 'linter_errors', 'linter_warnings'], ['asyncrun'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'shortrelpath': '%{pathshorten(fnamemodify(expand("%"), ":~:."))}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{fugitive#statusline()}',
      \   'asyncrun': '%{g:asyncrun_status}',
      \ },
      \ 'component_expand': {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#statusline"))'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }
" `vil() { nvim "$@" --cmd 'set background=light'; }` for light theme
if exists('g:colors_name') " loading the color again breaks lightline
elseif &background == 'dark' || !has('nvim')
    colorscheme zen
else
    let g:solarized_enable_extra_hi_groups = 1
    let g:solarized_italics = 0
    set termguicolors
    colorscheme solarized8_high
    hi Special guifg=#735050 | hi Conceal guifg=#735050
    hi Statement gui=bold
    let g:lightline.colorscheme = 'solarized'
endif
" }}}

" Completion {{{

let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

let g:deoplete#enable_at_startup = 0
call deoplete#custom#source('around', 'min_pattern_length', 1)
call deoplete#custom#source('ale', { 'max_info_width': 0, 'max_menu_width': 0 })
call deoplete#custom#source('LanguageClient', { 'max_info_width': 0, 'max_menu_width': 0 })
call deoplete#custom#var('omni', 'input_patterns', { 'tex': g:vimtex#re#deoplete })
call deoplete#custom#var('around', { 'mark_above': '[↑]', 'mark_below': '[↓]', 'mark_changes': '[*]' })
" set ignore_case false

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE, LSP, tags, ... global settings {{{
let g:ale_linters = {
            \ 'c': ['clang'],
            \ 'cpp': ['clang'],
            \ 'python': ['pyls'],
            \ 'rust': ['rls'],
            \ 'tex': ['texlab'],
            \ }
let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'python': ['yapf'],
            \ 'haskell': ['stylish-haskell'],
            \ 'rust': ['rustfmt'],
            \ '*': ['trim_whitespace']
            \ }
let g:ale_set_highlights = 1
let g:ale_linters_explicit = 1
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_diagnosticsDisplay = {
\   1: { 'signTexthl': 'ALEError' },
\   2: { 'signTexthl': 'ALEWarning' },
\   3: { 'signTexthl': 'ALEInfo' },
\   4: { 'signTexthl': 'ALEInfo' },
\}
let g:LanguageClient_virtualTextPrefix = 'ℹ️ '
hi ALEError term=underline cterm=underline gui=undercurl
hi ALEWarning term=NONE cterm=NONE gui=NONE
hi ALEInfo term=NONE cterm=NONE gui=NONE

" TODO: <M- maps are broken in vim
nmap <leader>ad <Plug>(ale_detail)<C-W>p
nmap <leader>af <Plug>(ale_fix)
nmap <M-.> <Plug>(ale_hover)
nmap <M-]> <Plug>(ale_go_to_definition)
nmap <silent><M-\> <Plug>(ale_go_to_definition_in_tab)
nmap <silent><leader><M-\> :if IsWide() \| ALEGoToDefinitionInVSplit \| else \| ALEGoToDefinitionInSplit \| endif<CR>
nmap <leader>ah <Plug>(ale_hover)
nmap <leader>aj <Plug>(ale_go_to_definition)
nmap <leader>rn :ALERename<CR>
nmap <leader>rf <Plug>(ale_find_references)
nmap ]a <Plug>(ale_next_wrap)
nmap ]A <Plug>(ale_next_wrap_error)
nmap [a <Plug>(ale_previous_wrap)
nmap [A <Plug>(ale_prevous_wrap_error)
nmap <M-o> <C-o>
nmap <M-i> <C-i>

func! LCMaps()
    nmap <buffer><silent><M-.> :call LanguageClient#textDocument_hover()<CR>
    nmap <buffer><silent><M-]> :call LanguageClient#textDocument_definition()<CR>
    nmap <buffer><silent><M-\> :call LanguageClient#textDocument_definition({'gotoCmd': 'tab split'})<CR>
    nmap <buffer><silent><leader><M-\> :call LanguageClient#textDocument_definition({'gotoCmd': IsWide() ? 'vsp' : 'sp'})<CR>
    nmap <buffer><silent><leader>rf :call LanguageClient#textDocument_references()<CR>
    nmap <buffer><silent><leader>rn :call LanguageClient#textDocument_rename()<CR>
endfunc

" open tag in a new tab/split, (preview: <c-w>}). <C-w>] is affected by switchbuf
noremap <silent><C-\> :tab split<CR><C-]>
noremap <silent><leader><C-\> :if IsWide() \| vsp \| else \| sp \| endif<CR><C-]>
noremap g<Bslash> :tab split<CR>g]
noremap <leader>g<Bslash> :if IsWide() \| vsp \| else \| sp \| endif<CR>g]
map ]t :tn<CR>
map [t :tN<CR>
" }}}

" Haskell {{{
let g:haskell_classic_highlighting = 1
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1
let g:haskell_indent_let_no_in = 0
let g:haskell_indent_if = 0
let g:haskell_indent_case_alternative = 1

let g:intero_start_immediately = 0
augroup SetupHaskell | au!
    au FileType haskell call SetupIntero()
augroup END
func! SetupIntero()
    setlocal shiftwidth=2 tabstop=2
    nnoremap <silent><buffer><leader>is :InteroStart<CR>
    nnoremap <silent><buffer><leader>ik :InteroKill<CR>
    nnoremap <silent><buffer><leader>io :InteroOpen<CR>
    nnoremap <silent><buffer><leader>ih :InteroHide<CR>
    nnoremap <silent><buffer><leader>wr :w \| :InteroReload<CR>
    nnoremap <silent><buffer><leader>il :InteroLoadCurrentModule<CR>
    nnoremap <silent><buffer><leader>if :InteroLoadCurrentFile<CR>
    noremap  <silent><buffer><leader>t <Plug>InteroGenericType
    noremap  <silent><buffer><leader>T <Plug>InteroType
    nnoremap <silent><buffer><leader>ii :InteroInfo<CR>
    nnoremap <silent><buffer><leader>it :InteroTypeInsert<CR>
    nnoremap <silent><buffer><leader>jd :InteroGoToDef<CR>
    nnoremap <buffer><leader>ist :InteroSetTargets<SPACE>
endfunc
" }}}

" Rust {{{
" TODO: rust symbol prettyfier: ${GT,LT,C,u20,u7b,u7d}$
let g:rust_fold = 1
let g:rust_keep_autopairs_default = 1
if executable('ra_lsp_server')
    let g:ale_rust_rls_config = { 'rust': { 'racer_completion': v:false } }
    let g:LanguageClient_serverCommands = { 'rust': ['ra_lsp_server'] }
endif
augroup SetupRust | au!
    au FileType rust call SetupRust()
augroup END
func! SetupRust()
    if executable('ra_lsp_server') | call LCMaps() | endif
    nmap <buffer><leader>C :AsyncRun -program=make -post=OQ test --no-run<CR>
    vmap <buffer><leader>af :RustFmtRange<CR>
    if !exists('b:AutoPairs') | let b:AutoPairs = AutoPairsDefine({'|': '|'}, ["'"]) | endif
endfunc
" NOTE: External crate completion doesn't work without extern crate declaration
" }}}

" C,C++ {{{
" TODO: this should be based on tabstop and shiftwidth, see editorconfig doc
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: llvm, IndentWidth: 4, AccessModifierOffset: -4}"'
augroup SetupCCpp | au!
    au FileType c,cpp setlocal foldmethod=syntax foldlevel=99
augroup END
" }}}

" Python {{{
" let g:ale_python_mypy_options = '--ignore-missing-imports --check-untyped-defs'
let g:ale_python_pyls_config = {
            \ 'pyls': {
            \   'plugins': {
            \     'rope_completion': { 'enabled': v:false },
            \     'mccabe': { 'enabled': v:false },
            \     'pyls_mypy': { 'enabled': v:true, 'live_mode': v:false },
            \     'preload': { 'enabled': v:false },
            \     'pycodestyle': { 'enabled': v:false },
            \     'pydocstyle': { 'enabled': v:false },
            \     'pyflakes': { 'enabled': v:false },
            \     'pylint': { 'enabled': v:true, 'args': ['-dR', '-dC', '-dW0614', '-dW0621'] },
            \     'yapf': { 'enabled': v:false },
            \   }
            \ }
            \}
" }}}

" Pandoc, Tex {{{
let g:tex_flavor = "latex"
let g:tex_noindent_env = '\v\w+.?'
" use PandocHighlight or TODO: stuff from gabrielelana/vim-markdown
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "keyboard", "toc", "hypertext"]
let g:pandoc#folding#level = 99
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
let g:vimtex_fold_enabled = 1
augroup SetupPandocTex | au!
    au FileType pandoc call SetupPandoc()
    au FileType tex call SetupTex()
augroup END
func! SetupPandoc()
    let b:AutoPairs = AutoPairsDefine({'$':'$', '$$':'$$'})
    " set to notoplevel in haskell.vim
    call textobj#user#plugin('pandoc', s:pandoc_textobj)
    syntax spell toplevel
    nmap <buffer><silent><leader>C :call RunPandoc(0)<CR>
    nmap <buffer><silent><leader>O :call RunPandoc(1)<CR>
    nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'<CR>")<CR>
    nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    nmap <buffer><silent><leader>py vid:AsyncRun python3<CR>:OQ<CR>
    nmap <buffer>zM :call pandoc#folding#Init()\|unmap <lt>buffer>zM<CR>zM
endfunc
func! RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    let params = '-Vurlcolor=cyan --highlight-style=kate'
    let post = "exec 'au! pandoc_quickfix'"
    let post .= a:open ? "|call Zathura('" . l:out . "',!g:asyncrun_code)" : ''
    let post = escape(post, ' ')
    " set manually or by local vimrc, override header-includes in yaml metadata
    " TODO: local_vimrc or editorconfig hook
    if exists('b:custom_pandoc_include_file')
        let l:params .= ' --include-in-header=' . b:custom_pandoc_include_file
    endif
    let cmd = 'pandoc ' . l:src . ' -o ' . l:out . ' ' . l:params
    augroup pandoc_quickfix | au!
        au QuickFixCmdPost caddexpr belowright copen 8 | winc p
    augroup END
    exec 'AsyncRun -save=1 -cwd=' . expand("%:p:h") '-post=' . l:post l:cmd
endfunc
func! Zathura(file, ...)
    if get(a:, 1, 1)
        call jobstart(['zathura', a:file, '--fork'])
    endif
endfunc
func! SetupTex()
    setlocal conceallevel=2
    set foldlevel=99
    " defaults to asyncrun-project-root
    let b:ale_lsp_root = asyncrun#get_root("%")
    " override textobj-comment
    xmap <buffer> ic <Plug>(vimtex-ic)
    omap <buffer> ic <Plug>(vimtex-ic)
    xmap <buffer> ac <Plug>(vimtex-ac)
    omap <buffer> ac <Plug>(vimtex-ac)
endfunc

let s:pandoc_textobj = {
            \   'begin-end': {
            \     'pattern': ['\\begin{[^}]\+}\s*\n\?', '\s*\\end{[^}]\+}'],
            \     'select-a': 'ae',
            \     'select-i': 'ie',
            \   },
            \   'code': {
            \     'select-a-function': 'stuff#FencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'stuff#FencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \  'dollar-math': {
            \     'select-a-function': 'stuff#DollarMatha',
            \     'select-a': 'am',
            \     'select-i-function': 'stuff#DollarMathi',
            \     'select-i': 'im',
            \   },
            \  'dollar-mathmath': {
            \     'select-a-function': 'stuff#DollarMathMatha',
            \     'select-a': 'aM',
            \     'select-i-function': 'stuff#DollarMathMathi',
            \     'select-i': 'iM',
            \   },
            \ }

" }}}

" search & fzf {{{
" search_mode: which command last set @/?
" `*`, `v_*` without moving the cursor. Reserve @c for the raw original text
" NOTE: Can't repeat properly if ins-special-special is used. Use q-recording.
" -> wrapper for qrcgn...q ?
nnoremap <silent>* :call Star()\|set hlsearch<CR>
vnoremap <silent>* :<C-u>call VisualStar()\|set hlsearch<CR>
" set hlsearch inside the function doesn't work? Maybe :h function-search-undo?
func! Star()
    let g:search_mode = 'n'
    let @c = expand('<cword>')
    let @/ = '\<' . @c . '\>'
endfunc
func! VisualStar()
    let g:search_mode = 'v'
    let l:reg_save = @"
    exec "norm! gvy"
    let @c = @"
    let l:pattern = escape(@", '\.*$^~[]')
    let @/ = l:pattern
    let @" = l:reg_save
endfunc
nnoremap / :let g:search_mode='/'<CR>/

let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1, 'border': 'top', 'highlight': 'VertSplit' } }

" TODO: cycle between Grepf and Grep
nnoremap <leader>G  :<C-u>Grep<space>
nnoremap <leader>g/ :<C-u>Grep <C-r>=RgInput(@/)<CR>
nnoremap <leader>gw :<C-u>Grep <C-r>=expand("<cword>")<CR>
nnoremap <leader>gf :<C-u>Grepf<space>
noremap  <leader>b  :<C-u>Buffers<CR>
noremap  <C-f>      :<C-u>Files<CR>
noremap  <leader>hh :<C-u>History<CR>
noremap  <leader>h: :<C-u>History:<CR>
noremap  <leader>h/ :<C-u>History/<CR>

augroup fzf | au!
    if has('nvim')
        au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        au TermOpen * tnoremap <buffer> <C-q> <c-\><c-n>
        au FileType fzf tunmap <buffer> <Esc>
        au FileType fzf tunmap <buffer> <C-q>
    else
        tnoremap <C-q> <Esc>
    endif
augroup END

command! -nargs=* -bang Grep  call Ripgrep(<q-args>)
command! -nargs=* -bang Grepf call RipgrepFly(<q-args>)
command! -bang -nargs=? -complete=dir Files call Files(<q-args>)

func! FzfOpts(arg, spec)
    " TODO: use merge()?
    let l:opts = string(a:arg)
    " fullscreen
    if l:opts =~ '2' | let a:spec['window'] = { 'width': 1, 'height': (&lines-(tabpagenr()>1)-1.0)/&lines, 'yoffset': 1, 'border': 'top', 'highlight': 'VertSplit' } | endif
    " from project root
    if l:opts =~ '3' | let a:spec['dir'] = asyncrun#get_root("%") | endif
endfunc
func! RgInput(raw)
    if g:search_mode == 'n'
        return substitute(a:raw, '\v\\[<>]','','g')
    elseif g:search_mode == 'v'
        return escape(a:raw, '+|?-(){}') " not escaped by VisualStar
    else " can convert most of strict very magic to riggrep regex, otherwise, DIY
        if a:raw[0:1] != '\v'
            return substitute(a:raw, '\v\\[<>]','','g')
        endif
        return substitute(a:raw[2:], '\v\\([~/])', '\1', 'g')
    endif
endfunc
let g:rg_cmd_base = 'rg --column --line-number --no-heading --color=always --colors path:fg:218 --colors match:fg:116 --smart-case '
func! Ripgrep(query)
    let cmd = g:rg_cmd_base . shellescape(a:query)
    let spec = {'options': ['--info=inline']}
    call FzfOpts(v:count, spec)
    call fzf#vim#grep(cmd, 1, fzf#vim#with_preview(spec, 'up'))
endfunc
func! RipgrepFly(query)
    let command_fmt = g:rg_cmd_base . '%s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--info=inline']}
    call FzfOpts(v:count, spec)
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, 'up'))
endfunc
func! Files(query)
    let spec = {}
    call FzfOpts(v:count, spec)
    if empty(a:query) && !empty(get(spec, 'dir', ''))
        let l:query = spec['dir']
        unlet spec['dir']
        let spec['options'] = ['--prompt', fnamemodify(l:query, ':~:.') . '/']
    else
        let l:query = a:query
    endif
    call fzf#vim#files(l:query, spec)
endfunc

" }}}

" Motion, insert mode, ... {{{
" HJKL for wrapped lines. <leader>J for joins
noremap <S-j> gj
noremap <S-k> gk
noremap <S-h> h
noremap <S-l> l
noremap <leader>J J

" space to navigate
nnoremap <space> <C-d>
nnoremap <c-space> <C-u>
" <s-space> does not work

nnoremap <M-0> ^w
vnoremap <M-0> ^w

let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi Sneak guifg=black guibg=#afff00 ctermfg=black ctermbg=154

" TODO: (speicial char -> non-blank, non-keyword), user-defined (paren -> pair?)
" s-word: (a keyword | repetition of non-paren speicial char | a paren | whitespace)
let g:sword = '\v(\k+|([^[:alnum:]_[:blank:](){}[\]<>$])\2*|[(){}[\]<>$]|\s+)'

" Jump past a sword. Assumes `set whichwrap+=]` for i_<Right>
inoremap <silent><C-j> <C-\><C-O>:call SwordJumpRight()<CR><Right><C-\><C-o><ESC>
inoremap <silent><C-k> <C-\><C-O>:call SwordJumpLeft()<CR>
noremap! <C-space> <C-k>
" TODO: `e` replacement
nnoremap <silent><M-e> :call search(g:sword, 'eW')<CR>
func! SwordJumpRight()
    if col('.') !=  col('$')
        call search(g:sword, 'ceW')
    endif
endfunc
func! SwordJumpLeft()
    call search(col('.') != 1 ? g:sword : '\v$', 'bW')
endfunc

let s:sword_textobj = { 'sword': {
            \ 'pattern': g:sword,
            \ 'select': ['ir', 'ar'],
            \ 'move-p': '<M-b>'
            \ } }
call textobj#user#plugin('sword', s:sword_textobj)

inoremap <CR> <C-G>u<CR>
inoremap <C-u> <C-\><C-o><ESC><C-g>u<C-u>
" Delete a single character of other non-blank chars
" TODO: delete sword
inoremap <expr><C-w> FineGrainedICtrlW()
func! FineGrainedICtrlW()
    let l:col = col('.')
    if l:col == 1 | return "\<BS>" | endif
    let l:before = strpart(getline('.'), 0, l:col - 1)
    let l:chars = split(l:before, '.\zs')
    if l:chars[-1] =~ '\s'
        let l:len = len(l:chars)
        let l:idx = 1
        while l:idx < l:len && l:chars[-(l:idx + 1)] =~ '\s'
            let l:idx += 1
        endwhile
        " TODO: default to <c-w> if \k or [paren]
        if l:idx == l:len || l:chars[-(l:idx + 1)] =~ '\k'
            return "\<C-\>\<C-o>\<ESC>\<C-w>"
        endif
        let b:sts = &softtabstop
        setlocal softtabstop=0
        return repeat("\<BS>", l:idx) . "\<C-R>=ResetSTS()\<CR>\<BS>"
    " TODO: [paren] only
    elseif l:chars[-1] !~ '\k'
        return "\<BS>"
    else
        return "\<C-\>\<C-o>\<ESC>\<C-w>"
    endif
endfunc
func! ResetSTS()
    let &sts = b:sts
    return ''
endfunc

" extend visual block up to pair opener/closer
let g:pair_opener = '\v("|\[|''|\(|\{|\$)'
let g:pair_closer = '\v("|\]|''|\)|\}|\$)'
vnoremap <silent> <C-j> <ESC>:call VisualJump(1)<CR>
vnoremap <silent> <C-k> <ESC>:call VisualJump(0)<CR>
func! VisualJump(forward)
    let cur_pos = [line('.'), col('.')]
    let left_pos = [line("'<"), col("'<")]
    let right_pos = [line("'>"), col("'>")]
    let on_right = l:left_pos == l:right_pos ? a:forward : l:cur_pos == l:right_pos
    " raw target. need to change if flip detected
    let target = searchpos(l:on_right ? g:pair_closer : g:pair_opener, a:forward ? 'nW' : 'nbW')
    let flipped = l:on_right ? SearchPosLE(l:target, l:left_pos) : SearchPosLE(l:right_pos, l:target)
    let cmd = l:flipped ? 'gvo' : 'gv'
    let cmd .= a:forward ? 'gn' : 'gN'
    let saved_reg = @/
    let @/ = (l:on_right != l:flipped) ? g:pair_closer : g:pair_opener
    let l:wrapscan = &wrapscan
    set nowrapscan
    exec 'norm!' l:cmd
    let &wrapscan = l:wrapscan
    let @/ = l:saved_reg
endfunc
func! SearchPosLE(p1, p2)
    return a:p1[0] < a:p2[0] || (a:p1[0] == a:p2[0] && a:p1[1] <= a:p2[1])
endfunc
" }}}

" etc {{{
map <silent><leader><CR> :noh<CR>
map <leader>ss :setlocal spell!\|setlocal spell?<cr>
map <leader>sc :if &spc == "" \| setl spc< \| else \| setl spc= \| endif \| setl spc?<CR>
map <leader>pp :setlocal paste!\|setlocal paste?<cr>
map <leader>sw :set wrap!\|set wrap?<CR>

map <leader>dp :diffput<CR>
map <leader>do :diffget<CR>

" clipboard.
inoremap <C-v> <C-\><C-o>:setl paste<CR><C-r>+<C-\><C-o>:setl nopaste<CR>
vnoremap <C-c> "+y

" filename
map <silent><leader>fn :echo '<C-R>=expand("%:p")<CR>'<CR>

noremap <F1> <Esc>
inoremap <F1> <Esc>
noremap! <C-q> <C-c>
vnoremap <C-q> <Esc>

cnoremap <M-p> <Up>
cnoremap <M-n> <Down>

" c_CTRL-F for cmd history, gQ to enter ex mode. Q instead of q for macros
noremap q: :
noremap q <nop>
noremap Q q

" delete without clearing regs
noremap x "_x

" repetitive pastes using designated register @p
noremap <M-y> "py
noremap <M-p> "pp

map Y y$

" auto-pairs
let g:AutoPairsMapSpace = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCh = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''
inoremap <silent><M-e> <C-R>=AutoPairsFastWrap("e")<CR>
inoremap <silent><M-E> <C-R>=AutoPairsFastWrap("E")<CR>
inoremap <silent><M-$> <C-R>=AutoPairsFastWrap("$")<CR>
inoremap <silent><M-:> <C-R>=AutoPairsFastWrap("t;")<CR>

" asyncrun
map <leader>R :AsyncRun<space>
map <leader>S :AsyncStop<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
map <leader>M :Make<space>

" quickfix, loclist, ...
command! CV exec 'vert copen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p
command! CO belowright copen 12 | winc p
command! OQ if IsWide() | exec 'CV' | else | exec 'CO' | endif
map <leader>oq :OQ<CR>
command! LV exec 'vert lopen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p
command! LO belowright lopen 12 | winc p
command! OL if IsWide() | exec 'LV' | else | exec 'LO' | endif
map <leader>ol :OL<CR>
map ]q :cn<CR>
map [q :cN<CR>
map ]l :lne<CR>
map [l :lN<CR>
map <silent><leader>x :pc\|ccl\|lcl<CR>

let g:NERDTreeWinPos = "right"
nmap <leader>nn :NERDTreeToggle<cr>
nmap <leader>nf :NERDTreeFind<cr>

let g:gitgutter_enabled=0
nmap <silent><leader>gg :GitGutterToggle<cr>

let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']

let g:mkdp_auto_close = 0
let g:mkdp_preview_options = { 'disable_sync_scroll': 1 }

let g:float_preview#winhl = 'Normal:PmenuSel,NormalNC:PmenuSel'

func! SynStackName()
    return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
func! InSynStack(type)
    for i in synstack(line('.'), col('.'))
        if synIDattr(i, 'name') == a:type
            return 1
        endif
    endfor
    return 0
endfunc
func! IsWide()
    return winwidth(0) > 170
endfunc

" see :help [range], &, g&
" :%s/pat/\r&/g.
" marks
" }}}

" Comments {{{
let g:NERDCreateDefaultMappings = 0
imap <M-/> <Plug>NERDCommenterInsert
vmap <M-/> <Plug>NERDCommenterComment
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
" }}}

" Tabs, windows, buffers {{{
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

map <leader>q :<C-u>q<CR>
map q, :<C-u>q<CR>
nmap <leader>w :<C-u>w!<cr>
command! -bang W   exec 'w<bang>'
command! -bang Q   exec 'q<bang>'
command! -bang Wq  exec 'wq<bang>'
command! -bang Wqa exec 'wqa<bang>'
command! -bang Qa  exec 'qa<bang>'

map <leader>cx :tabclose<cr>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
map <leader>td :tab split<CR>
map <leader>tt :tabedit<CR>
map <leader>cd :cd %:p:h<cr>:pwd<cr>
map <leader>e :e! <c-r>=expand("%:p:h")<cr>/
map <leader>fe :e!<CR>

" switch/return to last tab
" NOTE: breaks/broken by :tabmove
let g:last_tab = 1
let g:last_tab_backup = 1
let g:last_viewed = 1
nmap <silent><leader>` :exec 'tabn' g:last_tab<cr>
augroup LastTab | au!
    au TabLeave * let g:last_tab_backup = g:last_tab | let g:last_tab = tabpagenr()
    au TabEnter * let g:last_viewed = tabpagenr()
    au TabClosed * call OnTabClosed(expand('<afile>'))
augroup END
func! OnTabClosed(closed)
    if a:closed < g:last_tab_backup
        let g:last_tab_backup -= 1
    endif
    if a:closed < g:last_tab
        let g:last_tab -= 1
    elseif a:closed == g:last_tab
        let g:last_tab = g:last_tab_backup
    endif
    let l:target = 0
    if a:closed < g:last_viewed
        let g:last_viewed -= 1
        let l:target = g:last_viewed
    elseif a:closed == g:last_viewed
        let l:target = g:last_tab != g:last_viewed ? g:last_tab : 0
    endif
    if l:target | exec 'tabn' l:target | endif
endfunc

" ctrl-shift-t of chrome. bug: non-existent buf
map <silent><leader><C-t> :call PopQuitBufs()<CR>
" works only for buffers of windows closed by :q, not :tabc
augroup RestoreTab | au!
    au QuitPre * call PushQuitBufs(expand("<abuf>"))
augroup END
" push if clean and empty. remove preceding one if exists
let g:quitbufs = []
func! PushQuitBufs(buf)
    if !IsCleanEmptyBuf(a:buf)
        call tlib#list#Remove(g:quitbufs, a:buf)
        call add(g:quitbufs, a:buf)
    endif
endfunc
func! PopQuitBufs()
    if len(g:quitbufs) > 0
        exec "tabnew +".(remove(g:quitbufs, -1))."buf"
    endif
endfunc

" Garbage buffers
" bw, bd, setlocal bufhidden=delete don't work on the buf being hidden
" defer it until BufEnter to another buf
let g:lasthidden = 0
augroup GarbageBuf | au!
    au BufHidden * let g:lasthidden = expand("<abuf>")
    au BufEnter * call CheckAndBW(g:lasthidden)
augroup END
func! CheckAndBW(buf)
    if IsCleanEmptyBuf(a:buf)
        exec "bw" a:buf
    endif
endfunc

" https://stackoverflow.com/questions/6552295.`+` signs??
func! IsCleanEmptyBuf(buf)
    return a:buf > 0 && buflisted(+a:buf) && empty(bufname(+a:buf)) && !getbufvar(+a:buf, "&mod")
endfunc

func! CleanGarbageBufs()
    let bufs = filter(range(1, bufnr('$')), 'IsCleanEmptyBuf(v:val) && bufwinnr(v:val)<0')
    if !empty(bufs)
        exec 'bw' join(bufs, ' ')
    endif
endfunc
" }}}
