" vim: set foldmethod=marker foldlevel=0:

let g:nvim_latest_stable = has('nvim-0.10')
let g:ide_client = get(g:, 'ide_client', g:nvim_latest_stable ? 'nvim' : 'coc')

if !has('nvim')
    let g:loaded_getscriptPlugin = 1
    let g:loaded_rrhelper = 1
    let g:loaded_logiPat = 1
endif
let g:loaded_spellfile_plugin = 1

" Plug {{{
if has('vim_starting')
call plug#begin('~/.vim/plugged')

" appearance
Plug 'tomtomjhj/taiga.vim'
Plug 'tomtomjhj/quite.vim'
Plug 'tomtomjhj/pal.vim'

" editing
Plug 'tomtomjhj/vim-sneak'
Plug 'machakann/vim-sandwich'
Plug 'tomtomjhj/vim-repeat' " issue #63
Plug 'andymass/vim-matchup' " i%, a%, ]%, z%, g% TODO: % that seeks backward https://github.com/andymass/vim-matchup/issues/49#issuecomment-470933348
Plug 'wellle/targets.vim' " multi (e.g. ib, iq), separator, argument
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment' " iv, av
Plug 'machakann/vim-textobj-functioncall'
Plug 'tomtomjhj/vim-commentary'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'whonore/vim-sentencer'

" etc
Plug 'tpope/vim-fugitive'
Plug 'tomtomjhj/conflict-marker.vim'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim' " added to vim in v9.0.1799~
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': has('unix') ? './install --all' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
if has('nvim')
    Plug 'ibhagwan/fzf-lua'
endif
Plug 'roosta/fzf-folds.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'lambdalisue/vim-fern'
Plug 'lambdalisue/vim-fern-hijack'
Plug 'inkarkat/vim-mark', { 'on': ['<Plug>MarkS', 'Mark'] }
Plug 'inkarkat/vim-ingo-library'

" lanauges
Plug 'dense-analysis/ale', { 'on': ['<Plug>(ale_', 'ALEEnable', 'ALEFix'] } ")
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
    Plug 'mrcjkb/rustaceanvim'
    Plug 'p00f/clangd_extensions.nvim'
    Plug 'tomtomjhj/ltex-ls.nvim'
    Plug 'tomtomjhj/coq-lsp.nvim'
    Plug 'tomtomjhj/vscoq.nvim'
endif
Plug 'rafamadriz/friendly-snippets'
Plug 'tomtomjhj/tpope-vim-markdown'
Plug 'tomtomjhj/vim-markdown'
let g:pandoc#filetypes#pandoc_markdown = 0 | Plug 'vim-pandoc/vim-pandoc'
Plug 'tomtomjhj/vim-pandoc-syntax'
Plug 'tomtomjhj/vim-rust-syntax-ext'| Plug 'rust-lang/rust.vim'
Plug 'ocaml/vim-ocaml'
Plug 'neovimhaskell/haskell-vim'
Plug 'tomtomjhj/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
Plug 'tomtomjhj/Coqtail'
" Plug 'puremourning/vimspector' | let g:vimspector_enable_mappings = 'HUMAN'
Plug 'rhysd/vim-llvm'

" etc etc
if has('nvim')
    Plug 'nvim-lua/plenary.nvim', { 'do': 'rm -rf plugin' }
endif
if has('nvim') && !has('nvim-0.8')
    Plug 'antoinemadec/FixCursorHold.nvim'
endif
if g:nvim_latest_stable
    " NOTE: when using local install of nvim, should reinstall
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'stevearc/aerial.nvim'
    Plug 'jbyuki/venn.nvim'
    Plug 'folke/flash.nvim'
endif

" NOTE: This runs `filetype plugin indent on`, which registers au FileType.
" Custom au FileType should be registered after this.
call plug#end()
endif
" }}}

" Basic {{{
command! -nargs=1 Mnoremap exe 'nnoremap' <q-args> | exe 'xnoremap' <q-args> | exe 'onoremap' <q-args>
command! -nargs=1 Mmap     exe 'nmap' <q-args>     | exe 'xmap' <q-args>     | exe 'omap' <q-args>
command! -nargs=1 Noremap  exe 'nnoremap' <q-args> | exe 'xnoremap' <q-args>
command! -nargs=1 Map      exe 'nmap' <q-args>     | exe 'xmap' <q-args>

if has('vim_starting')
set encoding=utf-8

set mouse=nvir
set number signcolumn=number
set ruler showcmd
set foldcolumn=1 foldnestmax=9 foldlevel=99
let &foldtext = 'printf("%s %s+%d", substitute(getline(v:foldstart), ''\v^\s*\ze\s'', ''\=repeat("-", len(submatch(0)))'', 0), v:folddashes, v:foldend - v:foldstart)'
" TODO: I want nostartofline when using sidescroll
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
if has('patch-9.1.0413') || has('nvim-0.10') | set smoothscroll | endif
let &backspace = (has('patch-8.2.0590') || has('nvim-0.5')) ? 'indent,eol,nostop' : 'indent,eol,start'
set whichwrap+=<,>,[,],h,l
set cpoptions-=_

let $LANG='en'
set langmenu=en
set spellfile=~/.vim/spell/en.utf-8.add
set spelllang=en,cjk
set spellsuggest=best,13

let mapleader = "\<Space>"
Mnoremap <Space> <Nop>
let maplocalleader = ","
Mnoremap , <Nop>
Mnoremap <M-;> ,
" scrolling with only left hand
Noremap <C-Space> <C-u>
Noremap <Space><Space> <C-d>

set wildmenu wildmode=longest:full,full
" expand() expands wildcard with shell, and then filters with wildignore converted with glob2regpat().
let s:wildignore_files = ['*~', '%*', '*.o', '*.so', '*.pyc', '*.pdf', '*.v.d', '*.vo', '*.vo[sk]', '*.glob', '*.aux']
let s:wildignore_dirs = ['.git', '__pycache__', 'target'] " '*/dir/*' is too excessive.
let &wildignore = join(s:wildignore_files + s:wildignore_dirs, ',')
set complete-=i complete-=u
set path=.,,

set ignorecase smartcase tagcase=match
set hlsearch incsearch

set noerrorbells novisualbell t_vb=
set shortmess+=Ic shortmess-=S
set belloff=all

set history=765
set viminfo=!,'150,<50,s30,h,r/tmp,r/run,rterm://,rfugitive://,rfern://,rman://,rtemp://
set updatetime=1234
set noswapfile " set directory=~/.vim/swap//
set backup backupdir=~/.vim/backup//
set undofile
if has('nvim-0.5') | set undodir=~/.vim/undoo// | else | set undodir=~/.vim/undo// | endif

set autoread
set splitright splitbelow
if (has('patch-8.1.2315') || has('nvim-0.5')) | set switchbuf+=uselast | endif
if (has('patch-9.1.0572') || has('nvim-0.11')) | set tabclose+=uselast | endif
if has('nvim-0.8') | set jumpoptions+=view | endif
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
    au BufRead * if empty(&buftype) && &filetype !~# '^git' && line("'\"") > 1 && line("'\"") <= line("$") | exec "norm! g`\"" | endif
    au VimEnter * exec 'tabdo windo clearjumps' | tabnext
    au BufWritePost ~/.vim/configs.vim nested source ~/.vim/configs.vim
    au BufRead,BufNewFile *.k setlocal filetype=k
    au BufRead,BufNewFile *.mir setlocal syntax=rust
    if has('nvim-0.5')
        au TextYankPost * silent! lua vim.highlight.on_yank()
    endif
augroup END

if has('linux')
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
        FontSize 10
    elseif exists('g:neovide')
        let g:neovide_cursor_animation_length = 0
    endif
endfunction

