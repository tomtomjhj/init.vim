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
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug '~/.vim/my_plugins/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment'

" completion
Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim',
            \ { 'do': ':UpdateRemotePlugins', 'on': [] }
" if !has('nvim') | Plug 'roxma/nvim-yarp' | Plug 'roxma/vim-hug-neovim-rpc' | endif
Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'
augroup Completions
  au!
  au InsertEnter * call plug#load('ultisnips') | call plug#load('deoplete.nvim')
              \ | au! Completions
augroup END

" lanauges
Plug 'dense-analysis/ale'
Plug '~/.vim/my_plugins/vim-pandoc-syntax' | Plug 'vim-pandoc/vim-pandoc'
Plug '~/.vim/my_plugins/tex-conceal.vim'
Plug '~/.vim/my_plugins/rust.vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug '~/.vim/my_plugins/vim-ocaml'
Plug '~/.vim/my_plugins/haskell-vim'
" Plug 'parsonsmatt/intero-neovim'
" Plug 'tomlion/vim-solidity'

call plug#end()
" }}}

" Basic {{{
set mouse=a
set number | set ruler
set foldcolumn=1
set scrolloff=2
set showtabline=1

set tabstop=4 | set shiftwidth=4
set expandtab | set smarttab
set autoindent | set smartindent

" indent the wrapped line, w/ `> ` at the start
set wrap | set linebreak | set breakindent | set showbreak=>\ 
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

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
set ignorecase | set smartcase
set hlsearch | set incsearch

set noerrorbells | set novisualbell | set t_vb=

set nobackup | set nowritebackup | set noswapfile
set undofile | set undodir=~/.vim/undodir

set autoread
set switchbuf=useopen,usetab,newtab
set hidden
set lazyredraw
" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
set history=500
autocmd! BufWritePost ~/.vim/configs.vim source ~/.vim/configs.vim

set exrc | set secure

au BufRead,BufNewFile *.k set filetype=k
au BufRead,BufNewFile *.v set filetype=coq
au BufRead,BufNewFile *.ll set filetype=llvm
au BufRead,BufNewFile *.mir set filetype=rust

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
" `vil() { nvim "$@" --cmd 'set background=light' }` for light theme
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
" TODO: Use context stuff to let supertab use <c-p> when deoplete isn't the
" one who filled up the completion list.
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabClosePreviewOnPopupClose = 1

