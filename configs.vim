" vim: set foldmethod=marker foldlevel=0:

let s:nvim_latest_stable = has('nvim-0.7')
let g:ide_client = get(g:, 'ide_client', s:nvim_latest_stable ? 'nvim' : 'coc')

if !has('nvim')
    let g:loaded_getscriptPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_logiPat = 1
endif
let g:loaded_spellfile_plugin = 1

" TODO: packadd-based, lazy-loaded (event, normal, ex), vim/nvim compatible plugin manager?
" TODO: post-update hook doesn't work on nvim-0.6 Vim(call):E117: Unknown function: mkdp#util#install ... This happens only when installing (not updating). So nvim might be checking existence of the directory when rtp is modified.
" https://github.com/neovim/neovim/issues/18822
" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug 'tomtomjhj/lightline.vim' " https://github.com/itchyny/lightline.vim/pull/631
Plug 'tomtomjhj/taiga.vim'

" editing
Plug 'tomtomjhj/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-repeat'
Plug 'tomtomjhj/pear-tree'
Plug 'andymass/vim-matchup' " i%, a%, ]%, z%, g% TODO: % that seeks backward https://github.com/andymass/vim-matchup/issues/49#issuecomment-470933348
Plug 'wellle/targets.vim' " multi (e.g. ib, iq), separator, argument
Plug 'tomtomjhj/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'pianohacker/vim-textobj-indented-paragraph', { 'do': 'rm -rf plugin' }
Plug 'Julian/vim-textobj-variable-segment' " iv, av
Plug 'tomtomjhj/vim-commentary'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'whonore/vim-sentencer'

" etc
" TODO:
" * :G log unicode broken
" * '--git-completion-helper'-based completion (#1265) doesn't complete many things for git log e.g. --grep
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-rhubarb'
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': has('unix') ? './install --all' : { -> fzf#install() } }
" TODO: :Buffers multiple select makes sense for :tabe, :sp, ...
" Make sth similar to that for small.vim
" See also https://github.com/junegunn/fzf.vim/pull/1239
Plug 'junegunn/fzf.vim'
Plug 'roosta/fzf-folds.vim'
Plug 'Konfekt/FastFold' " only useful for non-manual folds
Plug 'romainl/vim-qf'
Plug 'markonm/traces.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'kassio/neoterm'
Plug 'inkarkat/vim-mark', { 'on': ['<Plug>MarkS', 'Mark'] }
Plug 'inkarkat/vim-ingo-library'

" lanauges
Plug 'dense-analysis/ale', { 'on': ['<Plug>(ale_', 'ALEEnable'] } ")
if g:ide_client == 'coc'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    " Plug '~/apps/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
    Plug 'antoinemadec/coc-fzf'
elseif g:ide_client == 'nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    " Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lsp'
    " hrsh7th/cmp-nvim-lsp-signature-help
    Plug 'hrsh7th/cmp-path'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'ojroques/nvim-lspfuzzy'
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'folke/lua-dev.nvim'
    Plug 'simrat39/rust-tools.nvim'
    " https://github.com/p00f/clangd_extensions.nvim
    Plug 'vigoux/ltex-ls.nvim'
endif
" TODO: use vsnip? (supports vscode snippets)
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets', { 'do': 'rm -f snippets/_.snippets snippets/tex.snippets UltiSnips/all.snippets UltiSnips/tex.snippets' }
Plug 'tomtomjhj/tpope-vim-markdown'
Plug 'tomtomjhj/vim-markdown'
let g:pandoc#filetypes#pandoc_markdown = 0 | Plug 'vim-pandoc/vim-pandoc'
Plug 'tomtomjhj/vim-pandoc-syntax'
Plug 'tomtomjhj/vim-rust-syntax-ext'| Plug 'rust-lang/rust.vim'
Plug 'tomtomjhj/vim-ocaml'
Plug 'tomtomjhj/haskell-vim', { 'branch': 'custom' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
Plug 'tomtomjhj/Coqtail'
" Plug 'puremourning/vimspector' | let g:vimspector_enable_mappings = 'HUMAN'
Plug 'neoclide/jsonc.vim'
Plug 'rhysd/vim-llvm'
Plug 'fatih/vim-go', { 'do': 'rm -rf plugin ftplugin' }
Plug 'vim-python/python-syntax'
Plug 'tbastos/vim-lua'
" Plug 'rhysd/vim-grammarous', { 'for': ['markdown', 'tex'] } | let g:grammarous#use_location_list = 1

" etc etc
if has('nvim')
    Plug 'antoinemadec/FixCursorHold.nvim'
endif
if s:nvim_latest_stable
    " NOTE: when using local install of nvim, should reinstall
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    " Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'
    " NOTE: should do `rm ~/.cache/nvim/luacache*` after upgrading nvim
    Plug 'lewis6991/impatient.nvim'
endif

" NOTE: This runs `filetype plugin indent on`, which registers au FileType.
" Custom au FileType should be registered after this.
call plug#end()

if s:nvim_latest_stable
    lua require('impatient')
endif
" }}}

" Basic {{{
command! -nargs=1 Noremap exe 'nnoremap' <q-args> | exe 'xnoremap' <q-args> | exe 'onoremap' <q-args> 
command! -nargs=1 Map exe 'nmap' <q-args> | exe 'xmap' <q-args> | exe 'omap' <q-args>

set encoding=utf-8

set mouse=nvi
set number signcolumn=number
set ruler showcmd
set foldcolumn=1 foldnestmax=5
set scrolloff=2 sidescrolloff=2 sidescroll=1 startofline
set showtabline=1
set laststatus=2

set shiftwidth=4
set expandtab smarttab
set autoindent
set formatoptions+=jn formatoptions-=c
set formatlistpat=\\C^\\s*[\\[({]\\\?\\([0-9]\\+\\\|[iIvVxXlLcCdDmM]\\+\\\|[a-zA-Z]\\)[\\]:.)}]\\s\\+\\\|^\\s*[-+o*]\\s\\+
set nojoinspaces
set list listchars=tab:\|\ ,trail:-,nbsp:+,extends:>

set wrap linebreak breakindent showbreak=↪\ 
let &backspace = (has('patch-8.2.0590') || has('nvim-0.5')) ? 3 : 2
set whichwrap+=<,>,[,],h,l
set cpoptions-=_

let $LANG='en'
set langmenu=en
set spellfile=~/.vim/spell/en.utf-8.add
set spelllang=en,cjk

let mapleader = "\<Space>"
Noremap <Space> <Nop>
let maplocalleader = ","
Noremap , <Nop>
Noremap <M-;> ,
" scrolling with only left hand
Noremap <C-Space> <C-u>
Noremap <Space><Space> <C-d>

set wildmenu wildmode=longest:full,full
let s:wildignore_files = ['*~', '%*', '*.o', '*.so', '*.pyc', '*.pdf', '*.v.d', '*.vo*', '*.glob', '*.cm*', '*.aux']
let s:wildignore_dirs = ['.git', '__pycache__', 'target']
set complete-=i complete-=u
set path=.,,

set ignorecase smartcase tagcase=match
set hlsearch incsearch

set noerrorbells novisualbell t_vb=
set shortmess+=Ic shortmess-=S
set belloff=all

set history=1000
set viminfo=!,'150,<50,s30,h,r/tmp,r/run,rterm://,rfugitive://,rfern://,rman://
set updatetime=1234
set noswapfile " set directory=~/.vim/swap//
set backup backupdir=~/.vim/backup//
set undofile
" TODO: backupskip for undofile?
if has('nvim-0.5') | set undodir=~/.vim/undoo// | else | set undodir=~/.vim/undo// | endif

set autoread
set splitright splitbelow " TODO: not natural for Gdiffsplit with object
if (has('patch-8.1.2315') || has('nvim-0.5')) | set switchbuf+=uselast | endif
set hidden
set lazyredraw

set modeline " debian unsets this
set exrc secure
if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt+=algorithm:histogram,indent-heuristic
endif

augroup BasicSetup | au!
    " Return to last edit position when entering normal buffer
    " TODO: this addes jump? manually running is ok. maybe autocmd problem?
    " TODO: Commit file shouldn't store marks in the first place
    au BufRead * if empty(&buftype) && &filetype !~# '\v%(commit)' && line("'\"") > 1 && line("'\"") <= line("$") | exec "norm! g`\"" | endif
    au VimEnter * exec 'tabdo windo clearjumps' | tabnext
    au BufWritePost ~/.vim/configs.vim nested source ~/.vim/configs.vim
    au BufRead,BufNewFile *.k setlocal filetype=k
    au BufRead,BufNewFile *.mir setlocal syntax=rust
    au FileType lisp let b:pear_tree_pairs = deepcopy(g:pear_tree_pairs) | call remove(b:pear_tree_pairs, "'")
    au FileType help nnoremap <silent><buffer> <M-.> K
    let &pumheight = min([&window/4, 20])
    au VimResized * let &pumheight = min([&window/4, 20])
    if has('nvim')
        au TermOpen,WinEnter *           if &buftype is# 'terminal' | setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no | endif
    elseif exists('##TerminalWinOpen')
        au TerminalWinOpen,BufWinEnter * if &buftype is# 'terminal' | setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no | endif
    endif
augroup END

if has('unix')
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}