if has('nvim') && has('vim_starting')
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
    hi! STLModeNormal1  guifg=#005f00 ctermfg=22  guibg=#afdf00 ctermbg=148 gui=nocombine,bold cterm=nocombine,bold
    hi! STLModeNormal2  guifg=#ffffff ctermfg=231 guibg=#626262 ctermbg=241 gui=nocombine cterm=nocombine
    hi! STLModeNormal3  guifg=#bcbcbc ctermfg=250 guibg=#303030 ctermbg=236 gui=nocombine cterm=nocombine
    hi! STLModeNormal4  guifg=#585858 ctermfg=240 guibg=#d0d0d0 ctermbg=252 gui=nocombine cterm=nocombine
    hi! STLModeVisual   guifg=#870000 ctermfg=88  guibg=#ff8700 ctermbg=208 gui=nocombine,bold cterm=nocombine,bold
    hi! STLModeReplace  guifg=#ffffff ctermfg=231 guibg=#df0000 ctermbg=160 gui=nocombine,bold cterm=nocombine,bold
    hi! STLModeInsert1  guifg=#005f5f ctermfg=23  guibg=#ffffff ctermbg=231 gui=nocombine,bold cterm=nocombine,bold
    hi! STLModeInsert2  guifg=#ffffff ctermfg=231 guibg=#0087af ctermbg=31  gui=nocombine cterm=nocombine
    hi! STLModeInsert3  guifg=#afd7ff ctermfg=153 guibg=#005f87 ctermbg=24  gui=nocombine cterm=nocombine
    hi! STLModeInsert4  guifg=#005f5f ctermfg=23  guibg=#87dfff ctermbg=117 gui=nocombine cterm=nocombine
    hi! STLModeCmdline1 guifg=#262626 ctermfg=235 guibg=#ffffff ctermbg=231 gui=nocombine,bold cterm=nocombine,bold
    hi! STLModeCmdline2 guifg=#303030 ctermfg=236 guibg=#d0d0d0 ctermbg=252 gui=nocombine cterm=nocombine
    hi! STLModeCmdline3 guifg=#303030 ctermfg=236 guibg=#8a8a8a ctermbg=245 gui=nocombine cterm=nocombine
    hi! STLModeCmdline4 guifg=#585858 ctermfg=240 guibg=#ffffff ctermbg=231 gui=nocombine cterm=nocombine

    hi! STLInactive2  guifg=#8a8a8a ctermfg=245 guibg=#1c1c1c ctermbg=234 gui=nocombine cterm=nocombine
    hi! STLInactive3  guifg=#8a8a8a ctermfg=245 guibg=#303030 ctermbg=236 gui=nocombine cterm=nocombine
    hi! STLInactive4  guifg=#262626 ctermfg=235 guibg=#606060 ctermbg=241 gui=nocombine cterm=nocombine

    hi! STLError   guifg=#262626 ctermfg=235 guibg=#ff5f5f ctermbg=203  gui=nocombine cterm=nocombine
    hi! STLWarning guifg=#262626 ctermfg=235 guibg=#ffaf5f ctermbg=215  gui=nocombine cterm=nocombine
endfunction
call StatuslineHighlightInit()

function! STLFunc() abort
    if g:statusline_winid is# win_getid()
        let m = mode()[0]
        let [hl1, hl2, hl3, hl4] = s:stl_active_hl[m]
        return join([ hl1, ' ' . s:stl_mode_map[m] . ' ',
                    \ hl2, '%( %w%q%h%)%( %{STLTitle()}%) ',
                    \ hl3, '%( %{STLProgress()} %)',
                    \ hl3, '%( %{STLBufState()}%{get(b:,"stl_git","")}%)', '%<', '%( %{STLBreadCrumb()}%)',
                    \ '%=',
                    \ hl3, '%(%{SearchCount()} %)',
                    \ '%#STLError#%( %{STLDiagnosticErrors()} %)',
                    \ '%#STLWarning#%( %{STLDiagnosticWarnings()} %)',
                    \ hl2, ' %3p%% ',
                    \ hl4, ' %3l:%-2c '
                    \], '')
    else
        let [hl1, hl2, hl3, hl4] = s:stl_inactive_hl
        return join([ hl2, '%( %w%q%h%)%( %{STLTitle()}%) ',
                    \ hl3, '%( @%{winnr()}%)%( %{STLBufState()}', '%<', '%{get(b:,"stl_git","")}%)', '%( %{STLBreadCrumb()}%)',
                    \ '%=',
                    \ hl3, '%( %{STLDiagnosticErrors()} %)',
                    \ hl3, '%( %{STLDiagnosticWarnings()} %)',
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
        return has('nvim') ? '!' . matchstr(bname, 'term://.\{-}//\d\+:\zs.*') : bname
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

" sets b:stl_git for real files that may be tracked by some git repo
function! UpdateGitStatus(buf) abort
    let bname = fnamemodify(bufname(a:buf), ':p')
    if !empty(getbufvar(a:buf, '&buftype')) || !filereadable(bname) || empty(FugitiveGitDir(a:buf)) | return | endif
    let status = ''
    let result = FugitiveExecute(['status', '--porcelain', bname], a:buf)
    if result.exit_status == 0
        let status = '[' . FugitiveHead(10, a:buf) . (empty(result.stdout[0]) ? '' : ':' . result.stdout[0][:1]) . ']'
    endif
    call setbufvar(a:buf, 'stl_git', status)
endfunction

augroup Statusline | au!
    " this may be called during startup when plugin/ is still not loaded, e.g. viewing .exrc
    au BufReadPost,BufWritePost * silent! call UpdateGitStatus(str2nr(expand('<abuf>')))
    " unloaded buffers will be refreshed on BufReadPost
    au User FugitiveChanged call map(getbufinfo({'bufloaded':1}), 'UpdateGitStatus(v:val.bufnr)')
    au ColorScheme * call StatuslineHighlightInit()
augroup END
" }}}

" ColorScheme {{{
command! Bg if &background ==# 'dark' | set background=light | else | set background=dark | endif

" set env vars controlling terminal app themes based on vim colorscheme
" NOTE: setting these in bashrc is not enough, because apps can be directly run from vim/nvim
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
    au OptionSet background let $BACKGROUND = &background
    au ColorScheme * call s:env_colors()
    " vim.lsp.util.open_floating_preview() with syntax=markdown uses lsp_markdown, which :syn-clears markdownError.
    " However, it's not actually cleared (maybe bug in interaction with :syn-include).
    " To workaround the fact that it's impossible to set default highlight to NONE,
    " set its highlight to something visually unnoticeable
    au ColorScheme * hi markdownError cterm=bold ctermbg=NONE ctermfg=NONE gui=NONE guibg=NONE guifg=NONE
    au ColorScheme pal let s:tgc = &termguicolors | set notermguicolors | au ColorSchemePre * ++once let &termguicolors = s:tgc | unlet! s:tgc
augroup END

if has('vim_starting')
    if $BACKGROUND ==# 'dark' || $BACKGROUND ==# 'light'
        let &background = $BACKGROUND
    else
        let $BACKGROUND = &background
    endif
    set termguicolors
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
        au! LoadLuaSnip
        call plug#load('LuaSnip', 'cmp_luasnip')

        " TODO: sometimes snippets are not loaded? :e fixes it.
        lua require("luasnip.loaders.from_vscode").lazy_load { paths = { "~/.vim/vsnip", "~/.vim/plugged/friendly-snippets" } }
        lua require("luasnip.loaders.from_lua").lazy_load { paths = "~/.vim/lsnip/" }
        lua require("luasnip").config.setup { cut_selection_keys = "<C-L>", region_check_events = 'InsertEnter', delete_check_events = 'InsertLeave' }

        " See cmp.lua for imap <C-l>, <C-h>
        snoremap <silent> <C-l> <Cmd>lua require('luasnip').jump(1)<CR>
        snoremap <silent> <C-h> <Cmd>lua require('luasnip').jump(-1)<CR>
    endfunction

    if has('vim_starting')
        augroup LoadLuaSnip | au!
            au InsertEnter * call s:LoadLuaSnip()
        augroup END
        xnoremap <silent> <C-l> <Cmd>call <SID>LoadLuaSnip()\|call feedkeys("<C-l>")<CR>
    endif
endif
" }}}

" ALE, LSP, ... global settings. See ./plugin/lsp.vim {{{
let g:ale_linters = {}
let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'lua': ['stylua'],
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

" NOTE: treesitter FileType autocmd should override the above stuff
if g:nvim_latest_stable
    lua require('tomtomjhj/treesitter')
    lua require('tomtomjhj/aerial')
    lua require('tomtomjhj/highlight')
endif

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
" https://doc.ecoscentric.com/gnutools/doc/gdb/Rust.html
let g:termdebugger = 'rust-gdb'
" TODO: add completion in cargo command
let g:cargo_shell_command_runner = 'AsyncRun -post=CW|try|cnewer|catch|endtry @'
command! -nargs=* Cclippy call cargo#cmd("clippy " . <q-args>)
command! -range=% PrettifyRustSymbol <line1>,<line2>SubstituteDict { '$SP$': '@', '$BP$': '*', '$RF$': '&', '$LT$': '<', '$GT$': '>', '$LP$': '(', '$RP$': ')', '$C$' : ',',  '$u20$': ' ', '$u5b$': '[', '$u5d$': ']', '$u7b$': '{', '$u7d$': '}', }
function! s:rust() abort
    silent! setlocal formatoptions+=/ " 8.2.4907
    setlocal path+=src
    " TODO fix 'spellcapcheck' for `//!` comments, also fix <leader>sc mapping
    " TODO: matchit handle < -> non-pair
    inoremap <buffer><expr> < MuPairsAngleOpen()
    inoremap <buffer><expr> > MuPairsAngleClose()
    inoremap <buffer> ' '

    nnoremap <buffer><leader>C <Cmd>Make test --no-run<CR>
    xnoremap <buffer><leader>fm :RustFmtRange<CR>
    Mnoremap <silent><buffer> [[ <Cmd>call tomtomjhj#rust#section(1)<CR>
    Mnoremap <silent><buffer> ]] <Cmd>call tomtomjhj#rust#section(0)<CR>

    let b:textobj_functioncall_patterns = [
      \   {
      \     'header' : '\v\C<\h@=%(\k+%(::|\.))*\k+\!?',
      \     'bra'    : '\v\(',
      \     'ket'    : '\v\)',
      \     'footer' : '',
      \   },
      \   {
      \     'header' : '\v\C\<\h@=%(\k+(::|\.))*\k+\!?',
      \     'bra'    : '\v\[',
      \     'ket'    : '\v\]',
      \     'footer' : '',
      \   },
      \ ]
endfunction
" }}}

" C,C++ {{{
function s:c_cpp() abort
    setlocal shiftwidth=2
    setlocal commentstring=//%s
    silent! setlocal formatoptions+=/ " 8.2.4907
    setlocal path+=include,/usr/include
    if &filetype !=# 'c'
        inoremap <buffer><expr> < MuPairsAngleOpen()
        inoremap <buffer><expr> > MuPairsAngleClose()
    endif
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
let g:matchup_override_vimtex = 1
let g:vimtex_compiler_latexmk = { 'options' : [ '-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode', '-shell-escape', ], }
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:vimtex_indent_on_ampersands = 0
let g:vimtex_toc_config = { 'show_help': 0, 'split_pos': 'vert' }
let g:vimtex_toc_config_matchers = {
            \ 'todo_notes': {
                \ 're' : '\v%(' . '%(\\@<!%(\\\\)*)@<=' . '\%.*)@<!' . '\\\w*%(todo|jaehwang)\w*%(\[[^]]*\])?\{\zs.*',
                \ 'prefilter_cmds': ['todo', 'jaehwang']}
            \}
let g:vimtex_syntax_nospell_comments = 1
let g:vimtex_text_obj_variant = 'vimtex' " I don't use those targets.vim features and its ic is buggy(?)
" <Plug>(vimtex-cmd-change) (csc) only work in vimtex boundary.. can't change to sandwich's stuff
let g:vimtex_doc_handlers = ['vimtex#doc#handlers#texdoc']
let g:vimtex_ui_method = { 'confirm': 'legacy', 'input': 'legacy', 'select': 'legacy', }
let g:vimtex_syntax_conceal = { 'spacing': 0 }
let g:vimtex_indent_bib_enabled = 0
" NOTE: If inverse search doesn't work, check if zathura is run with -x option (vimtex sets this when launching it), and source files are correctly recognized by vimtex.
" TODO: compiling with vimtex lags fzf. sometimes input is completely blocked
function! s:tex() abort
    setlocal shiftwidth=2
    setlocal conceallevel=2
    " {[{[
    setlocal indentkeys-=] indentkeys-=} indentkeys-=\& indentkeys+=0],0}
    inoremap <buffer><expr> $ MuPairsDumb('$')
    nmap <buffer><silent><leader>oo :<C-u>call Zathura("<C-r>=expand("%:p:h").'/main.pdf'<CR>")<CR>
    nmap <buffer>        <leader>C <Cmd>update<CR><Plug>(vimtex-compile-ss)
    nmap <buffer>        <localleader>t <Cmd>call vimtex#fzf#run('ctli', g:fzf_layout)<CR>
    command! -range=% StripTexComment
                \ keeppatterns keepjumps <line1>,<line2>substitute/\S\zs\s*\\\@<!%.\+//e
                \|keeppatterns keepjumps <line1>,<line2>global/^\s*%/d
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
if !g:nvim_latest_stable | let g:markdown_folding = 1 | endif
" let g:mkdp_port = '8080'
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_close = 0
let g:mkdp_page_title = '${name}'
let g:mkdp_theme = &background
au colors-custom ColorScheme * let g:mkdp_theme = &background
" TODO: manually scroll to position in browser that matches the cursor position?
let g:mkdp_preview_options = {
            \ 'mkit': { 'typographer': v:false },
            \ 'disable_sync_scroll': 1 }
