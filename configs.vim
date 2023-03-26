" vim: set foldmethod=marker foldlevel=0:

let s:nvim_latest_stable = has('nvim-0.8')
let g:ide_client = get(g:, 'ide_client', s:nvim_latest_stable ? 'nvim' : 'coc')

if !has('nvim')
    let g:loaded_getscriptPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_logiPat = 1
endif
let g:loaded_spellfile_plugin = 1

" NOTE: post-update hook doesn't work on nvim-0.6. https://github.com/neovim/neovim/issues/18822
" Workaround: f1d32549e4a4657674fd0645185bb8ef730c018d
" Plug {{{
if has('vim_starting')
call plug#begin('~/.vim/plugged')

" appearance
Plug 'tomtomjhj/taiga.vim'
Plug 'tomtomjhj/quite.vim'

" editing
Plug 'tomtomjhj/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-repeat'
Plug 'tomtomjhj/pear-tree'
Plug 'andymass/vim-matchup' " i%, a%, ]%, z%, g% TODO: % that seeks backward https://github.com/andymass/vim-matchup/issues/49#issuecomment-470933348
Plug 'wellle/targets.vim' " multi (e.g. ib, iq), separator, argument
Plug 'urxvtcd/vim-indent-object'
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
Plug 'tomtomjhj/conflict-marker.vim'
Plug 'tpope/vim-rhubarb'
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': has('unix') ? './install --all' : { -> fzf#install() } }
" TODO: :Buffers multiple select makes sense for :tabe, :sp, ...
" Make sth similar to that for small.vim
" See also https://github.com/junegunn/fzf.vim/pull/1239
Plug 'junegunn/fzf.vim'
if has('nvim')
    " TODO: Replace lspfuzzy with fzf-lua? Override vim.lsp.handlers?
    Plug 'ibhagwan/fzf-lua'
endif
Plug 'roosta/fzf-folds.vim'
" TODO: expr fold (e.g. markdown) → Gdiffsplit → close diff → nofoldenable with residual diff fold when enabled.
" :diffoff disables fold if fdm was manual (FastFold sets fdm=manual).
" https://github.com/vim/vim/blob/3ea8a1b1296af5b0c6a163ab995aa16d49ac5f10/src/diff.c#L1591-L1595
Plug 'Konfekt/FastFold'
Plug 'romainl/vim-qf'
Plug 'markonm/traces.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
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
    Plug 'L3MON4D3/LuaSnip', { 'on': [] }
    Plug 'saadparwaiz1/cmp_luasnip', { 'on': [] }
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'ojroques/nvim-lspfuzzy'
    Plug 'folke/neodev.nvim'
    Plug 'simrat39/rust-tools.nvim'
    Plug 'p00f/clangd_extensions.nvim'
    Plug 'vigoux/ltex-ls.nvim'
    Plug 'tomtomjhj/coq-lsp.nvim'
endif
Plug 'rafamadriz/friendly-snippets'
Plug 'tomtomjhj/tpope-vim-markdown'
Plug 'tomtomjhj/vim-markdown'
let g:pandoc#filetypes#pandoc_markdown = 0 | Plug 'vim-pandoc/vim-pandoc'
Plug 'tomtomjhj/vim-pandoc-syntax'
Plug 'tomtomjhj/vim-rust-syntax-ext'| Plug 'rust-lang/rust.vim'
Plug 'ocaml/vim-ocaml'
Plug 'neovimhaskell/haskell-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
Plug 'tomtomjhj/Coqtail'
" Plug 'puremourning/vimspector' | let g:vimspector_enable_mappings = 'HUMAN'
Plug 'rhysd/vim-llvm'
Plug 'vim-python/python-syntax'
" Plug 'rhysd/vim-grammarous', { 'for': ['markdown', 'tex'] } | let g:grammarous#use_location_list = 1

" etc etc
if has('nvim')
    Plug 'nvim-lua/plenary.nvim', { 'do': 'rm -rf plugin' }
endif
if has('nvim') && !has('nvim-0.8')
    Plug 'antoinemadec/FixCursorHold.nvim'
endif
if s:nvim_latest_stable
    " NOTE: when using local install of nvim, should reinstall
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    " Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'folke/paint.nvim'
    " NOTE: should do `rm ~/.cache/nvim/luacache*` after upgrading nvim
    Plug 'lewis6991/impatient.nvim'
    Plug 'jbyuki/venn.nvim'
endif

" NOTE: This runs `filetype plugin indent on`, which registers au FileType.
" Custom au FileType should be registered after this.
call plug#end()
endif

if s:nvim_latest_stable
    lua require('impatient')
endif
" }}}

" Basic {{{
command! -nargs=1 Noremap exe 'nnoremap' <q-args> | exe 'xnoremap' <q-args> | exe 'onoremap' <q-args> 
command! -nargs=1 Map exe 'nmap' <q-args> | exe 'xmap' <q-args> | exe 'omap' <q-args>