let g:deoplete#enable_at_startup = 1

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE general settings {{{
let g:ale_linters = {
            \ 'c': ['clang'],
            \ 'cpp': ['clang'],
            \ 'python': ['pylint'],
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

nmap <leader>ad <Plug>(ale_detail)
nmap <leader>af <Plug>(ale_fix)
" TODO: check https://github.com/dense-analysis/ale/issues/2317
nmap <leader>ah <Plug>(ale_hover)
nmap <C-[> <Plug>(ale_hover)
nmap <leader>aj <Plug>(ale_go_to_definition)
nmap <leader>an :ALERename<CR>
nmap <leader>at <Plug>(ale_toggle)
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

au FileType haskell setlocal shiftwidth=2 tabstop=2
au FileType yaml setlocal shiftwidth=2 tabstop=2

let g:intero_start_immediately = 0
if has('nvim')
  augroup interoMaps
    au!
    au FileType haskell call SetupIntero()
  augroup END
endif
func! SetupIntero()
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
au FileType rust nmap <buffer><C-]> <Plug>(ale_go_to_definition)
au FileType rust nmap <buffer><silent><C-\> :tab split<CR><Plug>(ale_go_to_definition)
au FileType rust nmap <leader>C :silent make! check<CR><leader>cv
" NOTE: External crate completion does't work without extern crate declaration
" }}}

" C,C++ {{{
" TODO: this should be based on tabstop and shiftwidth, see editorconfig doc
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: llvm, IndentWidth: 4, AccessModifierOffset: -4}"'
" }}}

" Python {{{
" this disables any other checks. but works when used from cmd.??????????
" -> just add `# type: ignore` annotation after the import stmt
" let g:ale_python_mypy_options = "-ignore-missing-imports"
let g:ale_python_mypy_options = "--check-untyped-defs"
let g:ale_python_pylint_options = "--disable=R,C,W0614,W0621"
" }}}

" Pandoc, Tex {{{
let g:tex_flavor = "latex"
let g:tex_noindent_env = '\v\w+.?'
au FileType tex setlocal conceallevel=2
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "keyboard", "toc", "spell", "hypertext"]
let g:pandoc#formatting#twxtwidth = 80
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
augroup Pandocs
    au!
    au FileType pandoc call SetupPandoc()
augroup END
func! SetupPandoc()
    let b:AutoPairs = AutoPairsDefine({'$':'$', '$$':'$$'})
    " set to notoplevel in haskell.vim
    call textobj#user#plugin('pandoc', s:pandoc_textobj)
    syntax spell toplevel
    nmap <buffer><silent><leader>pd :call RunPandoc(0)<CR>
    nmap <buffer><silent><leader>po :call RunPandoc(1)<CR>
    nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
    nmap <buffer><silent><leader>py vid<leader>R python3<CR><leader>cv
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
        au QuickFixCmdPost caddexpr botright copen 8 | winc p
    augroup END
    exe 'AsyncRun -save=1 -cwd=' . expand("%:p:h") '-post=' . l:post l:cmd
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

" TODO: move the functions to autoload
func! FencedCodeBlocka()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    normal! E
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! FencedCodeBlocki()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    normal! W
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    normal! b
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! InSynStack(type)
    let stack = synstack(line('.'), col('.'))
    for i in stack
        let name = synIDattr(i, 'name')
        if name == a:type
            return 1
        endif
    endfor
    return 0
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
    normal! l
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    normal! h
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
    normal! l
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! DollarMathMathi()
    if !InSynStack('pandocLaTeXMathBlock')
        return 0
    endif
    if !search('\v\$\$', 'bW') | return 0 | endif
    normal! l
    call search('\v\S', 'W')
    let head_pos = getpos('.')
    if !search('\v\$\$', 'W')  | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc

" TODO: `gq` wrt bullet points gets broken after some operations
" ``` pair <CR> automatically indents the whole body after some operations
" }}}

" Motion {{{
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
vnoremap <silent>* :<C-u>call Searchgv()\|set hlsearch<CR>
func! Searchgv()
    let l:saved_reg = @"
    execute "normal! gvy"
    let l:pattern = escape(@", "\\/.*'$^~[]")
    let @/ = l:pattern
    let @" = l:saved_reg
endfunc

let g:sneak#s_next = 1
let g:sneak#absolute_dir = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi Sneak guifg=black guibg=#afff00 ctermfg=black ctermbg=154

" shortcut jumps inspired by snippets and auto-pairs
let g:pair_opener = '\v("|\[|''|\(|\{|\$)'
let g:pair_closer = '\v("|\]|''|\)|\}|\$)'
let g:shortcut_jump_target = g:pair_closer
inoremap <silent> <C-j> <C-\><C-O>:call search(g:shortcut_jump_target, 'ceW')<CR><Right>
inoremap <silent> <C-k> <C-\><C-O>:call search(g:shortcut_jump_target, 'bW')<CR>
map <silent> ]j :call search(g:shortcut_jump_target,'W')<CR>
map <silent> [j :call search(g:shortcut_jump_target,'bW')<CR>
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
    exec 'normal!' l:cmd
    " TODO: v_gN behaves differently after vim-patch 8.1.0629
    if l:on_right == l:flipped
        exec 'normal! h'
    endif
    let &wrapscan = l:wrapscan
    let @/ = l:saved_reg
endfunc
func! SearchPosLE(p1, p2)
    return a:p1[0] < a:p2[0] || (a:p1[0] == a:p2[0] && a:p1[1] <= a:p2[1])
endfunc
" remap digraph
inoremap <C-space> <C-k>
" }}}

" etc {{{
map <silent><leader><cr> :noh<cr>
map <leader>ss :setlocal spell!<cr>
map <leader>pp :setlocal paste!<cr>
map <leader>sw :set wrap<CR>
map <leader>snw :set nowrap<CR>

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
" TODO: motion-parametrized wrapping
let g:AutoPairsMapSpace = 0
let g:AutoPairsCenterLine = 0
let g:AutoPairsMapCh = 0
let g:AutoPairsShortcutFastWrap = '<M-w>'
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''

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

" asyncrun
map <leader>R :AsyncRun<space>
map <leader>S :AsyncStop<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
map <leader>M :Make<space>

" quickfix, loclist, ...
map <leader>co :copen 12\| winc p<CR>
map <leader>cv :vert copen <C-R>=min([&columns-112,&columns/2])<CR>\|setlocal nowrap\|winc p<CR>
map ]q :cn<CR>
map [q :cN<CR>
map ]l :lne<CR>
map [l :lN<CR>
map <silent><leader>x :pc\|ccl\|lcl<CR>

let g:NERDTreeWinPos = "right"
nmap <leader>nn :NERDTreeToggle<cr>

let g:gitgutter_enabled=0
nmap <silent><leader>gg :GitGutterToggle<cr>

" https://github.com/tpope/vim-surround/issues/55#issuecomment-4610756
" vim-exchange, yankstack, vim-abolish
" see :help [range], &, g&
" :%s/pat/\r&/g.
" marks
" }}}

" tags {{{
" TODO: CTRL-W commands
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
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

map <leader>q :q<CR>
map q, :q<CR>
nmap <leader>w :w!<cr>
command! -bang W w
command! -bang Q q
command! -bang Wq wq
command! -bang Wqa wqa
command! -bang Qa qa

map <leader>cx :tabclose<cr>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
map <leader>td :tab split<CR>
map <leader>tt :tabedit<CR>
map <leader>cd :cd %:p:h<cr>:pwd<cr>
map <leader>e :e! <c-r>=expand("%:p:h")<cr>/
map <leader>ef :e!<CR>
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

set splitright
set splitbelow

" I think it's more natural to return to the 'left' tab
" this breaks `:tabonly`.
" TODO: chrome-style return to last tab
au TabClosed * if g:lasttab > 1
  \ | exe "tabn ".(g:lasttab-1)
  \ | endif

" ctrl-shift-t of chrome
" TODO: debug(non-existent buf), save filenames when :qa'd and restore
map <silent><leader><C-t> :call PopQuitBufs()<CR>
" works only for buffers of windows closed by :q, not :tabc
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

" Garbage buffers
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

" }}}