function! s:markdown() abort
    silent! call textobj#user#plugin('markdown', {
                \ 'code': {
                \    'select-a-function': 'tomtomjhj#markdown#FencedCodeBlocka',
                \    'select-a': '<buffer> ad',
                \    'select-i-function': 'tomtomjhj#markdown#FencedCodeBlocki',
                \    'select-i': '<buffer> id',
                \   },
                \ })

    " <> pair is too intrusive
    setlocal matchpairs-=<:>
    " Set from $VIMRUNTIME/ftplugin/html.vim
    let b:match_words = substitute(b:match_words, '<:>,', '', '')

    nmap     <buffer>             <leader>pd :<C-u>setlocal ft=pandoc\|unmap <lt>buffer><lt>leader>pd<CR>
    nnoremap <buffer><expr> <localleader>b tomtomjhj#surround#strong('')
    xnoremap <buffer><expr> <localleader>b tomtomjhj#surround#strong('')
    nnoremap <buffer><expr> <localleader>b<localleader>b tomtomjhj#surround#strong('') ..'_'
    nnoremap <buffer><expr> <localleader>~ tomtomjhj#surround#strike('')
    xnoremap <buffer><expr> <localleader>~ tomtomjhj#surround#strike('')
    nmap     <buffer>          <MiddleMouse> <LeftMouse><localleader>biw
    xmap     <buffer>          <MiddleMouse> <localleader>b
    " NOTE: `:[range]!pandoc -t commonmark_x` also works.
    nnoremap <buffer><silent>     <leader>tf :<C-u>TableFormat<CR>
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

    inoremap <buffer><expr> $ MuPairsDumb('$')

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
    " `make %:r.vo` to build only the files related to the current buffer
    nnoremap <buffer><leader>C <Cmd>Make -j4 -k %:r.vo<CR>
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
function! s:lua() abort
    setlocal shiftwidth=2
    setlocal comments=:---,:--
    setlocal commentstring=--%s
endfunction
" }}}

let g:lisp_rainbow = 1
let g:is_posix = 1
if has('nvim-0.10')
    let g:query_lint_on = ['BufReadPost', 'BufWritePost'] " Default has BufEnter .. too much lag
endif

" }}}

" search & fzf {{{
" `*`, `v_*` without moving the cursor. Reserve @c for the raw original text
" NOTE: Can't repeat properly if ins-special-special is used. Use q-recording.
nnoremap <silent>* :<C-u>call Star(0)\|set hlsearch<CR>
nnoremap <silent>g* :<C-u>call Star(1)\|set hlsearch<CR>
xnoremap <silent>* :<C-u>call VisualStar(0)\|set hlsearch<CR>
xnoremap <silent>g* :<C-u>call VisualStar(1)\|set hlsearch<CR>
" set hlsearch inside the function doesn't work? Maybe :h function-search-undo?
" NOTE: word boundary is syntax property -> may not match in other ft buffers
let s:star_mode = get(s:, 'star_mode', '/')
let s:star_histnr = get(s:, 'star_histnr', 0)
func! Star(g)
    let @c = expand('<cword>')
    " <cword> can be non-keyword
    if match(@c, '\k') == -1
        let s:star_mode = 'v'
        let @/ = Text2Magic(@c)
    else
        let s:star_mode = 'n'
        let @/ = a:g ? @c : '\<' . @c . '\>'
    endif
    call histadd('/', @/)
    let s:star_histnr = histnr('/')
endfunc
func! VisualStar(g)
    let s:star_mode = 'v'
    let l:reg_save = @"
    " don't trigger TextYankPost
    noau silent! normal! gvy
    let @c = @"
    let l:pattern = Text2Magic(@")
    let @/ = a:g ? '\<' . l:pattern . '\>' : l:pattern " reversed
    call histadd('/', @/)
    let s:star_histnr = histnr('/')
    let @" = l:reg_save
endfunc

cnoremap <expr> / (mode() =~# "[vV\<C-v>]" && getcmdtype() =~ '[/?]' && empty(getcmdline())) ? "\<C-c>\<Esc>/\\%V" : '/'

let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-s': 'split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }
let g:fzf_vim = {}
let g:fzf_vim.listproc = function('tomtomjhj#qf#fzf_listproc_qf')
" NOTE: fzf can't sidescroll https://github.com/junegunn/fzf/issues/577
" But can toggle line wrapping with alt-/.
let g:fzf_vim.grep_multi_line = 1

nnoremap <C-g>      :<C-u>Grep<space>
nnoremap <leader>g/ :<C-u>Grep! <C-r>=shellescape(RgInput(@/))<CR>
nnoremap <leader>gw :<C-u>Grep! <C-R>=shellescape('\b'.expand('<cword>').'\b')<CR>
nnoremap <leader>b  :<C-u>Buffers<CR>
nnoremap <C-f>      :<C-u>Files<CR>
" TODO: filter out stuff that matches wildignore e.g. .git/index, .git/COMMIT_EDITMSG
nnoremap <leader>hh :<C-u>History<CR>
nnoremap <leader><C-t> :<C-u>Tags <C-r><C-w><CR>
nnoremap <leader>fl :<C-u>Folds<CR>

" NOTE: not using -complete=file, because cmdline-spcial escaping is quite annoying
command! -nargs=? -bang Grep call Ripgrep(<q-args>, <bang>0)
command! -nargs=? -complete=dir Files call Files(<q-args>)
" allow search on the full tag info, excluding the appended tagfile name
" NOTE: preview scroll doesn't work
command! -nargs=* Tags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3..}", 'options': ['-d', '\t', '--nth', '..-2'] }))

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
    let mode = (s:star_histnr == histnr('/')) ? s:star_mode : '/' " not accurate, because / could've been aborted
    if mode ==# 'n'
        return substitute(a:raw, '\v\\[<>]','','g')
    elseif mode ==# 'v'
        " TODO: Now that I have :Grep!, just do `grep -f` or `rg -F` from @c
        return escape(a:raw, '+|?-(){}') " not escaped by VisualStar
    elseif a:raw[0:1] !=# '\v' " can convert most of strict very magic to riggrep regex, otherwise, DIY
        return substitute(a:raw, '\v(\\V|\\[<>])','','g')
    else
        return substitute(a:raw[2:], '\v\\([~/])', '\1', 'g')
    endif