if has('vim_starting')
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
set viminfo=!,'150,<50,s30,h,r/tmp,r/run,rterm://,rfugitive://,rfern://,rman://,rtemp://
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
if has('nvim-0.9')
    " NOTE: this makes `dp` finer-grained than needed
    set diffopt+=linematch:60
endif
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
    if has('nvim-0.5')
        au TextYankPost * silent! lua vim.highlight.on_yank()
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

    command! -nargs=? Font call s:SetFont(<q-args>)
    function! s:SetFont(font) abort
        if !has('nvim') && has('gui_gtk2')
            let &guifont = substitute(a:font, ':h', ' ', '')
        elseif exists('g:GuiLoaded') " nvim-qt: suppress warnings like "reports bad fixed pitch metrics"
            call GuiFont(a:font, 1)
        else
            let &guifont = a:font
        endif
    endfunction

    nnoremap <C--> <Cmd>FontSize -v:count1<CR>
    if !has('nvim')
        nnoremap <C-_> <Cmd>FontSize -v:count1<CR>
    endif
    nnoremap <C-+> <Cmd>FontSize v:count1<CR>
    nnoremap <C-=> <Cmd>FontSize v:count1<CR>
    command! -nargs=1 FontSize call s:FontSize(<args>)
    function! s:FontSize(delta)
        let new_size = matchstr(&guifont, '\d\+') + a:delta
        let new_size = (new_size < 1) ? 1 : ((new_size > 100) ? 100 : new_size)
        call s:SetFont(substitute(&guifont, '\d\+', '\=new_size', ''))
        let &guifontwide = substitute(&guifontwide, '\d\+', '\=new_size', '')
    endfunction

    Font Iosevka Custom:h10
    if has('win32')
        let &guifontwide = 'Malgun Gothic:h10'
    endif

    if !has('nvim')
        set guioptions=i
        set guicursor+=a:blinkon0
    " NOTE: These variables are not set at startup. Should run at UIEnter.
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
    au UIEnter * ++once if has('nvim-0.9') ? has('gui_running') : v:event.chan | call s:SetupGUI() | endif
elseif has('gui_running')
    call s:SetupGUI()
endif
" }}}

" statusline & tabline {{{
set statusline=%!STLFunc()
set tabline=%!TALFunc()
let g:qf_disable_statusline = 1

let s:stl_mode_map = {'n' : 'N ', 'i' : 'I ', 'R' : 'R ', 'v' : 'V ', 'V' : 'VL', "\<C-v>": 'VB', 'c' : 'C ', 's' : 'S ', 'S' : 'SL', "\<C-s>": 'SB', 't': 'T '}
let s:stl_inactive_hl = [''                  , '%#STLInactive2#'   , '%#STLInactive3#'   , '%#STLInactive4#' , ]
let s:stl_active_hl = {
            \ 'n' :     ['%#STLModeNormal1#' , '%#STLModeNormal2#' , '%#STLModeNormal3#' , '%#STLModeNormal4#' , ],
            \ 'i' :     ['%#STLModeInsert1#' , '%#STLModeInsert2#' , '%#STLModeInsert3#' , '%#STLModeInsert4#' , ],
            \ 'R' :     ['%#STLModeReplace#' , '%#STLModeNormal2#' , '%#STLModeNormal3#' , '%#STLModeNormal4#' , ],
            \ 'v' :     ['%#STLModeVisual#'  , '%#STLModeNormal2#' , '%#STLModeNormal3#' , '%#STLModeNormal4#' , ],
            \ 'c' :     ['%#STLModeCmdline1#', '%#STLModeCmdline2#', '%#STLModeCmdline3#', '%#STLModeCmdline4#', ],
            \}
let s:stl_active_hl['V'] = s:stl_active_hl['v']
let s:stl_active_hl["\<C-v>"] = s:stl_active_hl['v']
let s:stl_active_hl['s'] = s:stl_active_hl['i']
let s:stl_active_hl['S'] = s:stl_active_hl['i']
let s:stl_active_hl["\<C-s>"] = s:stl_active_hl['i']
let s:stl_active_hl['t'] = s:stl_active_hl['i']