" gui settings {{{
let g:gui_running = get(g:, 'gui_running', 0)
function! s:SetupGUI() abort
    let g:gui_running = 1
    set guifont=Source\ Code\ Pro:h12
    nnoremap <C--> <Cmd>FontSize -v:count1<CR>
    if has('gui_running')
        nnoremap <C-_> <Cmd>FontSize -v:count1<CR>
    endif
    nnoremap <C-+> <Cmd>FontSize v:count1<CR>
    nnoremap <C-=> <Cmd>FontSize v:count1<CR>
    command! -nargs=1 FontSize call s:FontSize(<args>)
    function! s:FontSize(delta)
        let new_size = matchstr(&guifont, '\d\+') + a:delta
        let new_size = (new_size < 1) ? 1 : ((new_size > 100) ? 100 : new_size)
        let &guifont = substitute(&guifont, '\d\+', '\=new_size', '')
    endfunction

    if has('gui_running') " gvim
        set guioptions=i
        set guicursor+=a:blinkon0
        if has('win32')
            set guifont=Source_Code_Pro:h12:cANSI:qDRAFT
        elseif has('unix')
            set guifont=Source\ Code\ Pro\ 12
        endif
    elseif exists('g:GuiLoaded') " nvim-qt
        GuiTabline 0
        GuiPopupmenu 0
    elseif exists('g:started_by_firenvim')
        set guifont=Source\ Code\ Pro:h20
    elseif exists('g:neovide')
        let g:neovide_cursor_animation_length = 0
    endif
endfunction

if has('nvim')
    au UIEnter * ++once if v:event.chan | call s:SetupGUI() | endif
elseif has('gui_running')
    call s:SetupGUI()
endif

" TODO:
" - neovide doesn't understand <C-M-L>, .. https://github.com/neovide/neovide/issues/994#issuecomment-1063500913 works
" }}}

" Statusline {{{
let g:lightline = {
      \ 'colorscheme': 'powerwombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['specialwin', 'title', 'bufstate'],
      \             ['curr_func', 'git'] ],
      \   'right': [ ['lineinfo'], ['percent'],
      \              ['checker_errors', 'checker_warnings', 'checker_status'],
      \              ['searchcount', 'asyncrun'] ]
      \ },
      \ 'inactive': {
      \   'left': [ ['specialwin', 'title'],
      \             ['bufnr_winnr'] ],
      \   'right': [ ['lineinfo'], ['percent'],
      \              ['checker_errors_inactive', 'checker_warnings_inactive'] ]
      \ },
      \ 'component': {
      \   'specialwin': '%w%q%h',
      \   'asyncrun': '%{get(g:,"asyncrun_status","")[:3]}',
      \   'bufnr_winnr': '%n@%{winnr()}'
      \ },
      \ 'component_function': {
      \   'git': 'GitStatusline',
      \   'title': 'STLTitle',
      \   'bufstate': 'STLBufState',
      \   'curr_func': 'CurrentFunction',
      \   'checker_status': 'CheckerStatus',
      \   'checker_errors_inactive': 'CheckerErrors',
      \   'checker_warnings_inactive': 'CheckerWarnings',
      \   'searchcount': 'SearchCount',
      \ },
      \ 'component_expand': {
      \  'checker_errors': 'CheckerErrors',
      \  'checker_warnings': 'CheckerWarnings',
      \ },
      \ 'component_type': {
      \     'checker_errors': 'error',
      \     'checker_warnings': 'warning',
      \ },
      \ 'component_visible_condition': {
      \   'specialwin': '&previewwindow||&buftype==#"quickfix"||&buftype==#"help"',
      \   'asyncrun': '!empty(get(g:,"asyncrun_status",""))',
      \ },
      \ 'component_function_visible_condition': {
      \   'searchcount': 'v:hlsearch',
      \   'title': 1,
      \   'git': '!empty(FugitiveGitDir())',
      \ },
      \ 'mode_map': {
      \     'n' : 'N ',
      \     'i' : 'I ',
      \     'R' : 'R ',
      \     'v' : 'V ',
      \     'V' : 'VL',
      \     "\<C-v>": 'VB',
      \     'c' : 'C ',
      \     's' : 'S ',
      \     'S' : 'SL',
      \     "\<C-s>": 'SB',
      \     't': 'T ',
      \ }
      \ }
function! STLTitle() abort
    let bt = &buftype
    let ft = &filetype
    let bname = bufname('%')
    " NOTE: bt=quickfix,help decides filetype
    if bt is# 'quickfix'
        " NOTE: getwininfo() to differentiate quickfix window and location window
        return get(w:, 'quickfix_title', ':')
    elseif bt is# 'help'
        return fnamemodify(bname, ':t')
    elseif bt is# 'terminal'
        return has('nvim') ? '!' . matchstr(bname, 'term://\f\{-}//\d\+:\zs.*') : bname
    elseif ft is# 'fern'
        return pathshorten(fnamemodify(b:fern.root._path, ":~")) . '/'
    elseif bname =~# '^fugitive://'
        let [obj, gitdir] = FugitiveParse(bname)
        let matches = matchlist(obj, '\v(:\d?|\x+)(:\f*)?')
        return pathshorten(fnamemodify(gitdir, ":~:h")) . ' ' . matches[1][:9] . matches[2]
    elseif get(b:, 'fugitive_type', '') is# 'temp'
        return pathshorten(fnamemodify(bname, ":~:.")) . ' :Git ' . join(FugitiveResult(bname)['args'], ' ')
    elseif ft is# 'gl'
        return ':GL' . join([''] + b:gl_args, ' ')
    elseif empty(bname)
        return empty(bt) ? '[No Name]' : bt is# 'nofile' ? '[Scratch]' : '?'
    else
        return pathshorten(fnamemodify(bname, ":~:."))
    endif
