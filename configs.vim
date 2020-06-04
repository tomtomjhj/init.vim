" vim: set foldmethod=marker foldlevel=0 nomodeline:

" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'lifepillar/vim-solarized8'
Plug 'tomtomjhj/zenbruh.vim'

" general
if !has('nvim')
    Plug 'tpope/vim-sensible'
endif
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
" TODO: easymotion `s` looks good but https://github.com/easymotion/vim-easymotion/issues/402
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdcommenter', { 'on': ['<plug>NERDCommenterComment', '<plug>NERDCommenterToggle', '<plug>NERDCommenterInsert', '<plug>NERDCommenterSexy'] }
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
" TODO: Raimondi/delimitMate?
Plug 'tomtomjhj/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment' | Plug 'michaeljsmith/vim-indent-object'
Plug 'rhysd/git-messenger.vim'
Plug 'Konfekt/FastFold'
Plug 'romainl/vim-qf'
Plug 'markonm/traces.vim'

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
" TODO: remove this
Plug 'ervandew/supertab'
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"   Plug 'ncm2/float-preview.nvim' | set completeopt-=preview
" else
"   Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc'
"   Plug 'Shougo/deoplete.nvim'
" endif
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" augroup Completions | au!
"   au InsertEnter * call deoplete#enable() | au! Completions
" augroup END