endfunc
function! s:rg_cmd_base() abort
    let colors = &background ==# 'dark' ? '--colors path:fg:218 --colors match:fg:116 ' : '--colors path:fg:125 --colors match:fg:67 '
    return "rg -. -g '!**/.git/**' --no-heading -H -n --column -S --color=always " . colors
endfunction
func! Ripgrep(query, advanced)
    let cmd = s:rg_cmd_base() . (a:advanced ? a:query : shellescape(a:query))
    let spec = FzfOpts(v:count, {'options': ['--info=inline', '--layout=reverse-list']})
    call fzf#vim#grep(cmd, 1, spec)
endfunc
func! Files(query)
    let spec = FzfOpts(v:count, {})
    if empty(a:query) && has_key(spec, 'dir')
        let l:query = spec['dir']
        unlet spec['dir']
        let spec['options'] += ['--prompt', fnamemodify(l:query, ':~:.') . '/']
    else
        let l:query = a:query
    endif
    let preview_window = index(spec['options'], '--preview-window')
    if preview_window >= 0 | let spec['options'][preview_window + 1] = 'right' | endif " preview always on right
    call fzf#vim#files(l:query, spec)
endfunc

if has('nvim')
    lua require('tomtomjhj/fzf')
endif
" }}}

" Motion {{{
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
Mnoremap <expr> H v:count ? 'H' : 'h'
Mnoremap <expr> L v:count ? 'L' : 'l'

for s:mode in ['n', 'o', 'x']
    for s:motion in ['w', 'e', 'b', 'ge']
        exe printf('%smap %s <Plug>(PSWordMotion-%s)', s:mode, s:motion, s:motion)
        " exe printf('%smap %s %s', s:mode, join(map(split(s:motion, '\zs'), '''<M-''.v:val.''>'''), ''), s:motion)
    endfor
endfor
unlet s:mode s:motion

nnoremap <silent> <Plug>(PSWordMotion-w)   :<C-u>call PSWordMotion('w' , v:count1, ''  , ''  )<CR>
nnoremap <silent> <Plug>(PSWordMotion-e)   :<C-u>call PSWordMotion('e' , v:count1, ''  , ''  )<CR>
nnoremap <silent> <Plug>(PSWordMotion-b)   :<C-u>call PSWordMotion('b' , v:count1, ''  , ''  )<CR>
nnoremap <silent> <Plug>(PSWordMotion-ge)  :<C-u>call PSWordMotion('ge', v:count1, ''  , ''  )<CR>
onoremap <silent> <Plug>(PSWordMotion-w)   :<C-u>call PSWordMotion('w' , v:count1, ''  , ''  )<CR>
onoremap <silent> <Plug>(PSWordMotion-e)  v:<C-u>call PSWordMotion('e' , v:count1, ''  , ''  )<CR>
onoremap <silent> <Plug>(PSWordMotion-b)   :<C-u>call PSWordMotion('b' , v:count1, ''  , ''  )<CR>
onoremap <silent> <Plug>(PSWordMotion-ge)  :<C-u>call PSWordMotion('ge', v:count1, ''  , '1 ')<CR>
xnoremap <silent> <Plug>(PSWordMotion-w)   :<C-u>call PSWordMotion('w' , v:count1, 'gv', ''  )<CR>
xnoremap <silent> <Plug>(PSWordMotion-e)   :<C-u>call PSWordMotion('e' , v:count1, 'gv', ''  )<CR>
xnoremap <silent> <Plug>(PSWordMotion-b)   :<C-u>call PSWordMotion('b' , v:count1, 'gv', ''  )<CR>
xnoremap <silent> <Plug>(PSWordMotion-ge)  :<C-u>call PSWordMotion('ge', v:count1, 'gv', ''  )<CR>

function! PSWordMotion(motion, cnt, pre, post) abort
    if !empty(a:pre) | exe 'normal!' a:pre | endif
    let pat = a:motion =~ 'e' ? '\v.>@=|\S\ze\_s' : '\v<|(\s\zs|^)\S'
    let flag = a:motion =~ '^[we]' ? 'W' : 'Wb'
    for _ in range(a:cnt)
        call search(pat, flag)
    endfor
    if !empty(a:post) | exe 'normal!' a:post | endif
endfunction

Mnoremap <expr> 0 index([col('.') - 1, -1], match(getline('.'), '\S')) >= 0 ? '0' : '^'
Mnoremap <M-0> ^w

let g:sneak#s_next = 0
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
Mmap f <Plug>Sneak_f
Mmap F <Plug>Sneak_F
Mmap t <Plug>Sneak_t
Mmap T <Plug>Sneak_T
Mmap <M-;> <Plug>Sneak_,
" NOTE: my fork
let g:sneak#alias = {
            \ 'a': '[aα∀]', 'b': '[bβ]', 'c': '[cξ]', 'd': '[dδ]', 'e': '[eε∃]', 'f': '[fφ]', 'g': '[gγ]', 'h': '[hθ]', 'i': '[iι]', 'j': '[jϊ]', 'k': '[kκ]', 'l': '[lλ]', 'm': '[mμ]', 'n': '[nν]', 'o': '[oο]', 'p': '[pπ]', 'q': '[qψ]', 'r': '[rρ]', 's': '[sσ]', 't': '[tτ]', 'u': '[uυ]', 'v': '[vϋ𝓥]', 'w': '[wω]', 'x': '[xχ]', 'y': '[yη]', 'z': '[zζ]',
            \ '*': '[*∗]',
            \ '/': '[/∧]', '\': '[\∨]',
            \ '<': '[<≼]',
            \ '>': '[>↦→⇒⇝]',
            \ '[': '[[⌜⎡⊑⊓]', ']': '[\]⌝⎤⊒⊔]',
            \}

if g:nvim_latest_stable
lua << EOF
vim.keymap.set({ "n", "o", "x" }, "<M-s>", function() require'tomtomjhj/flash'.jump() end)
vim.keymap.set({ "n", "o", "x" }, "M",     function() require'tomtomjhj/flash'.treesitter() end)
-- vim.keymap.set("o",               "r",     function() require'tomtomjhj/flash'.remote() end)
vim.keymap.set({ "o", "x" },      "R",     function() require'tomtomjhj/flash'.treesitter_search() end)
vim.keymap.set({ "c" },           "<C-s>", function() require'tomtomjhj/flash'.toggle() end)
EOF
endif
" }}}

" insert/command mode {{{
" readline-style cmap
cnoremap <C-x><C-e> <C-f>
" moving
cnoremap <C-a> <Home>
" <C-e>
cnoremap <C-f> <Space><BS><Right>
cnoremap <C-b> <Space><BS><Left>
" changing text
cnoremap <expr> <C-d> getcmdpos() <= strlen(getcmdline()) ? "\<Del>" : ""
" completing
cnoremap <M-?> <C-d>
cnoremap <M-*> <C-a>

inoremap <expr> <C-u> match(getline('.'), '\S') >= 0 ? '<C-g>u<C-u>' : '<C-u>'

inoremap         <expr> <C-j>  ScanJump(0, 'NextTokenBoundary', "\<Right>")
cnoremap         <expr> <C-j>  ScanJump(1, 'NextTokenBoundary', "")
inoremap         <expr> <C-k>  ScanJump(0, g:PrevTokenBoundary, "\<Left>")
cnoremap         <expr> <C-k>  ScanJump(1, g:PrevTokenBoundary, "")
inoremap <silent><expr> <C-w>  ScanRubout(0, 'PrevTokenLeftBoundary')
cnoremap         <expr> <C-w>  ScanRubout(1, 'PrevTokenLeftBoundary')
inoremap <silent><expr> <M-BS> ScanRubout(0, g:PrevSubwordBoundary)
cnoremap         <expr> <M-BS> ScanRubout(1, g:PrevSubwordBoundary)