endfunction
function! STLBufState() abort
    let bt = &buftype
    let ft = &filetype
    let bname = bufname('%')
    if !(empty(bt) || bt is# 'acwrite' || bt is# 'nofile' || bt is# 'nowrite')
      \ || ft is# 'fern' || ft is# 'git' || ft is# 'gl'
      \ || (exists('b:fugitive_type') && b:fugitive_type isnot# 'blob')
        return ''
    endif
    return (&readonly ? '🔒' : '') . (&modified ? '[+]' : '') . (&modifiable ? '' : '[-]')
endfunction
function! SearchCount()
    if !v:hlsearch | return '' | endif
    try
        let result = searchcount(#{recompute: 1, maxcount: -1})
        if empty(result) || result.total ==# 0
            return ''
        endif
        if result.incomplete ==# 1
            return printf('[?/??]')
        elseif result.incomplete ==# 2
            if result.total > result.maxcount && result.current > result.maxcount
                return printf('[>%d/>%d]', result.current, result.total)
            elseif result.total > result.maxcount
                return printf('[%d/>%d]', result.current, result.total)
            endif
        endif
        return printf('[%d/%d]', result.current, result.total)
    catch
        return ''
    endtry
endfunction
" }}}

" ColorScheme {{{
let g:taiga_full_special_attrs_support = 1
if exists('g:colors_name') " loading the color again breaks lightline
else
    colorscheme taiga
endif
silent! set termguicolors
command! Bg if &background ==# 'dark' | set background=light | else | set background=dark | endif
" }}}

" Completion {{{
if g:ide_client == 'coc'
    inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1): <SID>check_back_space() ? '<Tab>' : '<Cmd>call coc#start()<CR>'
    inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : <SID>check_back_space() ? '<C-h>' : '<Cmd>call coc#start()<CR>'
elseif g:ide_client == 'nvim'
    lua require'tomtomjhj/cmp'
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE, LSP, ... global settings. See ./plugin/lsp.vim {{{
let g:ale_linters = {}
let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'python': ['black'],
            \ 'ocaml': ['ocamlformat'],
            \ 'go': ['gofmt'],
            \ '*': ['trim_whitespace']
            \ }
let g:ale_set_highlights = 1
let g:ale_linters_explicit = 1

let g:coc_config_home = '~/.vim'
" coc-rust-analyzer coc-pyright coc-texlab coc-clangd coc-tsserver coc-go coc-tag
let g:coc_global_extensions = ['coc-vimlsp', 'coc-ultisnips', 'coc-json']
let g:coc_quickfix_open_command = 'CW'
let g:coc_fzf_preview = 'up:66%'
" for https://github.com/valentjn/vscode-ltex/issues/425
let g:coc_filetype_map = {'tex': 'latex'}

" :h coc-highlights
hi! def link CocFadeOut             LspCodeLens
hi! def link CocErrorSign           DiagnosticSignError
hi! def link CocWarningSign         DiagnosticSignWarn
hi! def link CocInfoSign            DiagnosticSignInfo
hi! def link CocHintSign            DiagnosticSignHint
hi! def link CocErrorVirtualText    DiagnosticVirtualTextError
hi! def link CocWarningVirtualText  DiagnosticVirtualTextWarn
hi! def link CocInfoVirtualText     DiagnosticVirtualTextInfo
hi! def link CocHintVirtualText     DiagnosticVirtualTextHint
hi! def link CocRustTypeHint LspCodeLens
hi! def link CocRustChainingHint LspCodeLens

nmap <leader>fm <Plug>(ale_fix)
nmap <M-,> <Plug>(ale_detail)<C-W>p
nmap ]d <Plug>(ale_next_wrap)
nmap [d <Plug>(ale_previous_wrap)
Noremap  <M-.> K
Noremap  <M-]> <C-]>
nnoremap <M-o> <C-o>
nnoremap <M-i> <C-i>
" }}}

" Languages {{{
" see also {,after/}{indent,ftplugin}/, SetupLSP(), SetupLSPPost()
augroup Languages | au!
    au FileType bib call s:bib()
    au FileType c,cpp,cuda call s:c_cpp()
    au FileType coq,coq-goals,coq-infos call s:coq_common()
    au FileType coq call s:coq()
    au FileType coq-goals,coq-infos call s:coq_aux()
    au FileType go call s:go()
    au FileType haskell call s:haskell()
    au FileType lua call s:lua()
    au FileType markdown call s:markdown()
    au FileType ocaml call s:ocaml()
    au FileType pandoc call s:pandoc()
    au FileType python call s:python()
    au FileType tex call s:tex()
    au FileType rust call s:rust()
    au FileType vim setlocal formatoptions-=c
    au FileType xml setlocal formatoptions-=r " very broken: <!--<CR> → <!--\n--> █
augroup END

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
function! s:haskell() abort
    setlocal shiftwidth=2
endfunction
" }}}

" Rust {{{
" RLS hover info is more accurate than rust-analyzer!
" https://doc.ecoscentric.com/gnutools/doc/gdb/Rust.html
" let g:termdebugger = 'rust-gdb'
" TODO: add completion in cargo command
let g:cargo_shell_command_runner = 'AsyncRun -post=CW'
" https://github.com/rust-lang/rust-clippy/issues/4612
command! -nargs=* Cclippy call cargo#cmd("+nightly clippy -Zunstable-options " . <q-args>)
command! -range=% PrettifyRustSymbol <line1>,<line2>SubstituteDict { '$SP$': '@', '$BP$': '*', '$RF$': '&', '$LT$': '<', '$GT$': '>', '$LP$': '(', '$RP$': ')', '$C$' : ',',  '$u20$': ' ', '$u7b$': '{', '$u7d$': '}', }
function! s:rust() abort
    setlocal path+=src
    " TODO fix 'spellcapcheck' for `//!` comments, also fix <leader>sc mapping
    " TODO: matchit handle < -> non-pair
    let b:pear_tree_pairs['|'] = {'closer': '|'}
    if g:ide_client == 'coc'
        command! -buffer ExpandMacro CocCommand rust-analyzer.expandMacro
    endif
    nmap <buffer><leader>C :AsyncRun -program=make -post=CW test --no-run<CR>
    xmap <buffer><leader>fm :RustFmtRange<CR>
    nmap <silent><buffer> [[ :call tomtomjhj#rust#section(1)<CR>
    nmap <silent><buffer> ]] :call tomtomjhj#rust#section(0)<CR>
endfunction
" }}}

" C,C++ {{{
function s:c_cpp() abort
    setlocal shiftwidth=2
    setlocal commentstring=//%s
    silent! setlocal formatoptions+=/ " 8.2.4907
    setlocal path+=include,/usr/include
endfunction
" }}}

" Python {{{
let g:python_highlight_all = 1
let g:python_highlight_builtin_funcs = 0
function! s:python() abort
    setlocal foldmethod=indent foldnestmax=2 foldignore=
    setlocal formatoptions+=ro
endfunction
" }}}

" LaTex {{{
let g:tex_flavor = 'latex'
let g:tex_noindent_env = '\v\w+.?'
let g:vimtex_fold_enabled = 1
let g:matchup_override_vimtex = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:vimtex_indent_on_ampersands = 0
let g:vimtex_toc_config_matchers = {
            \ 'todo_notes': {
                \ 're' : g:vimtex#re#not_comment . '\\\w*%(todo|jaehwang)\w*%(\[[^]]*\])?\{\zs.*',
                \ 'prefilter_cmds': ['todo', 'jaehwang']}
            \}
let g:vimtex_syntax_nospell_comments = 1
" NOTE: If inverse search doesn't work, check if source files are correctly recognized by vimtex.
function! s:tex() abort
    setlocal shiftwidth=2
    setlocal conceallevel=2
    setlocal foldlevel=99 " {[{[
    setlocal indentkeys-=] indentkeys-=} indentkeys-=\& indentkeys+=0],0}
    " https://github.com/tmsvg/pear-tree/pull/27
    let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
                \ '\\begin{*}': {'closer': '\\end{*}', 'until': '[{}[:space:]]'},
                \ '$$': {'closer': '$$'},
                \ '$': {'closer': '$'}
                \ }, 'keep')
    " override textobj-comment
    xmap <buffer> ic <Plug>(vimtex-ic)
    omap <buffer> ic <Plug>(vimtex-ic)
    xmap <buffer> ac <Plug>(vimtex-ac)
    omap <buffer> ac <Plug>(vimtex-ac)
    nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h").'/main.pdf'<CR>")<CR>
    nmap <buffer>        <leader>C <Cmd>update<CR><Plug>(vimtex-compile-ss)