function! StatuslineHighlightInit()
    hi! STLModeNormal1  guifg=#005f00 ctermfg=22  guibg=#afdf00 ctermbg=148 gui=bold cterm=bold
    hi! STLModeNormal2  guifg=#ffffff ctermfg=231 guibg=#626262 ctermbg=241
    hi! STLModeNormal3  guifg=#bcbcbc ctermfg=250 guibg=#303030 ctermbg=236
    hi! STLModeNormal4  guifg=#585858 ctermfg=240 guibg=#d0d0d0 ctermbg=252
    hi! STLModeVisual   guifg=#870000 ctermfg=88  guibg=#ff8700 ctermbg=208 gui=bold cterm=bold
    hi! STLModeReplace  guifg=#ffffff ctermfg=231 guibg=#df0000 ctermbg=160 gui=bold cterm=bold
    hi! STLModeInsert1  guifg=#005f5f ctermfg=23  guibg=#ffffff ctermbg=231 gui=bold cterm=bold
    hi! STLModeInsert2  guifg=#ffffff ctermfg=231 guibg=#0087af ctermbg=31
    hi! STLModeInsert3  guifg=#afd7ff ctermfg=153 guibg=#005f87 ctermbg=24
    hi! STLModeInsert4  guifg=#005f5f ctermfg=23  guibg=#87dfff ctermbg=117
    hi! STLModeCmdline1 guifg=#262626 ctermfg=235 guibg=#ffffff ctermbg=231 gui=bold cterm=bold
    hi! STLModeCmdline2 guifg=#303030 ctermfg=236 guibg=#d0d0d0 ctermbg=252
    hi! STLModeCmdline3 guifg=#303030 ctermfg=236 guibg=#8a8a8a ctermbg=245
    hi! STLModeCmdline4 guifg=#585858 ctermfg=240 guibg=#ffffff ctermbg=231

    hi! STLInactive2  guifg=#8a8a8a ctermfg=245 guibg=#1c1c1c ctermbg=234
    hi! STLInactive3  guifg=#8a8a8a ctermfg=245 guibg=#303030 ctermbg=236
    hi! STLInactive4  guifg=#262626 ctermfg=235 guibg=#606060 ctermbg=241

    hi! STLError   guifg=#262626 ctermfg=235 guibg=#ff5f5f ctermbg=203
    hi! STLWarning guifg=#262626 ctermfg=235 guibg=#ffaf5f ctermbg=215
endfunction
call StatuslineHighlightInit()

function! STLFunc() abort
    if g:statusline_winid is# win_getid()
        let m = mode()[0]
        let [hl1, hl2, hl3, hl4] = s:stl_active_hl[m]
        return join([ hl1, ' ' . s:stl_mode_map[m] . ' ',
                    \ hl2, '%( %w%q%h%)%( %{STLTitle()}%) ',
                    \ hl3, '%( %{STLBufState()}%{exists("b:stl")?get(b:stl, "git", ""):""}%)', '%<', '%( %{BreadCrumb()}%)',
                    \ '%=',
                    \ hl3, '%(%{SearchCount()} %)',
                    \ '%#STLError#%( %{DiagnosticErrors()} %)',
                    \ '%#STLWarning#%( %{DiagnosticWarnings()} %)',
                    \ hl2, ' %3p%% ',
                    \ hl4, ' %3l:%-2c '
                    \], '')
    else
        let [hl1, hl2, hl3, hl4] = s:stl_inactive_hl
        return join([ hl2, '%( %w%q%h%)%( %{STLTitle()}%) ',
                    \ hl3, '%( @%{winnr()}%)%( %{STLBufState()}', '%<', '%{exists("b:stl")?get(b:stl, "git", ""):""}%)', '%( %{BreadCrumb()}%)',
                    \ '%=',
                    \ hl3, '%( %{DiagnosticErrors()} %)',
                    \ hl3, '%( %{DiagnosticWarnings()} %)',
                    \ hl2, ' %3p%% ',
                    \ hl4, ' %3l:%-2c '
                    \], '')
    endif
endfunction