function! ScanJump(cmap, scanner, default) abort
    let line = a:cmap ? getcmdline() : getline('.')
    let from = s:charidx(line . ' ', (a:cmap ? getcmdpos() : col('.')) - 1)
    let line = split(line, '\zs')
    let to = call(a:scanner, [line, from])
    let delta = to - from
    if delta == 0 | return a:default | endif
    return (a:cmap ? "\<Space>\<BS>" : "")
        \. repeat(delta > 0 ? "\<Right>" : "\<Left>", abs(delta))
endfunction

function! ScanRubout(cmap, scanner) abort
    let line = a:cmap ? getcmdline() : getline('.')
    let from = s:charidx(line . ' ', (a:cmap ? getcmdpos() : col('.')) - 1)
    if from == 0 | return "\<C-w>" | endif
    let line = split(line, '\zs')
    let to = call(a:scanner, [line, from])
    if to == 0 && line[to] =~# '\s' " <BS> on indentation deletes shiftwidth
        return "\<C-w>"
    elseif a:cmap
        return repeat("\<BS>", from - to)
    elseif line[to] =~# '[^(){}[\]<>''"`$|]'
        return BSWithoutSTS(from - to)
    else
        return BSWithoutSTS(from - (to + 1)) . "\<C-R>=MuPairsBS()\<CR>"
    endif
endfunction

function! PrevBoundary(pat, line, from) abort
    if a:from == 0 | return 0 | endif
    let to = a:from - 1
    let c = a:line[to]
    if c =~# '\s' " to the right end of the previous token
        let to = SkipPatBackward(a:line, to, '\s')
    elseif c =~# a:pat " to the left end of the current token/subword
        let to = SkipPatBackward(a:line, to, a:pat)
    elseif c =~# '[^(){}[\]<>''"`$|]'
        let to = SkipCharBackward(a:line, to, c)
    endif
    return to
endfunction
let g:PrevTokenBoundary = function('PrevBoundary', ['\k'])
let g:PrevSubwordBoundary = function('PrevBoundary', ['[[:punct:]]\@!\k'])

function! NextTokenBoundary(line, from) abort
    let n = len(a:line)
    if a:from == n | return n | endif
    let c = a:line[a:from]
    let to = a:from + 1
    if c =~# '\s' " to the left end of the next token
        let to = SkipPatForward(a:line, to, '\s')
    elseif c =~# '\k' " to the right end of the current token
        let to = SkipPatForward(a:line, to, '\k')
    elseif c =~# '[^(){}[\]<>''"`$|]'
        let to = SkipCharForward(a:line, to, c)
    endif
    return to
endfunction

function! PrevTokenLeftBoundary(line, from) abort
    if a:from == 0 | return 0 | endif
    let to = SkipPatBackward(a:line, a:from, '\s')
    if to == 0 | return 0 | endif
    let to -= 1
    let c = a:line[to]
    if c =~# '\k' " to the left end of the word
        let to = SkipPatBackward(a:line, to, '\k')
    elseif c =~# '[^(){}[\]<>''"`$|]'
        let to = SkipCharBackward(a:line, to, c)
    endif
    return to
endfunction

function! SkipPatForward(line, from, pat) abort
    let n = len(a:line)
    let to = a:from
    while to < n && a:line[to] =~# a:pat | let to += 1 | endwhile
    return to
endfunction
function! SkipCharForward(line, from, char) abort
    let n = len(a:line)
    let to = a:from
    while to < n && a:line[to] is# a:char | let to += 1 | endwhile
    return to
endfunction
function! SkipPatBackward(line, from, pat) abort
    let to = a:from
    while to > 0 && a:line[to - 1] =~# a:pat | let to -= 1 | endwhile
    return to
endfunction
function! SkipCharBackward(line, from, char) abort
    let to = a:from
    while to > 0 && a:line[to - 1] is# a:char | let to -= 1 | endwhile
    return to
endfunction

function! BSWithoutSTS(n) abort
    let l:sts = &softtabstop
    let l:vsts = &varsofttabstop
    setlocal softtabstop=0 varsofttabstop=
    return repeat("\<BS>", a:n) . printf("\<Cmd>setl sts=%d vsts=%s\<CR>", l:sts, l:vsts)
endfunction
" }}}

" etc mappings {{{
nnoremap <silent><leader><CR> :<C-u>let v:searchforward=1\|nohlsearch<CR>
nnoremap <silent><leader><C-L> :<C-u>diffupdate<CR><C-L>
nnoremap <silent><leader>sfs :<C-u>syntax sync fromstart<CR><C-L>
nnoremap <leader>ss :<C-u>setlocal spell! spell?<CR>
nnoremap <leader>sc :<C-u>if empty(&spc) \| setl spc< spc? \| else \| setl spc= spc? \| endif<CR>
nnoremap <leader>sw :<C-u>setlocal wrap! wrap?<CR>
nnoremap <leader>ic :<C-u>set ignorecase! smartcase! ignorecase?<CR>

Noremap <leader>dp :diffput<CR>
Noremap <leader>do :diffget<CR>