" lanauges
Plug 'dense-analysis/ale'
" TODO: sometimes node remains alive even after exiting
Plug 'neoclide/coc.nvim', { 'branch': 'release' } | Plug 'neoclide/jsonc.vim'
Plug 'tomtomjhj/vim-markdown'
let g:pandoc#filetypes#pandoc_markdown = 0 | Plug 'vim-pandoc/vim-pandoc'
Plug 'tomtomjhj/vim-pandoc-syntax'
Plug 'rust-lang/rust.vim' | Plug 'tomtomjhj/vim-rust-syntax-ext'
Plug 'tomtomjhj/vim-ocaml'
Plug 'tomtomjhj/haskell-vim', { 'branch': 'custom' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
" Plug 'Shougo/deoplete-clangx'
" Plug 'parsonsmatt/intero-neovim'
" Plug 'tomlion/vim-solidity'
" Plug 'LumaKernel/coqpit.vim'
" Plug 'https://framagit.org/tyreunom/coquille', { 'do': ':UpdateRemotePlugins' }
" NOTE: doesn't work in nvim, not async
Plug 'let-def/vimbufsync' | Plug 'whonore/Coqtail' | let g:coqtail_nomap = 1
" Plug 'puremourning/vimspector'
Plug 'cespare/vim-toml'
Plug 'rhysd/vim-llvm'
Plug 'fatih/vim-go'
" Plug 'rhysd/vim-grammarous', { 'for': ['markdown', 'tex'] }

call plug#end()
" }}}

" Basic {{{
set mouse=a
set number ruler cursorline
set foldcolumn=1 foldnestmax=5
set scrolloff=2
set showtabline=1
set laststatus=2

set tabstop=4 shiftwidth=4
set expandtab smarttab
set autoindent smartindent
" TODO: insert indents at InsertEnter or emacs-like tab

" indent the wrapped line, w/ `> ` at the start
set wrap linebreak breakindent showbreak=>\ 
set backspace=eol,start,indent
set whichwrap+=<,>,[,],h,l

let mapleader = ","
set timeoutlen=432
set updatetime=1234

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
set shortmess+=c

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
    au FileType json call SetupCoc()
    au BufRead,BufNewFile *.k set filetype=k
    au BufRead,BufNewFile *.mir set filetype=rust
    au FileType lisp if !exists('b:AutoPairs') | let b:AutoPairs = AutoPairsDefine({}, ["'"]) | endif
    au FileType help nnoremap <silent><buffer> <M-.> :h <C-r><C-w><CR>
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
      \             ['git', 'readonly', 'shortrelpath', 'modified'] ],
      \   'right': [ ['lineinfo'], ['percent'], ['coc', 'ale_checking', 'ale_errors', 'ale_warnings'], ['asyncrun'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'shortrelpath': '%{pathshorten(fnamemodify(expand("%"), ":~:."))}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'git': '%{GitStatusline()}',
      \   'asyncrun': '%{g:asyncrun_status}',
      \ },
      \ 'component_function': {
      \   'coc': 'coc#status'
      \ },
      \ 'component_expand': {
      \  'ale_checking': 'lightline#ale#checking',
      \  'ale_warnings': 'lightline#ale#warnings',
      \  'ale_errors': 'lightline#ale#errors',
      \  'ale_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type': {
      \     'ale_checking': 'left',
      \     'ale_warnings': 'warning',
      \     'ale_errors': 'error',
      \     'ale_ok': 'left',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }
" `vil() { nvim "$@" --cmd 'set background=light'; }` for light theme
if exists('g:colors_name') " loading the color again breaks lightline
elseif &background == 'dark' || !has('nvim')
    colorscheme zenbruh
else
    let g:solarized_enable_extra_hi_groups = 1
    let g:solarized_italics = 0
    set termguicolors
    colorscheme solarized8_high
    hi Special guifg=#735050 | hi Conceal guifg=#735050
    hi Statement gui=bold
    let g:lightline.colorscheme = 'solarized'
    " TODO: fzf/bat themes
endif
" }}}

" Completion {{{
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

" let g:deoplete#enable_at_startup = 0
" call deoplete#custom#source('around', 'min_pattern_length', 1)
" call deoplete#custom#source('ale', { 'max_info_width': 0, 'max_menu_width': 0 })
" call deoplete#custom#var('omni', 'input_patterns', { 'tex': g:vimtex#re#deoplete })
" call deoplete#custom#var('around', { 'mark_above': '[↑]', 'mark_below': '[↓]', 'mark_changes': '[*]' })
" let g:float_preview#winhl = 'Normal:NormalFloat,NormalNC:NormalFloat'

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE, LSP, ... global settings {{{
let g:ale_linters = {
            \ 'rust': ['rls'],
            \ }
let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'python': ['yapf'],
            \ 'haskell': ['stylish-haskell'],
            \ 'rust': ['rustfmt'],
            \ 'ocaml': ['ocamlformat'],
            \ '*': ['trim_whitespace']
            \ }
let g:ale_set_highlights = 1
let g:ale_linters_explicit = 1

let g:coc_config_home = '~/.vim'
" TODO: per-filetype source priority? lower ultisnips in .md
let g:coc_global_extensions = ['coc-vimlsp', 'coc-ultisnips', 'coc-json', 'coc-rust-analyzer', 'coc-python', 'coc-texlab', 'coc-word', 'coc-tag']
" NOTE: stuff highlighted as Normal -> bg doesn't match in floatwin
hi! link CocWarningHighlight NONE
hi! link CocInfoHighlight    NONE
hi! link CocHintHighlight    NONE
hi! link CocErrorSign   ALEErrorSign
hi! link CocWarningSign ALEWarningSign
hi! link CocInfoSign    ALEInfoSign
hi! link CocHintSign    ALEInfoSign
hi! CocRustChainingHint ctermfg=Grey guifg=#999999
hi! link CocErrorFloat   NONE
hi! link CocWarningFloat CocErrorFloat
hi! link CocInfoFloat    CocErrorFloat
hi! link CocHintFloat    CocErrorFloat

" NOTE: <M- maps are broken in vim
nmap <leader>fm <Plug>(ale_fix)
nmap <leader>ad <Plug>(ale_detail)<C-W>p
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)
noremap  <M-.> K
noremap  <M-]> <C-]>
nnoremap <M-o> <C-o>
nnoremap <M-i> <C-i>
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
" }}}

" Rust {{{
" TODO: rust symbol prettyfier: ${GT,LT,C,u20,u7b,u7d}$
let g:rust_fold = 1
let g:rust_keep_autopairs_default = 1
if executable('rust-analyzer')
    let g:ale_rust_rls_config = { 'rust': { 'racer_completion': v:false } }
endif
" }}}

" C,C++ {{{
" TODO: this should be based on tabstop and shiftwidth, see editorconfig doc
" let g:ale_c_clangformat_options = '-style="{BasedOnStyle: llvm, IndentWidth: 4, AccessModifierOffset: -4}"'
augroup SetupCCpp | au!
    au FileType c,cpp call SetupCoc()
    au FileType c,cpp setl tabstop=2 shiftwidth=2
    au FileType c,cpp nmap <buffer>zM :set foldmethod=syntax foldlevel=99\|unmap <lt>buffer>zM<CR>zM
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
augroup SetupPython | au!
    au FileType python call SetupCoc()
augroup END
" }}}

" Markdown, Pandoc, Tex {{{
let g:tex_flavor = "latex"
let g:tex_noindent_env = '\v\w+.?'
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "hypertext"]
let g:pandoc#folding#level = 99
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
let g:vimtex_fold_enabled = 1
" TODO: don't fold embedded code. something enables folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_frontmatter = 1
func! Zathura(file, ...)
    if get(a:, 1, 1)
        call jobstart(['zathura', a:file, '--fork'])
    endif
endfunc
" }}}

" ocaml {{{
let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'
let g:ocaml_highlight_operators = 1
" }}}

