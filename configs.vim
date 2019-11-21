" vim: set foldmethod=marker foldlevel=0 nomodeline:

" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug '~/.vim/my_plugins/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'lifepillar/vim-solarized8'

" general
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterToggle' }
Plug 'scrooloose/nerdcommenter', { 'on': ['<plug>NERDCommenterToggle', '<plug>NERDCommenterSexy'] }
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug '~/.vim/my_plugins/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment'
Plug 'rhysd/git-messenger.vim'
Plug 'Konfekt/FastFold'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
augroup SetupNerdTree
    au!
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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" if !has('nvim') | Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc' | endif
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

augroup Completions
  au!
  au InsertEnter * call deoplete#enable() | au! Completions
augroup END

" lanauges
Plug 'dense-analysis/ale'
Plug '~/.vim/my_plugins/vim-pandoc-syntax' | Plug 'vim-pandoc/vim-pandoc'
Plug '~/.vim/my_plugins/tex-conceal.vim'
Plug 'rust-lang/rust.vim'
Plug '~/.vim/my_plugins/vim-ocaml'
Plug '~/.vim/my_plugins/haskell-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" Plug 'parsonsmatt/intero-neovim'
" Plug 'tomlion/vim-solidity'

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
set timeoutlen=400

let $LANG='en'
set langmenu=en
set encoding=utf8
set spellfile=~/.vim/spell/en.utf-8.add

set wildmenu
set wildignore=*.o,*~,*.pyc,*.pdf,*.v.d,*.vo,*.glob
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

set magic
set ignorecase smartcase
set hlsearch incsearch

set noerrorbells novisualbell t_vb=

set nobackup nowritebackup noswapfile
set undofile undodir=~/.vim/undodir
set history=500

set autoread
set switchbuf=useopen,usetab,newtab
set hidden
set lazyredraw

set exrc secure

augroup BasicSetup
    au!
    " Return to last edit position when opening files
    au BufWinEnter * if line("'\"") > 1 && line("'\"") <= line("$") | exec "norm! g'\"" | endif
    au BufWritePost ~/.vim/configs.vim source ~/.vim/configs.vim
    au BufRead,BufNewFile *.k set filetype=k
    au BufRead,BufNewFile *.v set filetype=coq
    au BufRead,BufNewFile *.ll set filetype=llvm
    au BufRead,BufNewFile *.mir set filetype=rust
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
if &background == 'dark'
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
" TODO:
" * deoplete + completeopt+=longest
" * add menu content at the top of the preview info

let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

let g:deoplete#enable_at_startup = 0
call deoplete#custom#source('around', 'min_pattern_length', 1)
call deoplete#custom#source('ale', { 'max_info_width': 0, 'max_menu_width': 0 })
call deoplete#custom#var('around', { 'mark_above': '[↑]', 'mark_below': '[↓]', 'mark_changes': '[*]' })

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE general settings {{{
let g:ale_linters = {
            \ 'c': ['clang'],
            \ 'cpp': ['clang'],
            \ 'python': ['pyls'],
            \ 'rust': ['rls'],
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
hi ALEError term=underline cterm=underline gui=undercurl
hi ALEWarning term=NONE cterm=NONE gui=NONE
hi ALEInfo term=NONE cterm=NONE gui=NONE

nmap <leader>ad <Plug>(ale_detail)<C-W>p
nmap <leader>af <Plug>(ale_fix)
" TODO: check https://github.com/dense-analysis/ale/issues/2317
nmap <leader>ah <Plug>(ale_hover)
" Can't distinguish <ESC> and <C-[> in terminal.
nmap <M-[> <Plug>(ale_hover)
nmap <M-]> <Plug>(ale_go_to_definition)
nmap <silent><M-\> :tab split<CR><Plug>(ale_go_to_definition)
nmap <silent><leader><M-\> :vsp<CR><Plug>(ale_go_to_definition)
nmap <leader>aj <Plug>(ale_go_to_definition)
nmap <leader>an :ALERename<CR>
nmap <leader>ar <Plug>(ale_find_references)
nmap ]a <Plug>(ale_next_wrap)
nmap ]A <Plug>(ale_next_wrap_error)
nmap [a <Plug>(ale_previous_wrap)
nmap [A <Plug>(ale_prevous_wrap_error)
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
augroup SetupHaskell
    au!
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
let g:rust_fold = 1
let g:rust_keep_autopairs_default = 1
augroup SetupRust
    au!
    au FileType rust nmap <buffer><leader>C :AsyncRun -program=make -cwd=%:p:h -post=OQ check<CR>
    au FileType rust vmap <buffer><leader>af :RustFmtRange<CR>
    au FileType rust if !exists('b:AutoPairs') | let b:AutoPairs = AutoPairsDefine({}, ["'"]) | endif
augroup END
" NOTE: External crate completion doesn't work without extern crate declaration
" }}}

" C,C++ {{{
" TODO: this should be based on tabstop and shiftwidth, see editorconfig doc
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: llvm, IndentWidth: 4, AccessModifierOffset: -4}"'
augroup SetupCCpp
    au!
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
            \     'preload': { 'enabled': v:false },
            \     'pycodestyle': { 'enabled': v:false },
            \     'pydocstyle': { 'enabled': v:false },
            \     'pyflakes': { 'enabled': v:false },
            \     'pylint': { 'args': ['-dR', '-dC', '-dW0614', '-dW0621'] },
            \     'yapf': { 'enabled': v:false },
            \   }
            \ }
            \}