" clipboard.
" Don't behave like P even if "+ is linewise. .... just use UI's paste                                           vvvvvv to avoid whitespace-only line
inoremap <expr> <C-v> '<C-g>u' . (getregtype('+') ==# 'V' && !empty(getline('.')[:max([0,col('.')-1-1])]) ? '<CR>0<C-d>' : '') . '<C-r><C-o>+' . (getregtype('+') ==# 'V' ? (empty(getline('.')[col('.')-1:]) ? '<BS>' : '<Left>') : '')
" "= is charwise if the result doesn't end with \n.
" inoremap <silent><C-v> <C-g>u<C-r><C-p>=substitute(substitute(@+, '^\_s\+', '', ''), '\_s\+$', '', '')<CR>
Noremap <M-c> "+y
nnoremap <silent> yY :<C-u>%yank+<CR>

" buf/filename
nnoremap <leader>fn 2<C-g>

onoremap <LeftMouse> <Esc><LeftMouse>

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
Mnoremap q: :
Mnoremap q <nop>
Mnoremap <M-q> q
Mnoremap <expr> qq empty(reg_recording()) ? 'qq' : 'q'
Mnoremap Q @q

" v_u mistake is  hard to notice. Use gu instead (works for visual mode too).
xnoremap u <nop>

" delete without clearing regs
Noremap x "_x

" last affected region. useful for selecting last pasted stuff
" NOTE: writing the buffer resets '[, '] it to whole buffer. :h autocmd-use
nnoremap <expr> gV (getpos("'[")[1:2] ==# [1,1] && getpos("']")[1:2] ==# [line("$"),1]) ? '`.' : '`[v`]'

" repetitive pastes using designated register @p
Noremap <M-y> "py
Noremap <M-p> "pp
Noremap <M-P> "pP

nnoremap Y y$
" onoremap <silent> ge :execute "normal! " . v:count1 . "ge<space>"<cr>
nnoremap <silent> & :&&<cr>
xnoremap <silent> & :&&<cr>

" set nrformats+=alpha
nnoremap <M-+> <C-a>
xnoremap <M-+> g<C-a>
nnoremap <M--> <C-x>
xnoremap <M--> g<C-x>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

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

nnoremap <leader>cx :<C-u>tabclose<CR>
nnoremap <leader>td :<C-u>tab split<CR>
nnoremap <leader>tt :<C-u>tabedit<CR>
nnoremap <leader>fe :<C-u>e!<CR>

for s:cmd in ["]", "\<C-]>", "f", "F", "g\<C-]>", "g]"]
    exe printf('nnoremap <silent> g<C-w>%s <Cmd>vert wincmd %s<CR>', s:cmd, s:cmd)
endfor
unlet! s:cmd
" }}}

" pairs {{{
let g:matchup_override_vimtex = 1
let g:matchup_matchparen_offscreen = {}
let g:matchup_matchparen_deferred = 1

inoremap <expr> ( MuPairsOpen('(', ')')
inoremap <expr> ) MuPairsClose('(', ')')
inoremap <expr> [ MuPairsOpen('[', ']')
inoremap <expr> ] MuPairsClose('[', ']')
inoremap <expr> { MuPairsOpen('{', '}')
inoremap <expr> } MuPairsClose('{', '}')
inoremap <expr> <CR> (match(getline('.'), '\k') >= 0 ? "\<C-G>u" : "") . MuPairsCR()
inoremap <expr> <BS> MuPairsBS()
inoremap <expr> " MuPairsDumb('"')
inoremap <expr> ' MuPairsDumb("'")
inoremap <expr> ` MuPairsDumb('`')
inoremap <C-g>(    (
inoremap <C-g>)    )
inoremap <C-g>[    [
inoremap <C-g>]    ]
inoremap <C-g>{    {
inoremap <C-g>}    }
inoremap <C-g><BS> <BS>
inoremap <C-g>"    "
inoremap <C-g>'    '
inoremap <C-g>`    `

function! MuPairsOpen(open, close) abort
    if s:prevcurchars()[1] =~# '\k'
        return a:open
    endif
    return a:open . a:close . "\<C-g>U\<Left>"
endfunction
function! MuPairsClose(open, close) abort
    if s:prevcurchars()[1] ==# a:close
        return "\<C-g>U\<Right>"
    endif
    return a:close
endfunction
function! MuPairsBS() abort
    let [prev, cur] = s:prevcurchars()
    if empty(prev) || empty(cur) | return "\<BS>" | endif
    let prevcur = prev . cur
    if index(['()', '[]', '{}', '""', "''", '``', '<>', '$$'], prevcur) >= 0
        return "\<Del>\<BS>"
    endif
    return "\<BS>"
endfunction
function! MuPairsCR() abort
    let [prev, cur] = s:prevcurchars()
    if empty(prev) || empty(cur) | return "\<CR>" | endif
    if index(['()', '[]', '{}', '<>'], prev . cur) >= 0
        return "\<CR>\<C-c>O" " NOTE: using i_CTRL-C
    endif
    return "\<CR>"
endfunction
" NOTE: For html-like languages, use MuPairsOpen
function! MuPairsAngleOpen() abort
    let [prev, cur] = s:prevcurchars()
    if prev =~# '[[:space:]=<]' || cur =~# '\k'
        return '<'
    endif
    return "<>\<C-g>U\<Left>"
endfunction
function! MuPairsAngleClose() abort
    let [prev, cur] = s:prevcurchars()
    if cur !=# '>' || prev =~# '\s'
        return '>'
    endif
    return "\<C-g>U\<Right>"
endfunction
function! MuPairsDumb(char) abort
    let [prev, cur] = s:prevcurchars()
    if cur ==# a:char
        return "\<C-g>U\<Right>"
    elseif cur =~# '\k\|[[({]' " might be opening
        return a:char
    elseif prev =~# '\S\&[^({[]' " might be closing or 's
        return a:char
    endif
    return a:char . a:char . "\<C-g>U\<Left>"
endfunction
function! s:prevcurchars() abort
    let c = s:charcol() - 1
    if c == 0 | return ['', strcharpart(getline('.'), 0, 1)] | endif
    let prevcur = strcharpart(getline('.'), c - 1, 2)
    return [strcharpart(prevcur, 0, 1), strcharpart(prevcur, 1, 1)]
endfunction

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
      \   {'buns': ['\v\(\*\_s', '\v\_s\*\)'], 'nesting': 1, 'regex': 1, 'kind': ['delete', 'textobj'], 'action': ['delete'], 'input': ['m']},
      \ ]
" NOTE: ib/ab is quite slow in tex
" NOTE: 'e' (environment) doesn't do autoindent
" TODO: Disable this only for letters? It is useful for punctuations.
" let g:sandwich#input_fallback = 0
omap ib <Plug>(textobj-sandwich-auto-i)
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap iB <Plug>(textobj-sandwich-query-i)
xmap iB <Plug>(textobj-sandwich-query-i)
omap aB <Plug>(textobj-sandwich-query-a)
xmap aB <Plug>(textobj-sandwich-query-a)
" }}}

" shell, terminal {{{
if &shell =~# 'bash$' && has('linux')
    let &shell = &shell . ' -O globstar'  " ** globs for :!, system(), etc
endif

if has('nvim')
    " NOTE: When [Process exited $EXIT_CODE] in terminal mode, pressing any key wipes the terminal buffer.
    command! -nargs=? -complete=customlist,s:shellcomplete T call Terminal(<q-mods>, expandcmd(<q-args>))
    function! Terminal(mods, args) abort
        exe a:mods 'new'
        setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no
        if empty(a:args)
            call termopen(ShellWords(&shell))
            startinsert
        else " a:args can be string or list
            call termopen(a:args)
        endif
    endfunction
    " see also: https://github.com/VioletJewel/vimterm.nvim
    tnoremap <expr> <C-w> &filetype !=# 'fzf' ? TermWinKey() : "\<C-w>"
    tnoremap <expr> <M-w> TermWinKey()
    function! TermWinKey() abort
        let count = ''
        let ch = getcharstr()
        if ch !=# '0'
            while ch =~# '\d'
                let count .= ch
                let ch = getcharstr()
            endwhile
        endif
        let count = count is# '' ? 0 : str2nr(count)
        if ch ==# '.'
            return repeat("\<C-w>", count ? count : 1)
        elseif ch ==# "\<C-\>"
            return repeat("\<C-\>", count ? count : 1)
        elseif ch ==# 'N' || ch ==# "\<C-n>"
            return "\<C-\>\<C-n>" " bug: sometimes stl is not redrawn?? also happens when actually typed
        elseif ch ==# '"'
            return "\<C-\>\<C-o>" . (count ? count : '') . '"' . getcharstr() . 'p'
        elseif ch ==# ':'
            return "\<C-\>\<C-o>" . ':' " this seems to break cursor shape
        elseif ch ==# 'g'
            let ch .= getcharstr()
        endif
        return printf("\<Cmd>%s wincmd %s\<CR>", count ? count : '', ch)
    endfunction
else
    " NOTE: If 'hidden' is set and arg is provided, job finished + window closed doesn't wipe the buffer, in contrary to the doc:
    " > When the job has finished and no changes were made to the buffer: closing the
    " > window will wipe out the buffer.
    command! -nargs=? -complete=customlist,s:shellcomplete T exe <q-mods> "terminal ++shell" <q-args>
endif
" Unlike :!/:term completion, -complete=shellcmd doesn't complete files after the first word is given.
" So, use :! completion by replacing the command with !.
" :! doesn't ignore leading shell variable assignments, so do it myself. For now it doesn't handle quoted values.
function! s:shellcomplete(A, L, P) abort
    return getcompletion(substitute(a:L[:(a:P-1)], '\<\u\a*[![:space:]]\s*\(\w\+=\S*\s\+\)*', '!', ''), 'cmdline')
endfunction

let g:asyncrun_exit = exists('*nvim_notify') ? 'lua vim.notify(vim.g.asyncrun_status .. ": AsyncRun " .. vim.g.asyncrun_cmd)' : 'echom g:asyncrun_status . ": AsyncRun " . g:asyncrun_cmd'
Noremap <leader>R :AsyncRun<space>
nnoremap <leader>ST :<C-u>AsyncStop<CR>
" https://github.com/skywind3000/asyncrun.vim/issues/232
command! -bang -nargs=* -complete=file Make exe 'AsyncRun -auto=make -program=make' ('-post=try|cnewer|catch|endtry' . (<bang>0 ? '' : '|CW')) '@' <q-args>
nnoremap <leader>M :<C-u>Make<space>
" }}}

" window layout {{{
command! -count Wfh setlocal winfixheight | if <count> | exe 'resize' <count> | endif
nnoremap <silent> <C-w>g= :<C-u>call <SID>adjust_winfix_wins()<CR>

function! s:adjust_winfix_wins() abort
    for w in range(1, winnr('$'))
        if getwinvar(w, '&winfixheight')
            exe w 'resize' &previewheight
        endif
    endfor
endfunction

function! s:heights() abort
    let &pumheight = min([&window/4, 20])
    let &previewheight = max([&window/4, 12])
endfunction
call s:heights()

augroup layout-custom | au!
    au VimResized * call s:heights()
augroup END
" }}}

" quickfix, loclist, ... {{{
packadd! cfilter

nnoremap <silent><leader>co :<C-u>botright copen<CR>
nnoremap <silent><leader>x  :<C-u>pc\|ccl\|lcl<CR>
nnoremap <silent>[q :<C-u>call <SID>Cnext(1, 'c')<CR>
nnoremap <silent>]q :<C-u>call <SID>Cnext(0, 'c')<CR>
nnoremap <silent>[l :<C-u>call <SID>Cnext(1, 'l')<CR>
nnoremap <silent>]l :<C-u>call <SID>Cnext(0, 'l')<CR>
" note: use :cex [] to start a new quickfix
nnoremap <silent> <leader>qf :<C-u>call <SID>Qfadd(v:count ? win_getid() : 0)<CR>
command! Cfork call setloclist(0, [], ' ', getqflist({'context':1, 'items':1, 'quickfixtextfunc':1, 'title':1})) | cclose | lwindow
function s:qf() abort
    setlocal nowrap
    setlocal norelativenumber number
    setlocal nobuflisted

    nnoremap <buffer> <Left>  :<C-u>call <SID>Colder('older')<CR>
    nnoremap <buffer> <Right> :<C-u>call <SID>Colder('newer')<CR>
    nnoremap <buffer><silent> <CR> <CR>:call FlashLine()<CR>
    if s:Qf().is_loc
        nmap <buffer> p <CR><C-w>p
    else
        " Like CTRL-W_<CR>, but with preview window and without messing up buffer list
        nnoremap <buffer><silent> p    :<C-u>call <SID>PreviewQf(line('.'))<CR>
        nnoremap <buffer><silent> <CR> :<C-u>pclose<CR><CR>:call FlashLine()<CR>
    endif
    nmap     <buffer>         J jp
    nmap     <buffer>         K kp
    command! -buffer -range Qfrm :<line1>,<line2>call s:Qfrm()
    Noremap <buffer><silent> dd :Qfrm<CR>
endfunction

augroup qf-custom | au!
    au FileType qf call s:qf()
    au QuitPre * nested if &filetype !=# 'qf' | silent! lclose | endif
augroup END

" like cwindow, but don't jump to the window
command! -bar -nargs=? CW call s:cwindow('c', <q-mods>, <q-args>)
command! -bar -nargs=? LW call s:cwindow('l', <q-mods>, <q-args>)
function! s:cwindow(prefix, mods, args) abort
    let curwin = win_getid()
    let view = winsaveview()
    exe a:mods . ' ' . a:prefix . 'window' a:args
    " jumped to qf/loc window. return.
    if curwin != win_getid() && &buftype ==# 'quickfix'
        wincmd p
        call winrestview(view)
    endif
endfunction

function! s:Qf(...) abort
    let win = a:0 ? a:1 : 0
    let is_loc = win || getwininfo(win_getid())[0]['loclist']
    return {'is_loc': is_loc,
          \ 'prefix': is_loc ? 'l' : 'c',
          \ 'get': is_loc ? function('getloclist', [win]) : function('getqflist'),
          \ 'set': is_loc ? function('setloclist', [win]) : function('setqflist')}
endfunction
function! s:Cnext(prev, prefix) abort
    try
        exe a:prefix . (a:prev ? 'previous' : 'next')
    catch /^Vim\%((\a\+)\)\=:E553/
        exe a:prefix . (a:prev ? 'last' : 'first')
    catch /^Vim\%((\a\+)\)\=:E\%(325\|776\|42\):/
    endtry
    if &foldopen =~ 'quickfix' && foldclosed(line('.')) != -1
        normal! zv
    endif
    call FlashLine()
endfunction
function! s:Colder(newer)
    try
        exe (s:Qf().prefix) . a:newer
    catch /^Vim\%((\a\+)\)\=:E\%(380\|381\):/
    endtry
endfunction
function! s:GetQfEntry(linenr) abort
    if &filetype !=# 'qf' | return {} | endif
    let l:qflist = s:Qf().get()
    if !l:qflist[a:linenr-1].valid | return {} | endif
    if !filereadable(bufname(l:qflist[a:linenr-1].bufnr)) | return {} | endif
    return l:qflist[a:linenr-1]
endfunction
function! s:PreviewQf(linenr) abort
    let l:entry = s:GetQfEntry(a:linenr)
    if empty(l:entry) | return | endif
    let l:listed = buflisted(l:entry.bufnr)
    let width = winwidth(0) > 170 ? winwidth(0) * 4 / 9 : 0
    if s:PreviewBufnr() != l:entry.bufnr
        execute (width ? 'vertical' : '')  'leftabove keepjumps pedit' bufname(l:entry.bufnr)
        if width | execute 'vertical resize' width | endif
    endif
    noautocmd wincmd P
    if l:entry.lnum > 0
        execute l:entry.lnum
    else
        call search(l:entry.pattern, 'w')
    endif
    normal! zzzv
    call FlashLine()
    if !l:listed
        setlocal nobuflisted bufhidden=delete noswapfile
    endif
    noautocmd wincmd p
endfunction
function! s:PreviewBufnr()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, '&previewwindow') == 1
            return winbufnr(nr)
        endif
    endfor
    return 0