" go {{{
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_fold_enable = ['block']
augroup SetupGo | au!
    au FileType go call SetupCoc()
    au FileType go nmap <buffer>zM :set foldmethod=syntax foldlevel=99\|unmap <lt>buffer>zM<CR>zM
augroup END
" }}}

" search & fzf {{{
" search_mode: which command last set @/?
" `*`, `v_*` without moving the cursor. Reserve @c for the raw original text
" NOTE: Can't repeat properly if ins-special-special is used. Use q-recording.
" -> wrapper for qrcgn...q ?
nnoremap <silent>* :call Star(0)\|set hlsearch<CR>
nnoremap <silent>g* :call Star(1)\|set hlsearch<CR>
vnoremap <silent>* :<C-u>call VisualStar(0)\|set hlsearch<CR>
vnoremap <silent>g* :<C-u>call VisualStar(1)\|set hlsearch<CR>
" set hlsearch inside the function doesn't work? Maybe :h function-search-undo?
" NOTE: word boundary is syntax property -> may not match in other ft buffers
func! Star(g)
    let g:search_mode = 'n'
    let @c = expand('<cword>')
    let @/ = a:g ? @c : '\<' . @c . '\>'
endfunc
func! VisualStar(g)
    let g:search_mode = 'v'
    let l:reg_save = @"
    exec "norm! gvy"
    let @c = @"
    let l:pattern = escape(@", '\.*$^~[]')
    let @/ = a:g ? '\<' . l:pattern . '\>' : l:pattern " reversed
    let @" = l:reg_save
endfunc
nnoremap / :let g:search_mode='/'<CR>/

let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top', 'highlight': 'VertSplit' } }
let g:fzf_preview_window = 'right:50%'

" TODO: start from Grepf and switch to Grep
" TODO: context search: context format is different, format parsing is done by preview.sh
" TODO: vmap using range. BLines?
nnoremap <C-g>      :<C-u>Grep<space>
nnoremap <leader>g/ :<C-u>Grep <C-r>=RgInput(@/)<CR>
nnoremap <leader>gw :<C-u>Grep \b<C-r><C-w>\b
nnoremap <leader>gf :<C-u>Grepf<space>
nnoremap <leader>b  :<C-u>Buffers<CR>
nnoremap <C-f>      :<C-u>Files<CR>
nnoremap <leader>hh :<C-u>History<CR>
" tag with fzf. TODO preview. (preview: <c-w>}). <C-w>] is affected by switchbuf
nnoremap <leader><C-t> :Tags ^<C-r><C-w>\  <CR>

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
" allow search on the full tag info, excluding the appended tagfile name
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, { 'options': ['-d', '\t', '--nth', '..-2'] })

func! FzfOpts(arg, spec)
    " TODO: ask the directory to run (double 3)
    let l:opts = string(a:arg)
    " Preview on right if ¬fullscreen & wide
    " fullscreen
    if l:opts =~ '2'
        let a:spec['window'] = { 'width': 1, 'height': (&lines-(tabpagenr()>1)-1.0)/&lines, 'yoffset': 1, 'border': 'top', 'highlight': 'VertSplit' }
        let l:preview_window = 'up'
    else
        let l:preview_window = IsVimWide() ? 'right' : 'up'
    endif
    " from project root
    if l:opts =~ '3'
        let a:spec['dir'] = asyncrun#get_root("%")
    endif
    return fzf#vim#with_preview(a:spec, l:preview_window)
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
" NOTE: -U (multiline): \s includes \n.
let g:rg_cmd_base = 'rg --column --line-number --no-heading --color=always --colors path:fg:218 --colors match:fg:116 --smart-case '
func! Ripgrep(query)
    let cmd = g:rg_cmd_base . shellescape(a:query)
    let spec = FzfOpts(v:count, {'options': ['--info=inline']})
    call fzf#vim#grep(cmd, 1, spec)
endfunc
func! RipgrepFly(query)
    let command_fmt = g:rg_cmd_base . '-- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = FzfOpts(v:count, {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--info=inline']})
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

" }}}

" Motion, insert mode, ... {{{
" just set nowrap instead of explicit linewise ops
noremap j gj
noremap k gk
noremap <S-j> gj
noremap <S-k> gk
noremap <S-h> h
noremap <S-l> l
noremap <leader>J J
" tip: zL, zH

" space to navigate
nnoremap <space> <C-d>
nnoremap <c-space> <C-u>
" <s-space> does not work

nnoremap <M-0> ^w
vnoremap <M-0> ^w

" NOTE: vertical scope, label_esc
let g:sneak#s_next = 1
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi! Sneak guifg=black guibg=#afff00 gui=bold ctermfg=black ctermbg=154 cterm=bold