endfunction
function! s:bib() abort
    setlocal shiftwidth=2
    " unmap broken vimtex-% in bib
    silent! unmap <buffer> %
    nmap <buffer>        <leader>C <Cmd>update<CR><Plug>(vimtex-compile-ss)
endfunction
" }}}

" Markdown, Pandoc {{{
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "hypertext", "yaml"]
" Surround triggers equalprg (pandoc -t markdown), which modifies the text a lot
let g:pandoc#formatting#equalprg = ''
let g:pandoc#folding#level = 99
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
let g:markdown_fenced_languages = []
let g:markdown_folding = 1
" let g:mkdp_port = '8080'
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_close = 0
let g:mkdp_page_title = '${name}'
" TODO: manually scroll to position in browser that matches the cursor position?
let g:mkdp_preview_options = {
            \ 'mkit': { 'typographer': v:false },
            \ 'disable_sync_scroll': 1 }
function! s:markdown() abort
    setlocal foldlevel=6

    let s:mkd_textobj = {
                \   'code': {
                    \     'select-a-function': 'tomtomjhj#markdown#FencedCodeBlocka',
                    \     'select-a': '<buffer> ad',
                    \     'select-i-function': 'tomtomjhj#markdown#FencedCodeBlocki',
                    \     'select-i': '<buffer> id',
                    \   },
                    \ }
    silent! call textobj#user#plugin('markdown', s:mkd_textobj)
    " TODO:
    " * list item text object
    " * make paragraph, sentence text object list-aware

    " <> pair is too intrusive
    setlocal matchpairs-=<:>
    " Set from $VIMRUNTIME/ftplugin/html.vim
    let b:match_words = substitute(b:match_words, '<:>,', '', '')

    nmap     <buffer>             <leader>pd :setlocal ft=pandoc\|unmap <lt>buffer><lt>leader>pd<CR>
    nnoremap <buffer><expr> <localleader>b tomtomjhj#surround#strong('')
    xnoremap <buffer><expr> <localleader>b tomtomjhj#surround#strong('')
    nnoremap <buffer><expr> <localleader>~ tomtomjhj#surround#strike('')
    xnoremap <buffer><expr> <localleader>~ tomtomjhj#surround#strike('')
    nmap     <buffer>          <MiddleMouse> <LeftMouse><localleader>biw
    xmap     <buffer>          <MiddleMouse> <localleader>b
    nnoremap <buffer><silent>     <leader>tf :TableFormat<CR>
endfunction
function! s:pandoc() abort
    runtime! ftplugin/markdown.vim
    let s:pandoc_textobj = {
                \   'begin-end': {
                \     'pattern': ['\\begin{[^}]\+}\s*\n\?', '\s*\\end{[^}]\+}'],
                \     'select-a': '<buffer> ae',
                \     'select-i': '<buffer> ie',
                \   },
                \  'dollar-math': {
                \     'select-a-function': 'tomtomjhj#markdown#PandocDollarMatha',
                \     'select-a': '<buffer> am',
                \     'select-i-function': 'tomtomjhj#markdown#PandocDollarMathi',
                \     'select-i': '<buffer> im',
                \   },
                \  'dollar-mathmath': {
                \     'select-a-function': 'tomtomjhj#markdown#PandocDollarMathMatha',
                \     'select-a': '<buffer> aM',
                \     'select-i-function': 'tomtomjhj#markdown#PandocDollarMathMathi',
                \     'select-i': '<buffer> iM',
                \   },
                \ }
    silent! call textobj#user#plugin('pandoc', s:pandoc_textobj)
    silent! TextobjPandocDefaultKeyMappings!

    let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
                \ '$': {'closer': '$'},
                \ '$$': {'closer': '$$'},
                \ '`': {'closer': '`'},
                \ '```': {'closer': '```'},
                \ })

    let b:match_words = &l:matchpairs .
                \ ',' . '\%(^\s*\)\@<=\\begin{\(\w\+\*\?\)}' . ':' . '\%(^\s*\)\@<=\\end{\1}'

    " set to notoplevel in haskell.vim
    syntax spell toplevel

    command! -buffer -bang Pandoc call tomtomjhj#markdown#RunPandoc(<bang>0)

    nmap <buffer><silent><leader>C :Pandoc<CR>
    nmap <buffer><silent><leader>O :Pandoc!<CR>
    nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h").'/'.expand("%:t:r").'.pdf'<CR>")<CR>
    nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    nmap <buffer>zM :call pandoc#folding#Init()\|unmap <lt>buffer>zM<CR>zM
endfunction
function! Zathura(file, ...)
    if get(a:, 1, 1)
        call jobstart(['zathura', a:file, '--fork'])
    endif
endfunction
" }}}

" ocaml {{{
let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'
let g:ocaml_highlight_operators = 1
function! s:ocaml() abort
    setlocal tabstop=2 shiftwidth=2
    nmap <buffer><leader>C :AsyncRun -program=make -post=CocRestart<CR>
endfunction
" }}}

" go {{{
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
function! s:go() abort
    setlocal noexpandtab
    exe 'setlocal shiftwidth='.&l:tabstop
    setlocal path+=vendor
    let b:undo_ftplugin .= " | setl et< sw< path<"
endfunction
" }}}