endfunction
function! s:Qfadd(win) abort
    let qf = s:Qf(a:win)
    let item = {'bufnr': bufnr('%'), 'lnum': line('.'), 'text': getline('.')}
    call qf.set([item], 'a')
    call s:cwindow(qf.prefix, '', '')
endfunction
function! s:Qfrm() range abort
    let qf = s:Qf()
    let list = qf.get({'all':1})
    call remove(list['items'], a:firstline - 1, a:lastline - 1)
    let view = winsaveview()
    call qf.set([], 'r', list)
    call winrestview(view)
endfunction
" }}}

" Explorers {{{
let g:loaded_netrwPlugin = 1
function! GXBrowse(url)
    if exists('g:netrw_browsex_viewer')
        let viewer = g:netrw_browsex_viewer
    elseif has('unix') && executable('xdg-open')
        let viewer = 'xdg-open'
    elseif has('macunix') && executable('open')
        let viewer = 'open'
    elseif has('win32')
        let viewer = 'start'
    else
        return
    endif
    execute 'silent! !' . viewer . ' ' . shellescape(a:url, 1)
    redraw!
endfunction
" based on https://gist.github.com/gruber/249502
let s:url_regex = '\c\<\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)'
function! CursorURL() abort
    return matchstr(expand('<cWORD>'), s:url_regex)
endfunction
" TODO: Use nvim default gx?
nnoremap <silent> gx :<C-u>call GXBrowse(CursorURL())<cr>

" NOTE: :Fern that isn't drawer does not reuse "authority". Leaves too many garbage buffers.
let g:fern#default_exclude = '\v(\.glob|\.vo[sk]?|\.o)$'
let g:fern#disable_drawer_hover_popup = 1
let g:fern#disable_viewer_auto_duplication = 1
let g:fern#disable_viewer_spinner = 1 " runs timer even when idle
nnoremap <leader>nn <Cmd>Fern . -drawer -toggle<CR>
nnoremap <leader>nf <Cmd>Fern . -drawer -reveal=%<CR>
nnoremap <leader>-  <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t')])<CR>
nnoremap <C-w>es    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=split'])<CR>
nnoremap <C-w>ev    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=vsplit'])<CR>
nnoremap <C-w>et    <Cmd>call fern#internal#command#fern#command('', [BufDir(), '-reveal='.expand('%:t'), '-opener=tabedit'])<CR>
nnoremap <leader>cd :<C-u>cd <Plug>BufDir/
nnoremap <leader>e  :<C-u>e! <Plug>BufDir/
nnoremap <leader>te :<C-u>tabedit <Plug>BufDir/
" sometimes fern rename loses buffer content when the buffer is open???
function! s:init_fern() abort
    let helper = fern#helper#new()
    if helper.sync.is_drawer()
        setlocal nonumber foldcolumn=0
    else
        setlocal signcolumn=number foldcolumn=0
    endif
    " must ignore the error
    for lhs in ['<C-h>', '<C-j>', '<C-k>', '<C-l>', '<BS>', 'E', 's', 't', 'N', '!',]
        exe 'silent! nunmap <buffer>' lhs
    endfor
    silent! vunmap <buffer> -
    nnoremap <buffer> ~ <Cmd>Fern ~<CR>
    nmap <buffer> - <Plug>(fern-action-leave)
    nmap <buffer><leader><C-l> <Plug>(fern-action-reload)
    nmap <buffer> l <Plug>(fern-action-expand)
    Map  <buffer> x <Plug>(fern-action-mark:toggle)
    nmap <buffer> X <Plug>(fern-action-mark:clear)
    " TODO: doesn't work for pdf???
    nmap <buffer> gx <Plug>(fern-action-open:system)
    nmap <buffer> <C-n> <Plug>(fern-action-new-file)
    cmap <buffer> <C-r><C-p> <Plug>BufDir
    " toggle both hidden and exclude
    nmap <buffer> <expr> gh '<Plug>(fern-action-exclude=)<C-u>' . (!b:fern.hidden ? '' : g:fern#default_exclude) . '<CR>' . '<Plug>(fern-action-hidden:toggle)'
    nmap <buffer> . <Plug>(fern-action-ex)
    nmap <buffer> g. <Plug>(fern-action-repeat)
    nmap <buffer> g? <Plug>(fern-action-help)
    " TODO: don't reset cursor to top after D
    nmap <buffer> D <Plug>(fern-action-remove)
    nmap <buffer> o <Plug>(fern-action-open:split)
    nmap <buffer> gO <Plug>(fern-action-open:vsplit)
    nmap <buffer> O <Plug>(fern-action-open:tabedit)
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
    au Syntax git,gitcommit,diff syn sync minlines=321
    au FileType diff
        \ nnoremap <silent><buffer>zM :<C-u>setlocal foldmethod=syntax\|unmap <lt>buffer>zM<CR>zM
    au FileType git,fugitive,gitcommit
        \ setlocal foldtext=fugitive#Foldtext()
        \|nnoremap <silent><buffer>zM :<C-u>setlocal foldmethod=syntax\|unmap <lt>buffer>zM<CR>zM
        \|silent! unmap <buffer> *
        \|Mmap <buffer> <localleader>* <Plug>fugitive:*
    au FileType fugitiveblame setlocal cursorline
    au User FugitiveObject,FugitiveIndex
        \ silent! unmap <buffer> *
        \|Mmap <buffer> <localleader>* <Plug>fugitive:*
    " TODO: diff mapping for gitcommit
augroup END

cnoreabbrev <expr> gd <SID>cabbrev('gd', 'Gvdiffsplit')
" NOTE: pass -C for moved line detection
cnoreabbrev <expr> gb <SID>cabbrev('gb', 'G blame')

" TODO: matchit integration doesn't work with matchup
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
au colors-custom ColorScheme * call s:conflict_marker_hi()

let g:fugitive_gitlab_domains = {'ssh://git.fearless.systems:9001': 'https://git.fearless.systems', 'ssh://cp-git.kaist.ac.kr:9001': 'https://cp-git.kaist.ac.kr' } " no "git@"
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
" indented block
xnoremap <silent> ii :<C-U>exe 'normal! gv'\|call IndentObj(1,0,0)<CR>
onoremap <silent> ii :<C-u>call IndentObj(1,0,0)<CR>
xnoremap <silent> ai :<C-U>exe 'normal! gv'\|call IndentObj(1,1,0)<CR>
onoremap <silent> ai :<C-u>call IndentObj(1,1,0)<CR>
xnoremap <silent> aI :<C-U>exe 'normal! gv'\|call IndentObj(1,1,1)<CR>
onoremap <silent> aI :<C-u>call IndentObj(1,1,1)<CR>
" indented paragraph
xnoremap <silent> iP :<C-U>exe 'normal! gv'\|call IndentObj(0,0,0)<CR>
onoremap <silent> iP :<C-u>call IndentObj(0,0,0)<CR>

function! IndentObj(skipblank, header, footer) abort
    let line = nextnonblank('.')
    let level = indent(line)
    let start = line | let end = line
    while start > 1 && !(getline(start - 1) =~ '\S' ? indent(start - 1) < level : !a:skipblank)
        let start -= 1
    endwhile
    let start = a:header ? prevnonblank(start - 1) : nextnonblank(start)
    while end < line('$') && !(getline(end + 1) =~ '\S' ? indent(end + 1) < level : !a:skipblank)
        let end += 1
    endwhile
    let end = a:footer ? nextnonblank(end + 1) : prevnonblank(end)
    " union of the current visual region and the block/paragraph containing the cursor
    if mode() =~# "[vV\<C-v>]"
        let start = min([start, line("'<")])
        let end = max([end, line("'>")])
        exe "normal! \<Esc>"
    endif
    if end - start > winheight(0) | exe "normal! m'" | endif
    exe start | exe 'normal! V' | exe end
endfunction

call textobj#user#plugin('tomtomjhj', {
\   'url_or_filename': { 'pattern': '\('.s:url_regex.'\|\f\+\)', 'select': ['au', 'iu'] },
\})
" }}}