function! TALFunc() abort
    let s = ''
    for i in range(tabpagenr('$'))
        let s .= (i + 1 == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
        let s .= '%' . (i + 1) . 'T ' . (i + 1) . ': %{TALLabel(' . (i + 1) . ')} '
    endfor
    let s .= '%T%#TabLineFill#'
    return s
endfunction

function! TALLabel(t) abort
    return STLTitle(win_getid(tabpagewinnr(a:t), a:t))
endfunction

function! STLTitle(...) abort
    let w = a:0 ? a:1 : win_getid()
    let b = winbufnr(w)
    let bt = getbufvar(b, '&buftype')
    let ft = getbufvar(b, '&filetype')
    let bname = bufname(b)
    " NOTE: bt=quickfix,help decides filetype
    if bt is# 'quickfix'
        " NOTE: getwininfo() to differentiate quickfix window and location window
        return gettabwinvar(win_id2tabwin(w)[0], w, 'quickfix_title', ':')
    elseif bt is# 'help'
        return fnamemodify(bname, ':t')
    elseif ft is# 'fzf'
        return 'fzf'
    elseif bt is# 'terminal'
        return has('nvim') ? '!' . matchstr(bname, 'term://\f\{-}//\d\+:\zs.*') : bname
    elseif ft is# 'fern'
        return pathshorten(fnamemodify(getbufvar(b, 'fern').root._path, ":~")) . '/'
    elseif bname =~# '^fugitive://'
        let [obj, gitdir] = FugitiveParse(bname)
        let matches = matchlist(obj, '\v(:\d?|\x+)(:\f*)?')
        return pathshorten(fnamemodify(gitdir, ":~:h")) . ' ' . matches[1][:9] . matches[2]
    elseif getbufvar(b, 'fugitive_type', '') is# 'temp'
        return pathshorten(fnamemodify(bname, ":~:.")) . ' :Git ' . join(FugitiveResult(bname)['args'], ' ')
    elseif ft is# 'gl'
        return ':GL' . join([''] + getbufvar(b, 'gl_args'), ' ')
    elseif bname =~# '^temp://'
        return matchstr(bname, '^temp://\zs.*')
    elseif empty(bname)
        return empty(bt) ? '[No Name]' : bt is# 'nofile' ? '[Scratch]' : '?'
    else
        return pathshorten(fnamemodify(simplify(bname), ":~:."))
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

" sets b:stl.git for real files that may be tracked by some git repo
function! UpdateGitStatus(buf) abort
    let bname = fnamemodify(bufname(a:buf), ':p')
    if !empty(getbufvar(a:buf, '&buftype')) || !filereadable(bname) || empty(FugitiveGitDir(a:buf)) | return | endif
    let status = ''
    let result = FugitiveExecute(['status', '--porcelain', bname], a:buf)
    if result.exit_status == 0
        let status = '[' . FugitiveHead(10, a:buf) . (empty(result.stdout[0]) ? '' : ':' . result.stdout[0][:1]) . ']'
    endif
    let stl = s:ensure_stl(a:buf)
    let stl.git = status
endfunction

function! s:ensure_stl(buf) abort
    if !has_key(getbufvar(a:buf, ''), 'stl')
        call setbufvar(a:buf, 'stl', {})
    endif
    return getbufvar(a:buf, 'stl')
endfunction

augroup Statusline | au!
    au BufReadPost,BufWritePost * call UpdateGitStatus(str2nr(expand('<abuf>')))
    " unloaded buffers will be refreshed on BufReadPost
    au User FugitiveChanged call map(getbufinfo({'bufloaded':1}), 'UpdateGitStatus(v:val.bufnr)')
    au ColorScheme * call StatuslineHighlightInit()
augroup END
" }}}

" ColorScheme {{{
command! Bg if &background ==# 'dark' | set background=light | else | set background=dark | endif

" set env vars controlling terminal app themes based on vim colorscheme
function! s:env_colors() abort
    if match($FZF_DEFAULT_OPTS, '--color') >= 0
        let $FZF_DEFAULT_OPTS = substitute($FZF_DEFAULT_OPTS, '--color\%(=\|\s\+\)\zs\w\+', &background, 0)
    else
        let $FZF_DEFAULT_OPTS .= ' --color=' . &background
    endif
    " features dark/light are defined in my .gitconfig
    if match($DELTA_FEATURES, '\<\(dark\|light\)\>') >= 0
        let $DELTA_FEATURES = substitute($DELTA_FEATURES, '\<\(dark\|light\)\>', &background, 0)
    else
        let $DELTA_FEATURES .= ' ' . &background
    endif
endfunction

augroup colors-custom | au!
    au ColorScheme * call s:env_colors()
augroup END

silent! set termguicolors
if $BACKGROUND =~# 'dark\|light'
    let &background = $BACKGROUND
endif
if !exists('g:colors_name')
    colorscheme quite
endif
" }}}

" Completion {{{
if g:ide_client == 'coc'
    let g:coc_snippet_prev = '<C-h>'
    let g:coc_snippet_next = '<C-l>'

    inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1): <SID>check_back_space() ? '<Tab>' : '<Cmd>call coc#start()<CR>'
    inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : <SID>check_back_space() ? '<C-h>' : '<Cmd>call coc#start()<CR>'
    inoremap <expr> <C-l> coc#expandableOrJumpable() ? '<Cmd>call coc#rpc#request("doKeymap", ["snippets-expand-jump",""])<CR>' : '<C-l>'

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

elseif g:ide_client == 'nvim'
    lua require'tomtomjhj/cmp'

    " lazy-load luasnip
    function! s:LoadLuaSnip() abort
        call plug#load('LuaSnip', 'cmp_luasnip')

        lua require("luasnip.loaders.from_vscode").lazy_load { paths = { "~/.vim/vsnip", "~/.vim/plugged/friendly-snippets" } }
        lua require("luasnip.loaders.from_lua").lazy_load { paths = "~/.vim/lsnip/" }
        lua require("luasnip").config.setup { store_selection_keys = "<C-L>" }

        " See cmp.lua for imap <C-l>
        inoremap <silent> <C-h> <Cmd>lua require('luasnip').jump(-1)<CR>
        snoremap <silent> <C-l> <Cmd>lua require('luasnip').jump(1)<CR>
        snoremap <silent> <C-h> <Cmd>lua require('luasnip').jump(-1)<CR>
    endfunction

    if has('vim_starting')
        au InsertEnter * ++once call s:LoadLuaSnip()
        xnoremap <silent> <C-l> <Cmd>call <SID>LoadLuaSnip()\|call feedkeys("<C-l>")<CR>
    endif