" Coq {{{
let g:coqtail_nomap = 1
let g:coqtail_noindent_comment = 1
let g:coqtail_tagfunc = 0
function! s:coq_common() abort
    let b:pear_tree_pairs = deepcopy(g:pear_tree_pairs)
    call remove(b:pear_tree_pairs, "'")
    setlocal shiftwidth=2
    " no middle piece & comment leader
    setlocal comments=s:(*,e:*) formatoptions=qnj
    " NOTE: 'r', 'o' flags don't distinguish bullet '*' and comment leader '*'
    " setlocal comments=sr:(*,mb:*,ex:*) formatoptions=roqnj
    " TODO: coq uses zero-based column index..                     vv
    setlocal errorformat=File\ \"%f\"\\,\ line\ %l\\,\ characters\ %c-%*[0-9]:
    setlocal matchpairs+=⌜:⌝,⎡:⎤
    setlocal path+=theories,_opam/lib/coq/theories,_opam/lib/coq/user-contrib/*
    call tomtomjhj#coq#mappings()
endfunction
function! s:coq() abort
    setlocal foldmethod=manual
    if expand("%:p") =~# '_opam/lib/coq'
        setlocal readonly
    endif
endfunction
function! s:coq_aux() abort
    setlocal foldcolumn=0
endfunction
" }}}

" Lua {{{
let g:lua_syntax_noextendedstdlib = 1
function! s:lua() abort
    setlocal shiftwidth=2
endfunction
" }}}

let g:lisp_rainbow = 1
" }}}

" search & fzf {{{
" search_mode: which command last set @/?
" `*`, `v_*` without moving the cursor. Reserve @c for the raw original text
" NOTE: Can't repeat properly if ins-special-special is used. Use q-recording.
nnoremap <silent>* :<C-u>call Star(0)\|set hlsearch<CR>
nnoremap <silent>g* :<C-u>call Star(1)\|set hlsearch<CR>
xnoremap <silent>* :<C-u>call VisualStar(0)\|set hlsearch<CR>
xnoremap <silent>g* :<C-u>call VisualStar(1)\|set hlsearch<CR>
" set hlsearch inside the function doesn't work? Maybe :h function-search-undo?
" NOTE: word boundary is syntax property -> may not match in other ft buffers
let g:search_mode = get(g:, 'search_mode', '/')
func! Star(g)
    let @c = expand('<cword>')
    " <cword> can be non-keyword
    if match(@c, '\k') == -1
        let g:search_mode = 'v'
        let @/ = Text2Magic(@c)
    else
        let g:search_mode = 'n'
        let @/ = a:g ? @c : '\<' . @c . '\>'
    endif
    call histadd('/', @/)
endfunc
func! VisualStar(g)
    let g:search_mode = 'v'
    let l:reg_save = @"
    " don't trigger TextYankPost
    noau silent! normal! gvy
    let @c = @"
    let l:pattern = Text2Magic(@")
    let @/ = a:g ? '\<' . l:pattern . '\>' : l:pattern " reversed
    call histadd('/', @/)
    let @" = l:reg_save
endfunc
nnoremap / :let g:search_mode='/'<CR>/
nnoremap ? :let g:search_mode='/'<CR>?

let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }
" let g:fzf_preview_window = 'right:50%:+{2}-/2'

nnoremap <C-g>      :<C-u>Grep<space>
nnoremap <leader>g/ :<C-u>Grep <C-r>=RgInput(@/)<CR>
nnoremap <leader>gw :<C-u>Grep \b<C-R>=expand('<cword>')<CR>\b
nnoremap <leader>gf :<C-u>Grepf<space>
nnoremap <leader>b  :<C-u>Buffers<CR>
nnoremap <C-f>      :<C-u>Files<CR>
" TODO: filter out stuff that matches wildignore e.g. .git/index, .git/COMMIT_EDITMSG
nnoremap <leader>hh :<C-u>History<CR>
nnoremap <leader><C-t> :Tags ^<C-r><C-w>\  <CR>
nnoremap <leader>fl :Folds<CR>

command! -nargs=? Grep  call Ripgrep(<q-args>)
command! -nargs=? Grepf call RipgrepFly(<q-args>)
command! -nargs=? -complete=dir Files call Files(<q-args>)
" allow search on the full tag info, excluding the appended tagfile name
" TODO: shift up/down not mapped to preview scroll
command! -nargs=* Tags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3..}", 'options': ['-d', '\t', '--nth', '..-2'] }))

augroup fzf-custom | au!
    if has('nvim')
        au FileType fzf if (g:gui_running || &termguicolors) | setlocal winblend=17 | endif
    endif
    au ColorScheme * call s:fzf_color()
    au VimEnter * call s:fzf_color()
augroup END

" TODO option to pass --no-ignore to rg and fd
func! FzfOpts(arg, spec)
    " TODO: ask the directory to run (double 3), starting from %:p:h
    let l:opts = string(a:arg)
    " Preview on right if ¬fullscreen & wide
    " fullscreen
    if l:opts =~ '2'
        let a:spec['window'] = { 'width': 1, 'height': 1, 'yoffset': 1, 'border': 'top' }
        let l:preview_window = 'up'
    else
        let l:preview_window = IsVimWide() ? 'right' : 'up'
    endif
    " from project root
    if l:opts =~ '3'
        " TODO: don't use this function and lazy-load asyncrun
        let a:spec['dir'] = asyncrun#get_root("%")
    endif
    return fzf#vim#with_preview(a:spec, l:preview_window)
endfunc
func! RgInput(raw)
    if g:search_mode ==# 'n'
        return substitute(a:raw, '\v\\[<>]','','g')
    elseif g:search_mode ==# 'v'
        return escape(a:raw, '+|?-(){}') " not escaped by VisualStar
    else " can convert most of strict very magic to riggrep regex, otherwise, DIY
        if a:raw[0:1] !=# '\v'
            return substitute(a:raw, '\v(\\V|\\[<>])','','g')
        endif
        return substitute(a:raw[2:], '\v\\([~/])', '\1', 'g')
    endif
endfunc
function! s:rg_cmd_base() abort
    " NOTE: -U (multiline): \s includes \n.
    let colors = &background ==# 'dark' ? '--colors path:fg:218 --colors match:fg:116 ' : '--colors path:fg:125 --colors match:fg:67 '
    return "rg --hidden --glob '!**/.git/**' --column --line-number --no-heading --smart-case --color=always " . colors
endfunction
func! Ripgrep(query)
    let cmd = s:rg_cmd_base() . shellescape(a:query)
    let spec = FzfOpts(v:count, {'options': ['--info=inline', '--layout=reverse-list']})
    call fzf#vim#grep(cmd, 1, spec)
endfunc
func! RipgrepFly(query)
    let command_fmt = s:rg_cmd_base() . '-- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = FzfOpts(v:count, {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--info=inline', '--layout=reverse-list']})
    call fzf#vim#grep(initial_command, 1, spec)
endfunc
func! Files(query)
    let spec = FzfOpts(v:count, {})
    if empty(a:query) && !empty(get(spec, 'dir', ''))
        let l:query = spec['dir']
        unlet spec['dir']
        let spec['options'] = ['--prompt', fnamemodify(l:query, ':~:.') . '/']
    else
        let l:query = a:query
    endif
    call fzf#vim#files(l:query, fzf#vim#with_preview(spec, 'right'))
endfunc
function! s:fzf_color() abort
    if match($FZF_DEFAULT_OPTS, '--color') >= 0
        let $FZF_DEFAULT_OPTS = substitute($FZF_DEFAULT_OPTS, '--color\%(=\|\s\+\)\zs\w\+', &background, 0)
    else
        let $FZF_DEFAULT_OPTS .= ' --color=' . &background
    endif
endfunction
" }}}

" Motion, insert mode, ... {{{
" just set nowrap instead of explicit linewise ops
nnoremap <expr> j                     v:count ? 'j' : 'gj'
nnoremap <expr> k                     v:count ? 'k' : 'gk'
nnoremap <expr> J                     v:count ? 'j' : 'gj'
nnoremap <expr> K                     v:count ? 'k' : 'gk'
xnoremap <expr> j mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
xnoremap <expr> k mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
onoremap <expr> j mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
onoremap <expr> k mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
xnoremap <expr> J mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
xnoremap <expr> K mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
onoremap <expr> J mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
onoremap <expr> K mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
Noremap <leader>J J
Noremap <expr> H v:count ? 'H' : 'h'
Noremap <expr> L v:count ? 'L' : 'l'

Noremap <M-0> ^w

let g:sneak#s_next = 0
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
Map f <Plug>Sneak_f
Map F <Plug>Sneak_F
Map t <Plug>Sneak_t
Map T <Plug>Sneak_T
Map <M-;> <Plug>Sneak_,
" NOTE: my fork
let g:sneak#alias = {
            \ 'a': '[aα∀]', 'b': '[bβ]', 'c': '[cξ]', 'd': '[dδ]', 'e': '[eε∃]', 'f': '[fφ]', 'g': '[gγ]', 'h': '[hθ]', 'i': '[iι]', 'j': '[jϊ]', 'k': '[kκ]', 'l': '[lλ]', 'm': '[mμ]', 'n': '[nν]', 'o': '[oο]', 'p': '[pπ]', 'q': '[qψ]', 'r': '[rρ]', 's': '[sσ]', 't': '[tτ]', 'u': '[uυ]', 'v': '[vϋ𝓥]', 'w': '[wω]', 'x': '[xχ]', 'y': '[yη]', 'z': '[zζ]',
            \ '*': '[*∗]',
            \ '/': '[/∧]', '\': '[\∨]',
            \ '<': '[<≼]',
            \ '>': '[>↦→⇒⇝]',
            \ '[': '[[⌜⎡⊑⊓]', ']': '[\]⌝⎤⊒⊔]',
            \}

" TODO: (special char -> non-blank, non-keyword), user-defined (paren -> pair?)
" s-word: (a keyword | repetition of non-paren special char | a paren | whitespace)
let g:sword = '\v(\k+|([^[:alnum:]_[:blank:](){}[\]<>''"`$])\2*|[(){}[\]<>''"`$]|\s+)'
"                     %(\k|[()[\]{}<>[:blank:]$])@!(.)\1*
" NOTE: \v(<|>) works well for word chars, but not for non-word chars 𝓥s
" '\v(<|>|[^[:alnum:]_[:blank:]])', '\k\+\|[[:punct:]]\|\s\+'

" Jump past a sword. Assumes `set whichwrap+=]` for i_<Right>
inoremap <silent><C-j> <C-r>=SwordJumpRight()<CR><Right>
inoremap <silent><C-k> <C-r>=SwordJumpLeft()<CR>
func! SwordJumpRight()
    if col('.') !=  col('$')
        call search(g:sword, 'ceW')
    endif
    return ''
endfunc
func! SwordJumpLeft()
    call search(col('.') != 1 ? g:sword : '\v$', 'bW')
    return ''
endfunc
" <C-b> <C-e>
cnoremap <C-j> <S-Right>
cnoremap <C-k> <S-Left>

inoremap <expr> <C-u> match(getline('.'), '\S') >= 0 ? '<C-g>u<C-u>' : '<C-u>'
" Delete a single character of other non-blank chars
inoremap <silent><expr><C-w>  FineGrainedICtrlW(0)
" Like above, but first consume whitespace
inoremap <silent><expr><M-BS> FineGrainedICtrlW(1)
func! FineGrainedICtrlW(finer)
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
        if l:idx == l:len || (!a:finer && l:chars[-(l:idx + 1)] =~ '\k')
            return "\<C-w>"
        endif
        let l:sts = &softtabstop
        setlocal softtabstop=0
        return repeat("\<BS>", l:idx)
                    \ . "\<C-R>=execute('setl sts=".l:sts."')\<CR>"
                    \ . (a:finer ? "" : "\<C-R>=pear_tree#insert_mode#Backspace()\<CR>")
    elseif l:chars[-1] !~ '\k'
        return pear_tree#insert_mode#Backspace()
    else
        return "\<C-w>"
    endif
endfunc
" }}}

" etc mappings {{{
nnoremap <silent><leader><CR> :let v:searchforward=1\|nohlsearch<CR>
nnoremap <silent><leader><C-L> :diffupdate<CR><C-L>
nnoremap <silent><leader>sfs :syntax sync fromstart<CR><C-L>
nnoremap <leader>ss :setlocal spell! spell?<CR>
nnoremap <leader>sc :if empty(&spc) \| setl spc< spc? \| else \| setl spc= spc? \| endif<CR>
nnoremap <leader>sp :set paste! paste?<CR>
nnoremap <leader>sw :setlocal wrap! wrap?<CR>
nnoremap <leader>ic :set ignorecase! smartcase! ignorecase?<CR>

Noremap <leader>dp :diffput<CR>
Noremap <leader>do :diffget<CR>

" clipboard.
inoremap <C-v> <C-g>u<C-r><C-o>+
Noremap <M-c> "+y
nnoremap <silent> yY :let _view = winsaveview() \| exe 'keepjumps keepmarks norm ggVG"+y' \| call winrestview(_view) \| unlet _view<cr>

" buf/filename
nnoremap <leader>fn 2<C-g>

noremap <F1> <Esc>
inoremap <F1> <Esc>
nmap     <C-q> <Esc>
cnoremap <C-q> <C-c>
inoremap <C-q> <Esc>
vnoremap <C-q> <Esc>
onoremap <C-q> <Esc>
noremap! <C-M-q> <C-q>

cnoremap <M-p> <Up>
cnoremap <M-n> <Down>

" disable annoying q and Q (use c_CTRL-F and gQ) and streamline record/execute
" TODO: q quits hit-enter and *starts recording* unlike q of more-prompt → open a vim issue
Noremap q: :
Noremap q <nop>
Noremap <M-q> q
Noremap <expr> qq empty(reg_recording()) ? 'qq' : 'q'
Noremap Q @q

" v_u mistake is  hard to notice. Use gu instead (works for visual mode too).
xnoremap u <nop>

" delete without clearing regs
Noremap x "_x

nnoremap gV `[v`]

" repetitive pastes using designated register @p
Noremap <M-y> "py
Noremap <M-p> "pp
Noremap <M-P> "pP

nnoremap Y y$
onoremap <silent> ge :execute "normal! " . v:count1 . "ge<space>"<cr>
nnoremap <silent> & :&&<cr>
xnoremap <silent> & :&&<cr>

" set nrformats+=alpha
Noremap  <M-+> <C-a>
xnoremap <M-+> g<C-a>
Noremap  <M--> <C-x>
xnoremap <M--> g<C-x>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

command! -count Wfh setlocal winfixheight | if <count> | exe "normal! z".<count>."\<CR>" | endif

nnoremap <leader>w :<C-u>up<CR>
nnoremap ZAQ :<C-u>qa!<CR>
cnoreabbrev <expr> W <SID>cabbrev('W', 'w')
cnoreabbrev <expr> Q <SID>cabbrev('Q', 'q')

cnoreabbrev <expr> ff  <SID>cabbrev('ff',  "find**/<Left><Left><Left>")
cnoreabbrev <expr> sff <SID>cabbrev('sff', "sf**/<Left><Left><Left>")
cnoreabbrev <expr> vsb <SID>cabbrev('vsb', 'vert sb')
cnoreabbrev <expr> vsf <SID>cabbrev('vsf', "vert sf**/<Left><Left><Left>")
cnoreabbrev <expr> tsb <SID>cabbrev('tsb', 'tab sb')
cnoreabbrev <expr> tsf <SID>cabbrev('tsf', "tab sf**/<Left><Left><Left>")