" comments {{{
imap <M-/> <C-G>u<Plug>CommentaryInsert
" }}}

" etc plugins {{{
let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']
if has('nvim-0.9')
    " Disable nvim's builtin editorconfig.
    let g:editorconfig = v:false
    " editorconfig-vim and nvim's editorconfig use the same augroup name.
    augroup override-editorconfig | au!
        au SourcePost */runtime/plugin/editorconfig.lua EditorConfigEnable
    augroup END
endif

" undotree
let g:undotree_WindowLayout = 4
let g:undotree_SetFocusWhenToggle = 1
nnoremap U :<C-u>UndotreeToggle<CR>
augroup undotree-custom | au!
    au FileType undotree let &l:statusline = ' @%{winnr()} %{t:undotree.GetStatusLine()}'
augroup END

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
        for [m, k] in [['n', 'H'], ['n', 'J'], ['n', 'K'], ['n', 'L'], ['x', 'V']]
            if empty(b:venn[k]) || !b:venn[k].buffer
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
" compat {{{
if exists('*charidx') " 8.2.2233
    function! s:charidx(string, idx)
        return charidx(a:string, a:idx)
    endfunction
else
    " If idx is not at the start of the char, the result differs from built-in charidx.
    function! s:charidx(string, idx)
        if a:idx >= strlen(a:string) | return -1 | endif
        return s:strcharlen(strpart(a:string, 0, a:idx))
    endfunction
endif
if exists('*charcol') " 8.2.2324
    function! s:charcol() abort
        return charcol('.')
    endfunction
else
    function! s:charcol() abort
        let c = col('.')
        if c == 1 | return 1 | endif
        return strchars(getline('.')[0 : c - 1 - 1], 1) + 1
    endfunction
endif
if exists('*strcharlen') " 8.2.2606
    function! s:strcharlen(string) abort
        return strcharlen(a:string)
    endfunction
else
    function! s:strcharlen(string) abort
        return strchars(a:string, 1)
    endfunction
endif
" }}}
" helpers {{{
function! s:cabbrev(lhs, rhs) abort
    return (getcmdtype() == ':' && getcmdline() ==# a:lhs) ? a:rhs : a:lhs
endfunction
" Taken from s:GitCmd() in autoload/fugitive.vim
function! ShellWords(string) abort
  let dquote = '"\%([^"]\|""\|\\"\)*"\|'
  let fnameescape = has('win32') ? " \t\n*?`%#'\"|!<" : " \t\n*?[{`$\\%#'\"|!<"
  let string = a:string
  let list = []
  while string =~# '\S'
    let arg = matchstr(string, '^\s*\%(' . dquote . '''[^'']*''\|\\.\|[^' . "\t" . ' |]\)\+')
    let string = strpart(string, len(arg))
    let arg = substitute(arg, '^\s\+', '', '')
    let arg = substitute(arg,
          \ '\(' . dquote . '''\%(''''\|[^'']\)*''\|\\[' . fnameescape . ']\|^\\[>+-]\)',
          \ '\=submatch(0)[0] ==# "\\" ? submatch(0)[1] : submatch(0)[1:-2]', 'g')
    call add(list, arg)
  endwhile
  return list
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

function! FlashLine() abort
    normal! zv
    let win = win_getid()
    let match = matchaddpos('QuickFixLine', [line('.')])
    call timer_start(321, { _ -> win_execute(win, printf('call matchdelete(%d)', match)) })
endfunction

function! TempBuf(mods, title, ...) abort
    exe a:mods 'new'
    if !empty(a:title)
        exe 'file' printf('temp://%d/%s', bufnr(''), fnameescape(a:title))
    endif
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile nomodeline
    if a:0
        call setline(1, a:1)
    endif
endfunction
function! Execute(cmd, mods) abort
    call TempBuf(a:mods, ':' . a:cmd, split(execute(a:cmd), "\n"))
endfunction
function! WriteC(cmd, mods) range abort
    call TempBuf(a:mods, ':w !' . a:cmd, systemlist(a:cmd, getline(a:firstline, a:lastline)))
endfunction
" NOTE: `:!cmd` does't capture the entire output.
function! Bang(cmd, mods) abort
    call TempBuf(a:mods, ':!' . a:cmd, systemlist(a:cmd))
endfunction
command! -nargs=* -complete=command Execute call Execute(<q-args>, '<mods>')
command! -nargs=* -range=% -complete=customlist,s:shellcomplete WC <line1>,<line2>call WriteC(expandcmd(<q-args>), '<mods>')
command! -nargs=* -complete=customlist,s:shellcomplete Bang call Bang(expandcmd(<q-args>), '<mods>')

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

" --wrap=auto|none|preserve
command! -range=% -nargs=? Md
            \ let _view = winsaveview()
            \|exe '<line1>,<line2>!pandoc --from=commonmark_x --to=commonmark_x' <q-args>
            \|call winrestview(_view)
            \|unlet _view

" :substitute using a dict, where key == submatch (like VisualStar)
function! SubstituteDict(dict) range
    exe a:firstline . ',' . a:lastline . 'substitute'
                \ . '/\C\%(' . join(map(keys(a:dict), 'Text2Magic(v:val)'), '\|'). '\)'
                \ . '/\=a:dict[submatch(0)]/ge'
endfunction
command! -range=% -nargs=1 SubstituteDict :<line1>,<line2>call SubstituteDict(<args>)

if !has('nvim')
    command! -nargs=+ -complete=shellcmd Man delcommand Man | runtime ftplugin/man.vim | if winwidth(0) > 170 | exe 'vert Man' <q-args> | else | exe 'Man' <q-args> | endif
    command! SW w !sudo tee % > /dev/null
endif

command! Profile profile start profile.log | profile func * | profile file *
command! -bang LProfile exe (<bang>1 ? 'lua require"plenary.profile".start("profile.log")' : 'lua require"plenary.profile".stop()')
" See also: https://github.com/stevearc/profile.nvim
" }}}