endif
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
let g:coc_global_extensions = ['coc-snippets', 'coc-vimlsp', 'coc-json']
let g:coc_quickfix_open_command = 'CW'
let g:coc_fzf_preview = 'up:66%'
" for https://github.com/valentjn/vscode-ltex/issues/425
let g:coc_filetype_map = {'tex': 'latex'}

nmap <leader>fm <Plug>(ale_fix)
nmap <M-,> <Plug>(ale_detail)<C-W>p
nmap ]d <Plug>(ale_next_wrap)
nmap [d <Plug>(ale_previous_wrap)
" }}}

" Languages {{{
if has('nvim-0.8')
    lua require('tomtomjhj/treesitter')
endif

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
    au FileType xml setlocal formatoptions-=r formatoptions-=o " very broken: <!--<CR> → <!--\n--> █
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
let g:termdebugger = 'rust-gdb'
" TODO: add completion in cargo command
let g:cargo_shell_command_runner = 'AsyncRun -post=CW'
" https://github.com/rust-lang/rust-clippy/issues/4612
command! -nargs=* Cclippy call cargo#cmd("+nightly clippy -Zunstable-options " . <q-args>)
command! -range=% PrettifyRustSymbol <line1>,<line2>SubstituteDict { '$SP$': '@', '$BP$': '*', '$RF$': '&', '$LT$': '<', '$GT$': '>', '$LP$': '(', '$RP$': ')', '$C$' : ',',  '$u20$': ' ', '$u5b$': '[', '$u5d$': ']', '$u7b$': '{', '$u7d$': '}', }
function! s:rust() abort
    setlocal path+=src
    " TODO fix 'spellcapcheck' for `//!` comments, also fix <leader>sc mapping
    " TODO: matchit handle < -> non-pair
    let b:pear_tree_pairs['|'] = {'closer': '|'}
    if g:ide_client == 'coc'
        command! -buffer ExpandMacro CocCommand rust-analyzer.expandMacro
    endif
    nnoremap <buffer><leader>C :AsyncRun -program=make -post=CW test --no-run<CR>
    xnoremap <buffer><leader>fm :RustFmtRange<CR>
    Noremap <silent><buffer> [[ <Cmd>call tomtomjhj#rust#section(1)<CR>
    Noremap <silent><buffer> ]] <Cmd>call tomtomjhj#rust#section(0)<CR>
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

" LaTeX {{{
let g:tex_flavor = 'latex'
let g:tex_noindent_env = '\v\w+.?'
let g:vimtex_fold_enabled = 1
let g:matchup_override_vimtex = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:vimtex_indent_on_ampersands = 0
let g:vimtex_toc_config = { 'show_help': 0 }
let g:vimtex_toc_config_matchers = {
            \ 'todo_notes': {
                \ 're' : g:vimtex#re#not_comment . '\\\w*%(todo|jaehwang)\w*%(\[[^]]*\])?\{\zs.*',
                \ 'prefilter_cmds': ['todo', 'jaehwang']}
            \}
let g:vimtex_syntax_nospell_comments = 1
let g:vimtex_text_obj_variant = 'vimtex' " I don't use those targets.vim features and its ic is buggy(?)
" NOTE: If inverse search doesn't work, check if source files are correctly recognized by vimtex.
function! s:tex() abort
    setlocal shiftwidth=2
    setlocal conceallevel=2
    setlocal foldlevel=99 " {[{[
    setlocal indentkeys-=] indentkeys-=} indentkeys-=\& indentkeys+=0],0}
    " https://github.com/tmsvg/pear-tree/pull/27
    let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
                \ '$$': {'closer': '$$'},
                \ '$': {'closer': '$'}
                \ }, 'keep')
    nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h").'/main.pdf'<CR>")<CR>
    nmap <buffer>        <leader>C <Cmd>update<CR><Plug>(vimtex-compile-ss)
    nmap <buffer>        <localleader>t <Cmd>call vimtex#fzf#run('ctli', g:fzf_layout)<CR>
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

    silent! call textobj#user#plugin('markdown', {
                \ 'code': {
                \    'select-a-function': 'tomtomjhj#markdown#FencedCodeBlocka',
                \    'select-a': '<buffer> ad',
                \    'select-i-function': 'tomtomjhj#markdown#FencedCodeBlocki',
                \    'select-i': '<buffer> id',
                \   },
                \ })
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
    " NOTE: `:[range]!pandoc -t commonmark_x` also works.
    nnoremap <buffer><silent>     <leader>tf :TableFormat<CR>
    nnoremap <buffer>             gO          <Cmd>Toc<CR>
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

    command! -buffer -bang Pandoc call tomtomjhj#markdown#RunPandoc(<bang>0)

    nnoremap <buffer><silent><leader>C <Cmd>Pandoc<CR>
    nnoremap <buffer><silent><leader>O <Cmd>Pandoc!<CR>
    nnoremap <buffer><silent><leader>oo <Cmd>call Zathura(expand('%:p:s?[.]\w*$?.pdf?'))<CR>
    nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    nnoremap <buffer>zM <Cmd>call pandoc#folding#Init()\|unmap <lt>buffer>zM<CR>zM