nnoremap <leader>cx :tabclose<CR>
nnoremap <leader>td :tab split<CR>
nnoremap <leader>tt :tabedit<CR>
nnoremap <leader>fe :e!<CR>

cnoremap <C-r><C-v> <C-r>=join(tomtomjhj#util#visual_selection_lines(), ' ')<CR>
inoremap <C-r><C-v> <C-r>=join(tomtomjhj#util#visual_selection_lines(), ' ')<CR>

Noremap <silent> [x <Cmd>call <SID>jump_git_conflict(1)<CR>
Noremap <silent> ]x <Cmd>call <SID>jump_git_conflict(0)<CR>
function! s:jump_git_conflict(back) abort
    let conflict_marker_pat = '\(' . '^<<<<<<< \@=' . '\|' . '^||||||| .*$' . '\|' . '^=======$' . '\|' . '^>>>>>>> \@=' . '\)'
    return search(conflict_marker_pat, a:back ? 'bsW' : 'sW')
endfunction
" }}}

" pairs {{{
let g:matchup_override_vimtex = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_matchparen_deferred = 1
let g:pear_tree_map_special_keys = 0
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_timeout = 23
let g:pear_tree_repeatable_expand = 0
" assumes nosmartindent
imap <expr> <CR> match(getline('.'), '\k') >= 0 ? "\<C-G>u\<Plug>(PearTreeExpand)" : "\<Plug>(PearTreeExpand)"
imap <BS> <Plug>(PearTreeBackspace)

" NOTE
" - https://github.com/machakann/vim-sandwich/wiki/Magic-characters
" - Sandwich doesn't have insert mode mapping https://github.com/machakann/vim-sandwich/issues/100 → use snippets
" - In tex, first sandwich very slow? slow when texlab hasn't initilalized yet?

augroup MyTargets | au!
    " NOTE: can't expand by repeating → use builtin for simple objects
    " NOTE: can't select **text <newline> text** using i*
    " https://github.com/wellle/targets.vim/issues/175
    " Use 'a'rguments, separators only
    autocmd User targets#mappings#user call targets#mappings#extend({
    \ '(': {}, ')': {}, '{': {}, '}': {}, 'B': {}, '[': {}, ']': {}, '<': {}, '>': {}, '"': {}, "'": {}, '`': {}, 't': {}, 'b': {}, 'q': {},
    \ })
augroup END
" https://github.com/wellle/targets.vim/issues/233
" This should be called after setting up the autocmd
call targets#sources#newFactories('')