" }}}

" Pandoc, Tex {{{
let g:tex_flavor = "latex"
let g:tex_noindent_env = '\v\w+.?'
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "keyboard", "toc", "spell", "hypertext"]
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
augroup SetupPandocTex
    au!
    au FileType pandoc call SetupPandoc()
    au FileType tex setlocal conceallevel=2
augroup END
func! SetupPandoc()
    let b:AutoPairs = AutoPairsDefine({'$':'$', '$$':'$$'})
    " set to notoplevel in haskell.vim
    call textobj#user#plugin('pandoc', s:pandoc_textobj)
    syntax spell toplevel
    nmap <buffer><silent><leader>pd :call RunPandoc(0)<CR>
    nmap <buffer><silent><leader>po :call RunPandoc(1)<CR>
    nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    nmap <buffer><silent><leader>py vid:AsyncRun python3<CR>:OQ<CR>
endfunc
func! RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    let params = '-Vurlcolor=cyan --highlight-style=kate'
    let post = "exec 'au! pandoc_quickfix'"
    let post .= a:open ? "|call Zathura('" . l:out . "',!g:asyncrun_code)" : ''
    let post = escape(post, ' ')
    " set manually or by local vimrc, override header-includes in yaml metadata
    if exists('b:custom_pandoc_include_file')
        let l:params .= ' --include-in-header=' . b:custom_pandoc_include_file
    endif
    let cmd = 'pandoc ' . l:src . ' -o ' . l:out . ' ' . l:params
    augroup pandoc_quickfix
        au!
        au QuickFixCmdPost caddexpr belowright copen 8 | winc p
    augroup END
    exec 'AsyncRun -save=1 -cwd=' . expand("%:p:h") '-post=' . l:post l:cmd
endfunc
func! Zathura(file, ...)
    let check = get(a:, 1, 1)
    if l:check
        call jobstart(['zathura', a:file, '--fork'])
    endif
endfunc