endfunction
function! Zathura(file)
    call jobstart(['zathura', a:file, '--fork'])
endfunction
" }}}

" ocaml {{{
let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'
let g:ocaml_highlight_operators = 1
function! s:ocaml() abort
    setlocal tabstop=2 shiftwidth=2
    setlocal comments=sr:(*,mb:*,ex:*)
    setlocal formatoptions=tjncqor
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
    " These trigger indent even if `+` is not the first character
    " 0--,0++,0<*><*>,0---,0+++,0<*><*><*>
    setlocal indentkeys=o,O,0=end,0=End,0=in,0=\|,0=Qed,0=Defined,0=Abort,0=Admitted,0},0),0-,0+,0<*>
    setlocal indentkeys+=!^F
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
    setlocal comments=:---,:--
    setlocal commentstring=--%s
endfunction
" }}}

let g:lisp_rainbow = 1
let g:is_posix = 1
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

let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-s': 'split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
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

" TODO: ++option for fd/rg. --no-ignore, ...
command! -nargs=? Grep  call Ripgrep(<q-args>)
command! -nargs=? Grepf call RipgrepFly(<q-args>)
command! -nargs=? -complete=dir Files call Files(<q-args>)
" allow search on the full tag info, excluding the appended tagfile name
" TODO: shift up/down not mapped to preview scroll
command! -nargs=* Tags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3..}", 'options': ['-d', '\t', '--nth', '..-2'] }))

augroup fzf-custom | au!
    if has('nvim')
        au FileType fzf if (g:gui_running || &termguicolors) && has_key(nvim_get_hl_by_name('Normal', v:true), 'background') | setlocal winblend=17 | endif
    endif
augroup END