" TODO: (speicial char -> non-blank, non-keyword), user-defined (paren -> pair?)
" s-word: (a keyword | repetition of non-paren speicial char | a paren | whitespace)
let g:sword = '\v(\k+|([^[:alnum:]_[:blank:](){}[\]<>$])\2*|[(){}[\]<>$]|\s+)'

" Jump past a sword. Assumes `set whichwrap+=]` for i_<Right>
inoremap <silent><C-j> <C-\><C-O>:call SwordJumpRight()<CR><Right><C-\><C-o><ESC>
inoremap <silent><C-k> <C-\><C-O>:call SwordJumpLeft()<CR>
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

inoremap <CR> <C-G>u<CR>
inoremap <C-u> <C-\><C-o><ESC><C-g>u<C-u>
" Delete a single character of other non-blank chars
" TODO: delete sword
inoremap <silent><expr><C-w> FineGrainedICtrlW()
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
        let l:sts = &softtabstop
        setlocal softtabstop=0
        return repeat("\<BS>", l:idx) . "\<C-R>=execute('setl sts=".l:sts."')\<CR>\<BS>"
    " TODO: [paren] only
    elseif l:chars[-1] !~ '\k'
        return "\<BS>"
    else
        return "\<C-\>\<C-o>\<ESC>\<C-w>"
    endif
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
" TODO: make spc ignore "..."
map <leader>sc :if &spc == "" \| setl spc< \| else \| setl spc= \| endif \| setl spc?<CR>
map <leader>pp :setlocal paste!\|setlocal paste?<cr>
map <leader>sw :set wrap!\|set wrap?<CR>
map <leader>ic :set ignorecase! smartcase!\|set ignorecase?<CR>

map <leader>dp :diffput<CR>
map <leader>do :diffget<CR>

" clipboard.
inoremap <C-v> <C-\><C-o>:setl paste<CR><C-r>+<C-\><C-o>:setl nopaste<CR>
vnoremap <C-c> "+y

" buf/filename
noremap <leader>fn 2<C-g>

noremap <F1> <Esc>
inoremap <F1> <Esc>
noremap! <C-q> <C-c>
vnoremap <C-q> <Esc>

cnoremap <M-p> <Up>
cnoremap <M-n> <Down>

" c_CTRL-F: editable cmd/search history, gQ: enter ex mode, Q instead of q for macros
noremap q: :
noremap q <nop>
noremap Q q

" delete without clearing regs
noremap x "_x

" repetitive pastes using designated register @p
noremap <M-y> "py
noremap <M-p> "pp

nnoremap Y y$
onoremap <silent> ge :execute "normal! " . v:count1 . "ge<space>"<cr>
nnoremap <silent> & :&&<cr>
xnoremap <silent> & :&&<cr>

" set nrformats+=alpha
noremap + <C-a>
vnoremap + g<C-a>
noremap - <C-x>
vnoremap - g<C-x>

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

" quickfix, loclist, ... {{{
" TODO: manually adding lines to qf?
let g:qf_window_bottom = 0
let g:qf_loclist_window_bottom = 0
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
let g:qf_auto_resize = 0
let g:qf_max_height = 12
let g:qf_auto_quit = 0

command! CW
            \ if IsWinWide() |
            \   exec 'vert copen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p |
            \ else |
            \   belowright copen 12 | winc p |
            \ endif
command! LW
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
" }}}

" etc plugin settings {{{
let g:NERDTreeWinPos = "right"
nmap <leader>nn :NERDTreeToggle<cr>
nmap <leader>nf :NERDTreeFind<cr>

let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']

let g:mkdp_auto_close = 0
let g:mkdp_preview_options = {
            \ 'mkit': { 'typographer': v:false },
            \ 'disable_sync_scroll': 1 }
" }}}

func! SynStackName()
    return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <leader>st :echo SynStackName()<CR>
func! InSynStack(type)
    for i in synstack(line('.'), col('.'))
        if synIDattr(i, 'name') =~ a:type
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

let s:url_regex = '\c\<\(\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)\)'
call textobj#user#plugin('url', { 'url': { 'pattern': s:url_regex, 'select': ['au', 'iu'] } })
call textobj#user#plugin('path', { 'path': { 'pattern': '\f\+', 'select': ['aP', 'iP'] } })
" see :help [range], &, g&
" :%s/pat/\r&/g.
" marks
" }}}

" Comments {{{
let g:NERDCreateDefaultMappings = 0
imap <M-/> <Plug>NERDCommenterInsert
map <M-/> <Plug>NERDCommenterComment
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
" }}}