let g:operator#sandwich#highlight_duration = 30
runtime macros/sandwich/keymap/surround.vim
" surround with whitespace
let g:sandwich#recipes += [
      \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
      \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
      \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
      \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
      \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
      \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
      \ ]
" ML-style comment
" NOTE: including \s* in the pattern breaks many stuff, e.g.
" (*
" (*  *)
" *)
let g:sandwich#recipes += [
      \   {'buns': ['(* ', ' *)'], 'nesting': 1, 'motionwise': ['char', 'block'], 'kind': ['add'], 'action': ['add'], 'input': ['m']},
      \   {'buns': ['(*', '*)'], 'nesting': 1, 'motionwise': ['line'], 'autoindent': 0, 'kind': ['add'], 'action': ['add'], 'input': ['m']},
      \   {'buns': ['\v\(\*\_s', '\v(^|\s)\*\)'], 'nesting': 1, 'regex': 1, 'kind': ['delete', 'textobj'], 'action': ['delete'], 'input': ['m']},
      \ ]
omap ib <Plug>(textobj-sandwich-auto-i)
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap ab <Plug>(textobj-sandwich-auto-a)
" omap is <Plug>(textobj-sandwich-query-i)
" xmap is <Plug>(textobj-sandwich-query-i)
" omap as <Plug>(textobj-sandwich-query-a)
" xmap as <Plug>(textobj-sandwich-query-a)
" }}}

" shell, terminal {{{
if has('nvim')
    tnoremap <M-[> <C-\><C-n>
    tnoremap <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

Noremap <leader>R :AsyncRun<space>
nnoremap <leader>ST :AsyncStop\|let g:asyncrun_status = ''<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -auto=make -program=make @ <args>
nnoremap <leader>M :Make<space>
command! -bang -bar -nargs=* -complete=customlist,fugitive#PushComplete Gpush  execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* -complete=customlist,fugitive#FetchComplete Gfetch execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git fetch' <q-args>

let g:neoterm_default_mod = 'rightbelow'
let g:neoterm_automap_keys = '<leader>T'
" }}}

" quickfix, loclist, ... {{{
" TODO: manually adding lines to qf?
let g:qf_window_bottom = 0
let g:qf_loclist_window_bottom = 0
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0
let g:qf_max_height = 12
let g:qf_auto_quit = 0

packadd cfilter
command! -bar CW
            \ if IsWinWide() |
            \   exec 'vert copen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p |
            \ else |
            \   belowright copen 12 | winc p |
            \ endif
command! -bar LW
            \ if IsWinWide() |
            \   exec 'vert lopen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p |
            \ else |
            \   belowright lopen 12 | winc p |
            \ endif
nmap <silent><leader>cw :CW<CR>
nmap <silent><leader>lw :LW<CR>
nmap <silent><leader>x  :pc\|ccl\|lcl<CR>
nmap <silent>]q <Plug>(qf_qf_next)
nmap <silent>[q <Plug>(qf_qf_previous)
nmap <silent>]l <Plug>(qf_loc_next)
nmap <silent>[l <Plug>(qf_loc_previous)

function s:qf() abort
    nmap <buffer> <Left>  <Plug>(qf_older)
    nmap <buffer> <Right> <Plug>(qf_newer)
    nmap <buffer> { <Plug>(qf_previous_file)
    nmap <buffer> } <Plug>(qf_next_file)
endfunction

augroup qf-custom | au!
    au FileType qf call s:qf()
augroup END
" }}}

" Explorers {{{
let g:loaded_netrwPlugin = 1
function! GXBrowse(url)
    let redir = '>&/dev/null'
    if exists('g:netrw_browsex_viewer')
        let viewer = g:netrw_browsex_viewer
    elseif has('unix') && executable('xdg-open')
        let viewer = 'xdg-open'
    elseif has('macunix') && executable('open')
        let viewer = 'open'
    elseif has('win64') || has('win32')
        let viewer = 'start'
        let redir = '>null'
    else
        return
    endif
    execute 'silent! !' . viewer . ' ' . shellescape(a:url, 1) . redir
    redraw!
endfunction
" based on https://gist.github.com/gruber/249502
let s:url_regex = '\c\<\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)'
function! CursorURL() abort
    return matchstr(expand('<cWORD>'), s:url_regex)
endfunction
nnoremap <silent> gx :call GXBrowse(CursorURL())<cr>

" NOTE: :Fern that isn't drawer does not reuse "authority". Leaves too many garbage buffers.
let g:fern#default_exclude = '\v(\.glob|\.vo[sk]?|\.o)$'
nnoremap <leader>nn <Cmd>Fern . -drawer -toggle<CR>
nnoremap <leader>nf <Cmd>Fern . -drawer -reveal=%<CR>
" <f-args>, -bar
nnoremap <leader>-  <Cmd>exe 'Fern' escape(BufDir(), ' \<Bar>') '-reveal=%'<CR>
nnoremap <C-w>es    <Cmd>exe 'Fern' escape(BufDir(), ' \<Bar>') '-reveal=% -opener=split'<CR>
nnoremap <C-w>ev    <Cmd>exe 'Fern' escape(BufDir(), ' \<Bar>') '-reveal=% -opener=vsplit'<CR>
nnoremap <C-w>et    <Cmd>exe 'Fern' escape(BufDir(), ' \<Bar>') '-reveal=% -opener=tabedit'<CR>
nnoremap <leader>cd :cd <Plug>BufDir/
nnoremap <leader>e  :e! <Plug>BufDir/
nnoremap <leader>te :tabedit <Plug>BufDir/
function! s:init_fern() abort
    let helper = fern#helper#new()
    if helper.sync.is_drawer()
        setlocal nonumber foldcolumn=0
    else
        setlocal signcolumn=number foldcolumn=0
    endif
    " must ignore the error
    silent! nunmap <buffer> <C-h>
    silent! nunmap <buffer> <C-j>
    silent! nunmap <buffer> <C-k>
    silent! nunmap <buffer> <C-l>
    silent! nunmap <buffer> <BS>
    silent! nunmap <buffer> s
    silent! nunmap <buffer> N
    nmap <buffer> - <Plug>(fern-action-leave)
    Map <buffer> x <Plug>(fern-action-mark)
    nmap <buffer> gx <Plug>(fern-action-open:system)
    nmap <buffer> <C-n> <Plug>(fern-action-new-file)
    " or use the 'ex' action
    cmap <buffer> <C-r><C-p> <Plug>BufDir
    " toggle both hidden and exclude
    nmap <buffer> <expr> ! '<Plug>(fern-action-exclude=)<C-u>' . (!b:fern.hidden ? '' : g:fern#default_exclude) . '<CR>' . '<Plug>(fern-action-hidden:toggle)'
endfunction

augroup fern-custom | au!
  autocmd FileType fern call s:init_fern()
augroup END

noremap! <Plug>BufDir <C-r><C-r>=fnameescape(BufDir())<CR>
function! BufDir(...) abort
    let b = a:0 ? a:1 : bufnr('')
    let bname = bufname(b)
    let ft = getbufvar(b, '&filetype')
    if ft is# 'fugitive'
        return fnamemodify(FugitiveGitDir(b), ':h')
    elseif bname =~# '^fugitive://'
        return fnamemodify(FugitiveReal(bname), ':h')
    elseif bname =~# '^fern://'
        return getbufvar(b, 'fern').root._path
    else
        return fnamemodify(bname, ':p:h')
    endif
endfunction
" }}}

" Git. See also plugin/git.vim {{{
augroup git-custom | au!
    au FileType diff
        \ nnoremap <silent><buffer>zM :setlocal foldmethod=expr foldexpr=GitDiffFoldExpr(v:lnum)\|unmap <lt>buffer>zM<CR>zM
    au FileType git,fugitive,gitcommit
        \ nnoremap <silent><buffer>zM :setlocal foldmethod=expr foldexpr=GitDiffFoldExpr(v:lnum)\|unmap <lt>buffer>zM<CR>zM
        \|silent! unmap <buffer> *
        \|Map <buffer> <localleader>* <Plug>fugitive:*
    au User FugitiveObject,FugitiveIndex
        \ silent! unmap <buffer> *
        \|Map <buffer> <localleader>* <Plug>fugitive:*
    " TODO: diff mapping for gitcommit
augroup END

" See also:
" - https://github.com/sgeb/vim-diff-fold/blob/master/ftplugin/diff.vim
" - https://vim.fandom.com/wiki/Folding_for_diff_files
function! GitDiffFoldExpr(lnum)
    let line = getline(a:lnum)
    if line =~# '^diff'
        return '>1'
    elseif line =~# '^@@'
        return '>2'
    else
        return '='
    endif
endfunction
" }}}

" firenvim {{{
" chrome://extensions/shortcuts -> this may break chrome keymaps like <C-w>
if exists('g:started_by_firenvim')
    let g:firenvim_config = {
                \ 'globalSettings': {
                \     'alt': 'all',
                \  },
                \ 'localSettings': {
                \     '.*': {
                \         'cmdline': 'neovim',
                \         'priority': 0,
                \         'selector': 'textarea',
                \         'takeover': 'never',
                \     },
                \ }
                \ }
    " inoremap <M-CR> <Esc>:w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa
    set laststatus=0
else
    let g:firenvim_loaded = 1
endif
" }}}

" textobj {{{
call textobj#user#plugin('tomtomjhj', {
\   'url_or_filename': { 'pattern': '\('.s:url_regex.'\|\f\+\)', 'select': ['au', 'iu'] },
\   'indented_paragraph': {
\     'select-a-function': 'indented_paragraph#SelectA',
\     'select-a': 'aP',
\     'select-i-function': 'indented_paragraph#SelectI',
\     'select-i': 'iP',
\     'move-n-function': 'indented_paragraph#MoveN',
\     'move-n': 'g)',
\     'move-p-function': 'indented_paragraph#MoveP',
\     'move-p': 'g(',
\    }})
" }}}