func! FzfOpts(arg, spec)
    let l:opts = string(a:arg)
    " Preview on right if ¬fullscreen & wide
    " fullscreen
    if l:opts =~ '2'
        let a:spec['window'] = { 'width': 1, 'height': 1, 'yoffset': 1, 'border': 'top' }
        let l:preview_window = 'up'
    else
        let l:preview_window = IsVimWide() ? 'right' : 'up'
    endif
    if l:opts =~ '3'
        if &filetype ==# 'fern' " from fern's cwd
            let a:spec['dir'] = b:fern.root._path
        else " from project root
            let a:spec['dir'] = FugitiveWorkTree()
        endif
    endif
    return fzf#vim#with_preview(a:spec, l:preview_window, 'ctrl-/')
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
    let spec = FzfOpts(v:count, {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--info=inline', '--layout=reverse-list']})
    call fzf#vim#grep(initial_command, 1, spec)
endfunc
func! Files(query)
    let spec = FzfOpts(v:count, {})
    if empty(a:query) && has_key(spec, 'dir')
        let l:query = spec['dir']
        unlet spec['dir']
        let spec['options'] = ['--prompt', fnamemodify(l:query, ':~:.') . '/']
    else
        let l:query = a:query
    endif
    call fzf#vim#files(l:query, fzf#vim#with_preview(spec, 'right'))
endfunc

" TODO: fzf stuff
" - reorg this section. split fzf and search things.
" - thin compat layer for fzf.vim and fzf-lua?
if has('nvim')
    lua require('tomtomjhj/fzf')
endif

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
        let l:vsts = &varsofttabstop
        setlocal softtabstop=0 varsofttabstop=
        return repeat("\<BS>", l:idx)
                    \ . "\<C-R>=execute('".printf('setl sts=%d vsts=%s', l:sts, l:vsts)."')\<CR>"
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
xnoremap <C-q> <Esc>
snoremap <C-q> <Esc>
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
    " TODO: When [Process exited $EXIT_CODE] in terminal mode, pressing any key wipes the terminal buffer. Require specific command to do that.
    command! -nargs=? -complete=shellcmd T <mods> split | exe "terminal" <q-args> | if empty(<q-args>) | startinsert | endif
else
    " NOTE: If 'hidden' is set and arg is provided, job finished + window closed doesn't wipe the buffer, in contrary to the doc:
    " > When the job has finished and no changes were made to the buffer: closing the
    " > window will wipe out the buffer.
    command! -nargs=? -complete=shellcmd T exe <q-mods> "terminal" <q-args>
endif

augroup terminal-custom | au!
    if has('nvim')
        au TermOpen,WinEnter *           if &buftype is# 'terminal' | setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no | endif
    elseif exists('##TerminalWinOpen')
        au TerminalWinOpen,BufWinEnter * if &buftype is# 'terminal' | setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no | endif
    endif
augroup END

let g:asyncrun_exit = exists('*nvim_notify') ? 'lua vim.notify(vim.g.asyncrun_status .. ": AsyncRun " .. vim.g.asyncrun_info)' : 'echom g:asyncrun_status . ": AsyncRun " . g:asyncrun_info'
Noremap <leader>R :AsyncRun<space>
nnoremap <leader>ST :AsyncStop<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -auto=make -program=make @ <args>
nnoremap <leader>M :Make<space>
command! -bang -bar -nargs=* -complete=customlist,fugitive#PushComplete Gpush  execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* -complete=customlist,fugitive#FetchComplete Gfetch execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
" }}}

" quickfix, loclist, ... {{{
" TODO: manually adding lines to qf?
" TODO: Too many functionalities use quickfix. Use location list for some of them.
let g:qf_window_bottom = 0
let g:qf_loclist_window_bottom = 0
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0
let g:qf_max_height = 12
let g:qf_auto_quit = 0

packadd cfilter

nmap <silent><leader>cw :CW<CR>
nmap <silent><leader>lw :LW<CR>
nmap <silent><leader>x  :pc\|ccl\|lcl<CR>
nmap <silent>]q <Plug>(qf_qf_next)
nmap <silent>[q <Plug>(qf_qf_previous)
nmap <silent>]l <Plug>(qf_loc_next)
nmap <silent>[l <Plug>(qf_loc_previous)

" like cwindow, but don't jump to the window
command! -bar -nargs=? CW call s:cwindow(0, <q-mods>, <q-args>)
command! -bar -nargs=? LW call s:cwindow(1, <q-mods>, <q-args>)
function! s:cwindow(loclist, mods, args) abort
    let curwin = win_getid()
    let view = winsaveview()
    exe a:mods . (a:loclist ? ' lwindow' : ' cwindow') a:args
    " jumped to qf/loc window. return.
    if curwin != win_getid() && &buftype ==# 'quickfix'
        wincmd p
        call winrestview(view)
    endif
endfunction

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
    elseif has('win32')
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
nnoremap <leader>-  <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t')])<CR>
nnoremap <C-w>es    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=split'])<CR>
nnoremap <C-w>ev    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=vsplit'])<CR>
nnoremap <C-w>et    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=tabedit'])<CR>
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
    nnoremap <buffer> ~ <Cmd>Fern ~<CR>
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

" TODO:
" - matchit integration doesn't work with matchup
" - no command/mapping for selecting diff3 style merge base
let g:conflict_marker_highlight_group = ''
function! s:conflict_marker_hi() abort
    if &background is# 'light'
        hi ConflictMarkerBegin guibg=#3f9989
        hi ConflictMarkerOurs guibg=#74ccba
        hi ConflictMarkerTheirs guibg=#699fd1
        hi ConflictMarkerEnd guibg=#2f628e
        hi ConflictMarkerCommonAncestorsHunk guibg=#c57cd9
    else
        hi ConflictMarkerBegin guibg=#2f7366
        hi ConflictMarkerOurs guibg=#2e5049
        hi ConflictMarkerTheirs guibg=#344f69
        hi ConflictMarkerEnd guibg=#2f628e
        hi ConflictMarkerCommonAncestorsHunk guibg=#754a81
    endif
endfunction
call s:conflict_marker_hi()
augroup conflict-marker-custom | au!
    au ColorScheme * call s:conflict_marker_hi()
augroup END
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
xmap ii <Plug>(indent-object_linewise-none)
omap ii <Plug>(indent-object_linewise-none)
xmap ai <Plug>(indent-object_linewise-start)
omap ai <Plug>(indent-object_linewise-start)
xmap iI <Plug>(indent-object_linewise-end)
omap iI <Plug>(indent-object_linewise-end)
xmap aI <Plug>(indent-object_linewise-both)
omap aI <Plug>(indent-object_linewise-both)

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
" disable nvim :h editorconfig
let g:editorconfig = v:false
let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']

" undotree
let g:undotree_WindowLayout = 4
nnoremap U :UndotreeToggle<CR>

" sentencer
let g:sentencer_filetypes = []
let g:sentencer_textwidth = 79 " formatexpr doesn't work like built-in gq for textwidth=0
let g:sentencer_ignore = ['\<i.e', '\<e.g', '\<vs', '\<Dr', '\<Mr', '\<Mrs', '\<Ms', '\<et al', '\<fig']
xnoremap <leader>us :Unpdf<CR>gv:Sentencer<CR>

" vim-mark
let g:mwMaxMatchPriority = -2
let g:mw_no_mappings = 1
nmap m* <Plug>MarkSet
xmap m* <Plug>MarkSet
nmap m/ <Plug>MarkSearchAnyNext
nmap m? <Plug>MarkSearchAnyPrev
nmap m<BS> <Plug>MarkToggle
" TODO: stuff using api-highlights, like codepainter

" venn
command! Venn call s:toggle_venn()
function! s:toggle_venn() abort
    if !exists('b:venn')
        let b:venn = #{ virtualedit: &l:virtualedit, H: maparg('H', 'n', 0, 1), J: maparg('J', 'n', 0, 1), K: maparg('K', 'n', 0, 1), L: maparg('L', 'n', 0, 1), V: maparg('V', 'x', 0, 1) }
        " undojoin strokes to the same direction?
        nnoremap <buffer><nowait><silent> H <C-v>h:VBox<CR>
        nnoremap <buffer><nowait><silent> J <C-v>j:VBox<CR>
        nnoremap <buffer><nowait><silent> K <C-v>k:VBox<CR>
        nnoremap <buffer><nowait><silent> L <C-v>l:VBox<CR>
        xnoremap <buffer><nowait><silent> V :VBox<CR>
        " buffer-local virtualedit
        setlocal virtualedit=all
        augroup venn-mode | au!
            au BufLeave * if exists('b:venn') | let &l:virtualedit = b:venn.virtualedit | endif
            au BufEnter * if exists('b:venn') | setlocal virtualedit=all | endif
        augroup END
    else
        au! venn-mode
        let &l:virtualedit = b:venn.virtualedit
        for [m, k] in [['n', 'H'], ['n', 'J'], ['n', 'K'], ['n', 'L'], ['n', 'V']]
            if empty(b:venn[k])
                silent! exe m . 'unmap <buffer>' k
            else
                call mapset(m, 0, b:venn[k])
            endif
        endfor
        unlet b:venn
    endif
endfunction
" }}}

" etc util {{{
" helpers {{{
" Expands cmdline-special in text that that doesn't contain \r.
function! s:expand_cmdline_special(line) abort
    return substitute(substitute(substitute(
                \ a:line, '\\\\', '\r', 'g' ),
                \ '\v\\@<!(\%|#%(\<?\d+|#)?)', '\=expand(submatch(1))', 'g' ),
                \ '\r', '\\\\', 'g' )
endfunction
function! s:cabbrev(lhs, rhs) abort
    return (getcmdtype() == ':' && getcmdline() ==# a:lhs) ? a:rhs : a:lhs
endfunction
" }}}

if has('nvim-0.9')
    nnoremap <leader>st <Cmd>Inspect<CR>
else
    nnoremap <silent><leader>st :<C-u>echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")') '->' synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')<CR>
endif

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

function! TempBuf(mods, title, ...) abort
    exe a:mods 'new' (empty(a:title) ? '' : printf('temp://%s', a:title))
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile nomodeline
    if a:0
        call setline(1, a:1)
    endif
endfunction
function! Execute(cmd, mods) abort
    call TempBuf(a:mods, ':' . a:cmd, split(execute(a:cmd), "\n"))
endfunction
function! WriteC(cmd, mods) range abort
    call TempBuf(a:mods, ':w !' . a:cmd, systemlist(s:expand_cmdline_special(a:cmd), getline(a:firstline, a:lastline)))
endfunction
function! Bang(cmd, mods) abort
    call TempBuf(a:mods, ':!' . a:cmd, systemlist(s:expand_cmdline_special(a:cmd)))
endfunction
command! -nargs=* -complete=command Execute call Execute(<q-args>, '<mods>')
command! -nargs=* -range=% -complete=shellcmd WC <line1>,<line2>call WriteC(<q-args>, '<mods>')
command! -nargs=* -complete=shellcmd Bang call Bang(<q-args>, '<mods>')

command! -range=% TrimWhitespace
            \ let _view = winsaveview()
            \|keeppatterns keepjumps <line1>,<line2>substitute/\s\+$//e
            \|call winrestview(_view)
            \|unlet _view

command! -range=% CollapseBlank
            \ let _view = winsaveview()
            \|exe 'keeppatterns keepjumps <line1>,<line2>global/^\_$\_s\+\_^$/d _'
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

" Doesn't work with hard wrapped list.
" Alternative: %!pandoc --from=commonmark_x --to=commonmark_x --wrap=none
command! -range=% ZulipMarkdown
            \ keeppatterns keepjumps <line1>,<line2>substitute/^    \ze[-+*]\s/  /e
            \|keeppatterns keepjumps <line1>,<line2>substitute/^        \ze[-+*]\s/    /e
            \|keeppatterns keepjumps <line1>,<line2>substitute/^            \ze[-+*]\s/      /e

if !has('nvim')
    command! -nargs=+ -complete=shellcmd Man delcommand Man | runtime ftplugin/man.vim | if winwidth(0) > 170 | exe 'vert Man' <q-args> | else | exe 'Man' <q-args> | endif
    command! SW w !sudo tee % > /dev/null
endif

command! Profile profile start profile.log | profile func * | profile file *
" NOTE: lua profile https://github.com/nvim-lua/plenary.nvim#plenaryprofile
" }}}