let s:pandoc_textobj = {
            \   'begin-end': {
            \     'pattern': ['\\begin{[^}]\+}\s*\n\?', '\s*\\end{[^}]\+}'],
            \     'select-a': 'ae',
            \     'select-i': 'ie',
            \   },
            \   'code': {
            \     'select-a-function': 'FencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'FencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \  'dollar-math': {
            \     'select-a-function': 'DollarMatha',
            \     'select-a': 'am',
            \     'select-i-function': 'DollarMathi',
            \     'select-i': 'im',
            \   },
            \  'dollar-mathmath': {
            \     'select-a-function': 'DollarMathMatha',
            \     'select-a': 'aM',
            \     'select-i-function': 'DollarMathMathi',
            \     'select-i': 'iM',
            \   },
            \ }

" TODO: move the functions to autoload {{{
func! FencedCodeBlocka()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    exec 'norm! E'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! FencedCodeBlocki()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    exec 'norm! W'
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! DollarMatha()
    if !InSynStack('pandocLaTeXInlineMath')
        return 0
    endif
    if !search('\v\$', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! DollarMathi()
    if !InSynStack('pandocLaTeXInlineMath')
        return 0
    endif
    if !search('\v\$', 'bW') | return 0 | endif
    exec 'norm! l'
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    exec 'norm! h'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! DollarMathMatha()
    if !InSynStack('pandocLaTeXMathBlock')
        return 0
    endif
    if !search('\v\$\$', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('\v\$\$', 'W') | return 0 | endif
    exec 'norm! l'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! DollarMathMathi()
    if !InSynStack('pandocLaTeXMathBlock')
        return 0
    endif
    if !search('\v\$\$', 'bW') | return 0 | endif
    exec 'norm! l'
    call search('\v\S', 'W')
    let head_pos = getpos('.')
    if !search('\v\$\$', 'W')  | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
" }}}

" }}}

" search, copy, paste {{{
" repetitive pastes using designated register @p
noremap <M-y> "py
noremap <M-p> "pp

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

nnoremap <leader>rg :Rg<space>
nnoremap <leader>r/ :<C-u>Rg <C-r>=RgInput(@/)<CR>
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
" }}}

" Motion {{{
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

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi Sneak guifg=black guibg=#afff00 ctermfg=black ctermbg=154

" Jump past (a word | repetition of non-paren speicial char | a paren | whitespace)
" Assumes `set whichwrap+=]` for i_<Right>
let g:quick_jump = '\v(\w+|([^[:alnum:]_[:blank:](){}[\]<>])\2*|[(){}[\]<>]|\s+)'
inoremap <silent><C-j> <C-\><C-O>:call QuickJumpRight()<CR><Right>
inoremap <silent><C-k> <C-\><C-O>:call QuickJumpLeft()<CR>
inoremap <C-space> <C-k>
func! QuickJumpRight()
    if col('.') !=  col('$')
        call search(g:quick_jump, 'ceW')
    endif
endfunc
func! QuickJumpLeft()
    call search(col('.') != 1 ? g:quick_jump : '\v$', 'bW')
endfunc

" vim#964
inoremap <C-w> <C-\><C-o>db
inoremap <C-u> <C-\><C-o>d0

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
map <leader>pp :setlocal paste!\|setlocal paste?<cr>
map <leader>sw :set wrap!\|set wrap?<CR>

" clipboard.
if has('nvim')
  inoremap <C-v> <ESC>"+pa
  vnoremap <C-c> "+y
  vnoremap <C-x> "+d
endif

" filename
map <silent><leader>fn :echo '<C-R>=expand("%:p")<CR>'<CR>

noremap <F1> <Esc>
inoremap <F1> <Esc>

" c_CTRL-F for cmd history, gQ to enter ex mode. Q instead of q for macros
noremap q: :
noremap q <nop>
noremap Q q

" delete without clearing regs
noremap x "_x

" auto-pairs
let g:AutoPairsMapSpace = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCh = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''
inoremap <silent><M-e> <C-R>=AutoPairsFastWrap("e")<CR>
inoremap <silent><M-E> <C-R>=AutoPairsFastWrap("E")<CR>
inoremap <silent><M-$> <C-R>=AutoPairsFastWrap("$")<CR>

" fzf
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '~30%' }
map <C-b> :Buffers<CR>
map <C-f> :Files<CR>
map <leader>F :Files .
map <leader>hh :History<CR>
map <leader>h: :History:<CR>
map <leader>h/ :History/<CR>

if has("nvim")
    augroup fzf
        au!
        au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        au FileType fzf tunmap <buffer> <Esc>
    augroup END
endif

" asyncrun
map <leader>R :AsyncRun<space>
map <leader>S :AsyncStop<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
map <leader>M :Make<space>

" quickfix, loclist, ...
command! CV exec 'vert copen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p
command! CO belowright copen 12 | winc p
command! OQ if winwidth(0) > 170 | exec 'CV' | else | exec 'CO' | endif
map <leader>oq :OQ<CR>
command! LV exec 'vert lopen' min([&columns-112,&columns/2]) | setlocal nowrap | winc p
command! LO belowright lopen 12 | winc p
command! OL if winwidth(0) > 170 | exec 'LV' | else | exec 'LO' | endif
map <leader>ol :OL<CR>
map ]q :cn<CR>
map [q :cN<CR>
map ]l :lne<CR>
map [l :lN<CR>
map <silent><leader>x :pc\|ccl\|lcl<CR>

inoremap <CR> <C-G>u<CR>

let g:NERDTreeWinPos = "right"
nmap <leader>nn :NERDTreeToggle<cr>

let g:gitgutter_enabled=0
nmap <silent><leader>gg :GitGutterToggle<cr>

let g:EditorConfig_exclude_patterns = ['.*[.]git/.*']

let g:mkdp_auto_close = 0
let g:mkdp_preview_options = { 'disable_sync_scroll': 1 }

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

" see :help [range], &, g&
" :%s/pat/\r&/g.
" marks
" }}}

" tags {{{
" open tag in a new tab/vertical split
map <silent><C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <silent><leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <silent>g<Bslash> :tab split<CR>:exec("tselect ".expand("<cword>"))<CR>
map <silent><leader>g<Bslash> :vsp<CR>:exec("tselect ".expand("<cword>"))<CR>
map ]t :tn<CR>
map [t :tN<CR>
" open tag in preview window: <C-w>} and <C-w>g}
" }}}

" Comments {{{
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
" }}}

" Tabs, windows, buffers {{{
set splitright
set splitbelow

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
augroup LastTab
    au!
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
augroup RestoreTab
    au!
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
augroup GarbageBuf
    au!
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