" comments {{{
imap <M-/> <C-G>u<Plug>CommentaryInsert
" }}}

" etc plugins {{{
let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']

" undotree
let g:undotree_WindowLayout = 4
nnoremap U :UndotreeToggle<CR>

" sentencer
let g:sentencer_filetypes = []
let g:sentencer_textwidth = 79 " formatexpr doesn't work like built-in gq for textwidth=0
let g:sentencer_ignore = ['\<i.e', '\<e.g', '\<vs', '\<Dr', '\<Mr', '\<Mrs', '\<Ms', '\<et al']

" vim-mark
let g:mwMaxMatchPriority = -2
let g:mw_no_mappings = 1
nmap m* <Plug>MarkSet
xmap m* <Plug>MarkSet
nmap m/ <Plug>MarkSearchAnyNext
nmap m? <Plug>MarkSearchAnyPrev
nmap m<BS> <Plug>MarkToggle
" TODO: stuff using api-highlights, like codepainter
" }}}

" etc util {{{
" helpers {{{
" Expands cmdline-special
function! s:expand_cmdline_special(txt) abort
    return substitute(a:txt, '\v\\@<!(\%|#%(\<?\d+|#)?)', '\=expand(submatch(1))', 'g')
endfunction
function! s:cabbrev(lhs, rhs) abort
    return (getcmdtype() == ':' && getcmdline() ==# a:lhs) ? a:rhs : a:lhs
endfunction
" }}}

func! ShowSyntaxInfo()
    if s:nvim_latest_stable
        TSHighlightCapturesUnderCursor
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') '->' synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunc
nmap <silent><leader>st :<C-u>call ShowSyntaxInfo()<CR>
func! InSynStack(pat, ...)
    let synstack = a:0 ? a:1 : synstack(line('.'), col('.'))
    for i in synstack
        if synIDattr(i, 'name') =~# a:pat
            return 1
        endif
    endfor
    return 0
endfunc
func! IsWinWide()
    return winwidth(0) > 170
endfunc
func! IsVimWide()
    return &columns > 170
endfunc
function! Text2Magic(text)
    return escape(a:text, '\.*$^~[]')
endfunction
function! Text2VeryMagic(str) abort
    return escape(a:str, '!#$%&()*+,-./:;<=>?@[\]^{|}~')
endfunction

function! TempBuf(mods, ...) abort
    exe a:mods 'new'
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile nomodeline
    if a:0
        call setline(1, a:1)
    endif
endfunction
function! Execute(cmd, mods) abort
    call TempBuf(a:mods, split(execute(a:cmd), "\n"))
endfunction
function! WriteC(cmd, mods) range abort
    call TempBuf(a:mods, systemlist(s:expand_cmdline_special(a:cmd), getline(a:firstline, a:lastline)))
endfunction
function! Bang(cmd, mods) abort
    call TempBuf(a:mods, systemlist(s:expand_cmdline_special(a:cmd)))
endfunction
command! -nargs=* -complete=command Execute call Execute(<q-args>, '<mods>')
command! -nargs=* -range=% -complete=shellcmd WC <line1>,<line2>call WriteC(<q-args>, '<mods>')
command! -nargs=* -complete=shellcmd Bang call Bang(<q-args>, '<mods>')

command! -range=% TrimWhitespace
            \ let _view = winsaveview()
            \|keeppatterns keepjumps <line1>,<line2>substitute/\s\+$//e
            \|call winrestview(_view)
            \|unlet _view

command! -range=% Unpdf
            \ let _view = winsaveview()
            \|keeppatterns keepjumps <line1>,<line2>substitute/[“”łž]/"/ge
            \|keeppatterns keepjumps <line1>,<line2>substitute/[‘’]/'/ge
            \|keeppatterns keepjumps <line1>,<line2>substitute/\w\zs-\n//ge
            \|call winrestview(_view)
            \|unlet _view

" :substitute using a dict, where key == submatch (like VisualStar)
function! SubstituteDict(dict) range
    exe a:firstline . ',' . a:lastline . 'substitute'
                \ . '/\C\%(' . join(map(keys(a:dict), 'Text2Magic(v:val)'), '\|'). '\)'
                \ . '/\=a:dict[submatch(0)]/ge'
endfunction
command! -range=% -nargs=1 SubstituteDict :<line1>,<line2>call SubstituteDict(<args>)

command! -nargs=+ -bang AddWildignore call AddWildignore([<f-args>], <bang>0)
function! AddWildignore(wigs, is_dir) abort
    if a:is_dir
        let g:wildignore_dirs += a:wigs
        let globs = map(a:wigs, 'v:val.",".v:val."/,**/".v:val."/*"')
    else
        let g:wildignore_files += a:wigs
        let globs = a:wigs
    endif
    exe 'set wildignore+='.join(globs, ',')
endfunction
if !exists('g:wildignore_files')
    let [g:wildignore_files, g:wildignore_dirs] = [[], []]
    call AddWildignore(s:wildignore_files, 0)
    call AddWildignore(s:wildignore_dirs, 1)
endif

command! -range=% ZulipMarkdown
            \ keeppatterns keepjumps <line1>,<line2>substitute/^    \ze[-+*]\s/  /e
            \|keeppatterns keepjumps <line1>,<line2>substitute/^        \ze[-+*]\s/    /e
            \|keeppatterns keepjumps <line1>,<line2>substitute/^            \ze[-+*]\s/      /e

if !has('nvim')
    command! -nargs=+ -complete=shellcmd Man delcommand Man | runtime ftplugin/man.vim | if winwidth(0) > 170 | exe 'vert Man' <q-args> | else | exe 'Man' <q-args> | endif
    command! SW w !sudo tee % > /dev/null
endif

command! Profile profile start profile.log | profile func * | profile file *
" }}}
