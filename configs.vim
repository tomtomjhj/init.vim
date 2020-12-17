" vim: set foldmethod=marker foldlevel=0 nomodeline:

let g:ide_client = get(g:, 'ide_client', 'coc')

" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'tomtomjhj/zenbruh.vim'

" editing
" TODO: |,| right after sneak aborts label mode but leave the highlight
" similar to the result of Sneak_;
Plug 'tomtomjhj/vim-sneak'
" TODO: machakann/vim-sandwich?
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tomtomjhj/pear-tree'
Plug 'andymass/vim-matchup' " i%, a%, ]%, z%, g%
Plug 'wellle/targets.vim' " multi (e.g. ib, iq), separator, argument
Plug 'kana/vim-textobj-user' | Plug 'glts/vim-textobj-comment' | Plug 'michaeljsmith/vim-indent-object'
Plug 'preservim/nerdcommenter', { 'on': '<Plug>NERDCommenter' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'AndrewRadev/splitjoin.vim'
" TODO Plug 'mg979/vim-visual-multi'

" etc
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': has('unix') ? './install --all' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'fszymanski/fzf-quickfix', { 'on': 'Quickfix' } " TODO: multi select and re-send to quickfix
Plug 'Konfekt/FastFold' " only useful for non-manual folds
Plug 'romainl/vim-qf'
Plug 'markonm/traces.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'wellle/visual-split.vim' " <C-w>g gr/gss/gsa/gsb
Plug 'andymass/vim-tradewinds' " <C-w>g h/j/k/l
" TODO Plug 'tpope/vim-obsession'
" TODO Plug 'yuki-ycino/fzf-preview.vim'
" TODO Plug 'lpinilla/vim-codepainter'
Plug 'justinmk/vim-dirvish'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } " use menu!

" lanauges
Plug 'dense-analysis/ale', { 'on': ['<Plug>(ale_', 'ALEEnable'] } ")
if g:ide_client == 'coc'
    Plug 'neoclide/coc.nvim', { 'commit': '6b3056d4' }
    " Plug '~/apps/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
    Plug 'antoinemadec/coc-fzf'
else
    " TODO: https://github.com/mg979/autocomplete-nvim?
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/lsp_extensions.nvim'
    Plug 'nvim-lua/lsp-status.nvim'
endif
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'plasticboy/vim-markdown'
let g:pandoc#filetypes#pandoc_markdown = 0 | Plug 'vim-pandoc/vim-pandoc'
Plug 'tomtomjhj/vim-pandoc-syntax'
Plug 'tomtomjhj/vim-rust-syntax-ext'| Plug 'rust-lang/rust.vim'
Plug 'tomtomjhj/vim-ocaml'
Plug 'tomtomjhj/haskell-vim', { 'branch': 'custom' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'
" Plug 'LumaKernel/coqpit.vim'
" Plug 'https://framagit.org/tyreunom/coquille', { 'do': ':UpdateRemotePlugins' }
Plug 'whonore/Coqtail' | let g:coqtail_nomap = 1
" Plug 'puremourning/vimspector' | let g:vimspector_enable_mappings = 'HUMAN'
Plug 'cespare/vim-toml'
Plug 'neoclide/jsonc.vim'
Plug 'rhysd/vim-llvm'
Plug 'fatih/vim-go', { 'do': 'rm -r plugin ftplugin \|\| true' }
Plug 'vim-python/python-syntax'
Plug 'tbastos/vim-lua' | let g:lua_syntax_noextendedstdlib = 1
" TODO: Plug 'euclidianAce/BetterLua.vim'
" Plug 'rhysd/vim-grammarous', { 'for': ['markdown', 'tex'] }

" etc etc
if has('nvim')
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    " https://github.com/wbthomason/packer.nvim
    " Plug 'nvim-lua/plenary.nvim'
    " Plug 'nvim-lua/popup.nvim'
    " Plug 'tjdevries/nlua.nvim'
    " Plug 'nvim-telescope/telescope.nvim'
    " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'mfussenegger/nvim-dap'
    " Plug 'mfussenegger/nvim-fzy'
endif

call plug#end()
" }}}

" Basic {{{
set mouse=a
set number ruler " cursorline
set foldcolumn=1 foldnestmax=5
set scrolloff=2 " sidescrolloff
set showtabline=1
set laststatus=2

set tabstop=4 shiftwidth=4
set expandtab smarttab
set autoindent " smartindent is unnecessary
" set indentkeys+=!<M-i> " doesn't work, maybe i_META? just use i_CTRL-F
set formatoptions+=n " this may interfere with 'comment'?
set formatlistpat=\\C^\\s*[\\[({]\\\?\\([0-9]\\+\\\|[iIvVxXlLcCdDmM]\\+\\\|[a-zA-Z]\\)[\\]:.)}]\\s\\+\\\|^\\s*[-+o*]\\s\\+
set nojoinspaces

" indent the wrapped line, w/ `> ` at the start
set wrap linebreak breakindent showbreak=>\ 
set backspace=eol,start,indent
set whichwrap+=<,>,[,],h,l

let mapleader = ","
set timeoutlen=987
set updatetime=1234

let $LANG='en'
set langmenu=en
set encoding=utf8
set spellfile=~/.vim/spell/en.utf-8.add
set spelllang=en,cjk

set wildmenu wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc,*.pdf,*.v.d,*.vo,*.vos,*.vok,*.glob
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

set magic
set ignorecase smartcase
set hlsearch incsearch

set noerrorbells novisualbell t_vb=
set shortmess+=c

set noswapfile " set directory=~/.vim/swap//
set backup backupdir=~/.vim/backup//
set undofile undodir=~/.vim/undo//
set history=500
if has('nvim') | set shada=!,'150,<50,s30,h | endif

set autoread
set splitright splitbelow
set switchbuf=useopen,usetab
set hidden
set lazyredraw

set exrc secure
set diffopt+=algorithm:histogram

let &pumheight = min([&window/4, 20])

augroup BasicSetup | au!
    " Return to last edit position when entering normal buffer
    " TODO: this addes jump? manually running is ok. maybe autocmd problem?
    au BufWinEnter * if empty(&buftype) && line("'\"") > 1 && line("'\"") <= line("$") | exec "norm! g`\"" | endif
    au VimEnter * exec 'tabdo windo clearjumps' | tabnext
    au BufWritePost ~/.vim/configs.vim source ~/.vim/configs.vim
    au BufRead,BufNewFile *.k set filetype=k
    au BufRead,BufNewFile *.mir set syntax=rust
    au FileType lisp let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), { "'": {'closer': ''} })
    au FileType help nnoremap <silent><buffer> <M-.> :h <C-r><C-w><CR>
    au VimResized * let &pumheight = min([&window/4, 20])
augroup END

if has('unix')
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}

" Themes {{{
" TODO: display winnr()? w:quickfix_title?
" TODO: checker_* for inactive window doesn't use the buffer of that window?
let g:lightline = {
      \ 'colorscheme': 'powerwombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['readonly', 'speicialbuf', 'shortrelpath', 'modified'],
      \             ['curr_func', 'git'] ],
      \   'right': [ ['lineinfo'], ['percent'],
      \              ['checker_errors', 'checker_warnings', 'checker_status'],
      \              ['asyncrun'] ]
      \ },
      \ 'inactive': {
      \   'left': [ ['speicialbuf', 'shortrelpath'] ],
      \   'right': [ ['lineinfo'],
      \              ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly && &filetype !=# "help" ? "🔒" : ""}',
      \   'speicialbuf': '%q%w',
      \   'modified': '%{&filetype==#"help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'asyncrun': '%{g:asyncrun_status[:3]}',
      \ },
      \ 'component_function': {
      \   'git': 'GitStatusline',
      \   'shortrelpath': 'ShortRelPath',
      \   'curr_func': 'CurrentFunction',
      \   'checker_status': 'CheckerStatus',
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
      \   'readonly': '(&filetype!=#"help"&& &readonly)',
      \   'modified': '(&filetype!=#"help"&&(&modified||!&modifiable))',
      \   'speicialbuf': '&pvw||&buftype==#"quickfix"',
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': '|', 'right': '|' },
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
func! ShortRelPath()
    let name = expand('%')
    if empty(name)
        return empty(&buftype) ? '[No Name]' : ''
    elseif isdirectory(name)
        return pathshorten(fnamemodify(name[:-2], ":~")) . '/'
    endif
    return pathshorten(fnamemodify(name, ":~:."))
endfunc
" `vil() { nvim "$@" --cmd 'set background=light'; }` for light theme
if exists('g:colors_name') " loading the color again breaks lightline
elseif &background == 'dark' || !has('nvim')
    colorscheme zenbruh
else
    " TODO: customize Search, IncSearch, MatchParen, Diff*
    let g:solarized_enable_extra_hi_groups = 1
    let g:solarized_italics = 0
    set termguicolors
    colorscheme solarized8_high
    " TODO: match fzf/bat themes
    " fix terminal window hl (set winhl=NormalFloat:TermNormal) vs. modify bat theme
    " hi TermNormal guifg=#eeeeee guibg=#1c1c1c
    hi Special guifg=#735050 | hi Conceal guifg=#735050
    hi Statement gui=bold
    let g:lightline.colorscheme = 'solarized'
endif
" }}}

" Completion {{{
if g:ide_client == 'coc'
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
else " lua
    set completeopt=menuone,noinsert,noselect
    augroup Completion | au!
        au BufEnter * lua require'completion'.on_attach()
    augroup END
    imap <tab>   <Plug>(completion_smart_tab)
    imap <s-tab> <Plug>(completion_smart_s_tab)

    let g:completion_enable_snippet = 'UltiSnips'
    let g:completion_enable_auto_paren = 1
    let g:completion_chain_complete_list = {
                \ 'default' : [
                \    {'complete_items': ['lsp', 'UltiSnips', 'buffers']},
                \ ],
                \}
    let g:completion_timer_cycle = 234
    let g:completion_word_min_length = 2
    let g:completion_auto_change_source = 1
    let g:completion_matching_strategy_list = ['exact', 'fuzzy']
    let g:completion_confirm_key = "\<C-y>"
endif

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE, LSP, ... global settings {{{
let g:ale_linters = {}
let g:ale_fixers = {
            \ 'c': ['clang-format'],
            \ 'cpp': ['clang-format'],
            \ 'python': ['yapf'],
            \ 'ocaml': ['ocamlformat'],
            \ 'go': ['gofmt'],
            \ '*': ['trim_whitespace']
            \ }
let g:ale_set_highlights = 1
let g:ale_linters_explicit = 1

let g:coc_config_home = '~/.vim'
if has('win') | let g:coc_node_path = 'node.exe' | endif
let g:coc_global_extensions = ['coc-vimlsp', 'coc-ultisnips', 'coc-json', 'coc-rust-analyzer', 'coc-python', 'coc-texlab', 'coc-word', 'coc-tag']
let g:coc_quickfix_open_command = 'CW'
let g:coc_fzf_preview = 'up:66%'

hi! link CocWarningHighlight NONE
hi! link CocInfoHighlight    NONE
hi! link CocHintHighlight    NONE
hi! link CocErrorSign   ALEErrorSign
hi! link CocWarningSign ALEWarningSign
hi! link CocInfoSign    ALEInfoSign
hi! link CocHintSign    ALEInfoSign
hi! link CocErrorFloat   NONE
hi! link CocWarningFloat CocErrorFloat
hi! link CocInfoFloat    CocErrorFloat
hi! link CocHintFloat    CocErrorFloat
hi! link CocRustTypeHint TypeHint
hi! link CocRustChainingHint TypeHint

" TODO: where to put this
hi! TypeHint ctermfg=Grey guifg=#999999

nmap <leader>fm <Plug>(ale_fix)
nmap <M-,> <Plug>(ale_detail)<C-W>p
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)
noremap  <M-.> K
noremap  <M-]> <C-]>
nnoremap <M-o> <C-o>
nnoremap <M-i> <C-i>
" }}}

" Languages {{{
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
    au FileType haskell setl tabstop=2 shiftwidth=2
augroup END
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
" }}}

" C,C++ {{{
augroup SetupCCpp | au!
    au FileType c,cpp call SetupLSP()
    au FileType c,cpp setl tabstop=2 shiftwidth=2
augroup END
" }}}

" Python {{{
let g:python_highlight_all = 1
let g:python_highlight_builtin_funcs = 0
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
    au FileType python call SetupLSP()
augroup END
" }}}

" Markdown, Pandoc, Tex {{{
let g:tex_flavor = "latex"
let g:tex_noindent_env = '\v\w+.?'
let g:pandoc#syntax#codeblocks#embeds#langs = ["python", "cpp", "rust"]
let g:pandoc#modules#enabled = ["formatting", "hypertext", "yaml"]
" Surround triggers equalprg (pandoc -t markdown), which modifies the text a lot
let g:pandoc#formatting#equalprg = ''
let g:pandoc#folding#level = 99
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#syntax#use_definition_lists = 0
let g:pandoc#syntax#protect#codeblocks = 0
let g:vimtex_fold_enabled = 1
let g:vim_markdown_folding_disabled = 1 " manually control folds: see ftplugin/markdown.vim
let g:vim_markdown_folding_level = 6
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_no_default_key_mappings = 1
" let g:mkdp_port = '8080'
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_echo_preview_url = 1
let g:mkdp_auto_close = 0
let g:mkdp_preview_options = {
            \ 'mkit': { 'typographer': v:false },
            \ 'disable_sync_scroll': 1 }
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
" }}}

" Coq {{{
function! g:CoqtailHighlight()
    hi def CoqtailChecked ctermbg=237
    hi def CoqtailSent ctermbg=60
endfunction
augroup SetupCoq | au!
    au FileType coq,coq-goals,coq-infos call tomtomjhj#coq#mappings()
    " NOTE: 'r', 'o' flags don't distinguish bullet '*' and comment leader '*'
    au FileType coq
                \ let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), { "'": {'closer': ''} }) |
                \ setl shiftwidth=2 |
                \ setl comments=s0:(*,e:*) formatoptions=tcqnj " no middle piece & comment leader
                " \ setl comments=sr:(*,mb:*,ex:*) formatoptions=tcroqnj
    let g:coqtail_noindent_comment = 1
augroup END
" }}}

let g:lisp_rainbow = 1
" }}}

" search & fzf {{{
" search_mode: which command last set @/?
" `*`, `v_*` without moving the cursor. Reserve @c for the raw original text
" NOTE: Can't repeat properly if ins-special-special is used. Use q-recording.
nnoremap <silent>* :call Star(0)\|set hlsearch<CR>
nnoremap <silent>g* :call Star(1)\|set hlsearch<CR>
vnoremap <silent>* :<C-u>call VisualStar(0)\|set hlsearch<CR>
vnoremap <silent>g* :<C-u>call VisualStar(1)\|set hlsearch<CR>
" set hlsearch inside the function doesn't work? Maybe :h function-search-undo?
" NOTE: word boundary is syntax property -> may not match in other ft buffers
func! Star(g)
    let @c = expand('<cword>')
    " <cword> can be non-keyword
    if match(@c, '\k') == -1
        let g:search_mode = 'v'
        let @/ = escape(@c, '\.*$^~[]')
    else
        let g:search_mode = 'n'
        let @/ = a:g ? @c : '\<' . @c . '\>'
    endif
endfunc
func! VisualStar(g)
    " TODO separate out the functionality get the selected text
    let g:search_mode = 'v'
    let l:reg_save = @"
    " don't trigger TextYankPost
    noau exec "norm! gvy"
    let @c = @"
    let l:pattern = escape(@", '\.*$^~[]')
    let @/ = a:g ? '\<' . l:pattern . '\>' : l:pattern " reversed
    let @" = l:reg_save
endfunc
nnoremap / :let g:search_mode='/'<CR>/

let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'border': 'top' } }
let g:fzf_preview_window = 'right:50%'

nnoremap <C-g>      :<C-u>Grep<space>
nnoremap <leader>g/ :<C-u>Grep <C-r>=RgInput(@/)<CR>
nnoremap <leader>gw :<C-u>Grep \b<C-R>=expand('<cword>')<CR>\b
nnoremap <leader>gf :<C-u>Grepf<space>
nnoremap <leader>b  :<C-u>Buffers<CR>
nnoremap <C-f>      :<C-u>Files<CR>
nnoremap <leader>hh :<C-u>History<CR>
" tag with fzf. TODO preview. (preview: <c-w>}). <C-w>] is affected by switchbuf
nnoremap <leader><C-t> :Tags ^<C-r><C-w>\  <CR>

" TODO: fzf multi-select quickfix list order is reversed
augroup fzf | au!
    if has('nvim')
        " `au TermOpen tnoremap` and `au FileType fzf tunmap` breaks coc-fzf
        tnoremap <expr> <Esc> (&filetype == 'fzf') ? '<Esc>' : '<c-\><c-n>'
        tnoremap <expr> <C-q> (&filetype == 'fzf') ? '<C-q>' : '<c-\><c-n>'
    else
        tnoremap <C-q> <Esc>
    endif
augroup END

command! -nargs=* -bang Grep  call Ripgrep(<q-args>)
command! -nargs=* -bang Grepf call RipgrepFly(<q-args>)
command! -bang -nargs=? -complete=dir Files call Files(<q-args>)
" allow search on the full tag info, excluding the appended tagfile name
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, { 'options': ['-d', '\t', '--nth', '..-2'] })

" TODO: set g:fzf_layout on VimResized?
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
let s:rg_cmd_base = 'rg --column --line-number --no-heading --color=always --colors path:fg:218 --colors match:fg:116 --smart-case '
func! Ripgrep(query)
    let cmd = s:rg_cmd_base . shellescape(a:query)
    let spec = FzfOpts(v:count, {'options': ['--info=inline']})
    call fzf#vim#grep(cmd, 1, spec)
endfunc
func! RipgrepFly(query)
    let command_fmt = s:rg_cmd_base . '-- %s || true'
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
nnoremap <expr> j                     v:count ? 'j' : 'gj'
nnoremap <expr> k                     v:count ? 'k' : 'gk'
nnoremap <expr> J                     v:count ? 'j' : 'gj'
nnoremap <expr> K                     v:count ? 'k' : 'gk'
vnoremap <expr> j mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
vnoremap <expr> k mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
onoremap <expr> j mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
onoremap <expr> k mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
vnoremap <expr> J mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
vnoremap <expr> K mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
onoremap <expr> J mode() !=# 'v' \|\| v:count ? 'j' : 'gj'
onoremap <expr> K mode() !=# 'v' \|\| v:count ? 'k' : 'gk'
noremap <leader>J J
noremap <expr> H v:count ? 'H' : 'h'
noremap <expr> L v:count ? 'L' : 'l'

" space to navigate
nnoremap <space> <C-d>
nnoremap <c-space> <C-u>
" <s-space> does not work

noremap <M-0> ^w

" NOTE: vertical scope, label_esc
let g:sneak#s_next = 1
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
hi! Sneak guifg=black guibg=#afff00 gui=bold ctermfg=black ctermbg=154 cterm=bold
" NOTE: my fork
let g:sneak#alias = {
            \ 'a': '[aα]', 'b': '[bβ]', 'c': '[cξ]', 'd': '[dδ]', 'e': '[eε]', 'f': '[fφ]', 'g': '[gγ]', 'h': '[hθ]', 'i': '[iι]', 'j': '[jϊ]', 'k': '[kκ]', 'l': '[lλ]', 'm': '[mμ]', 'n': '[nν]', 'o': '[oο]', 'p': '[pπ]', 'q': '[qψ]', 'r': '[rρ]', 's': '[sσ]', 't': '[tτ]', 'u': '[uυ]', 'v': '[vϋ𝓥]', 'w': '[wω]', 'x': '[xχ]', 'y': '[yη]', 'z': '[zζ]',
            \ '*': '[*∗]',
            \ '/': '[/∧]', '\': '[\∨]',
            \ '<': '[<≼]',
            \ '>': '[>↦→⇒⇝]',
            \ '[': '[[⌜⎡⊑⊓]', ']': '[\]⌝⎤⊒⊔]',
            \}

" TODO: (speicial char -> non-blank, non-keyword), user-defined (paren -> pair?)
" s-word: (a keyword | repetition of non-paren speicial char | a paren | whitespace)
let g:sword = '\v(\k+|([^[:alnum:]_[:blank:](){}[\]<>$])\2*|[(){}[\]<>$]|\s+)'

" Jump past a sword. Assumes `set whichwrap+=]` for i_<Right>
inoremap <silent><C-j> <C-\><C-O>:call SwordJumpRight()<CR><Right><C-\><C-o><ESC>
inoremap <silent><C-k> <C-\><C-O>:call SwordJumpLeft()<CR>
func! SwordJumpRight()
    if col('.') !=  col('$')
        call search(g:sword, 'ceW')
    endif
endfunc
func! SwordJumpLeft()
    call search(col('.') != 1 ? g:sword : '\v$', 'bW')
endfunc

inoremap <C-u> <C-\><C-o><ESC><C-g>u<C-u>
" Delete a single character of other non-blank chars
" TODO: delete sword?
inoremap <silent><expr><C-w> FineGrainedICtrlW()
func! FineGrainedICtrlW()
    let l:col = col('.')
    if l:col == 1 | return "\<BS>" | endif
    let l:before = strpart(getline('.'), 0, l:col - 1)
    " TODO: is this necessary? can \s be suffix of other character?
    let l:chars = split(l:before, '.\zs')
    if l:chars[-1] =~ '\s'
        let l:len = len(l:chars)
        let l:idx = 1
        while l:idx < l:len && l:chars[-(l:idx + 1)] =~ '\s'
            let l:idx += 1
        endwhile
        if l:idx == l:len || l:chars[-(l:idx + 1)] =~ '\k'
            return "\<C-\>\<C-o>\<ESC>\<C-w>"
        endif
        let l:sts = &softtabstop
        setlocal softtabstop=0
        return repeat("\<BS>", l:idx)
                    \ . "\<C-R>=execute('setl sts=".l:sts."')\<CR>"
                    \ . "\<C-R>=pear_tree#insert_mode#Backspace()\<CR>"
    elseif l:chars[-1] !~ '\k'
        return pear_tree#insert_mode#Backspace()
    else
        return "\<C-\>\<C-o>\<ESC>\<C-w>"
    endif
endfunc

" }}}

" etc mappings {{{
map <silent><leader><CR> :noh<CR>
map <leader>ss :setlocal spell!\|setlocal spell?<cr>
map <leader>sc :if &spc == "" \| setl spc< \| else \| setl spc= \| endif \| setl spc?<CR>
map <leader>sp :setlocal paste!\|setlocal paste?<cr>
map <leader>sw :set wrap!\|set wrap?<CR>
map <leader>ic :set ignorecase! smartcase!\|set ignorecase?<CR>
map <leader>sf :syn sync fromstart<CR>

map <leader>dp :diffput<CR>
map <leader>do :diffget<CR>

" clipboard.
inoremap <C-v> <C-g>u<C-\><C-o>:set paste<CR><C-r>+<C-\><C-o>:set nopaste<CR>
vnoremap <C-c> "+y

" buf/filename
noremap <leader>fn 2<C-g>

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

" c_CTRL-F: editable cmd/search history, gQ: enter ex mode, Q instead of q for macros
noremap q: :
noremap q <nop>
noremap Q q

" delete without clearing regs
noremap x "_x

" repetitive pastes using designated register @p
noremap <M-y> "py
noremap <M-p> "pp
noremap <M-P> "pP

nnoremap Y y$
onoremap <silent> ge :execute "normal! " . v:count1 . "ge<space>"<cr>
nnoremap <silent> & :&&<cr>
xnoremap <silent> & :&&<cr>

" set nrformats+=alpha
noremap + <C-a>
vnoremap + g<C-a>
noremap - <C-x>
vnoremap - g<C-x>

" <C-b> <C-e>
cnoremap <C-j> <S-Right>
cnoremap <C-k> <S-Left>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

noremap <leader>q :<C-u>q<CR>
noremap q, :<C-u>q<CR>
nnoremap <leader>w :<C-u>up<CR>
noremap ZAQ :<C-u>qa!<CR>
command! -bang W   w<bang>
command! -bang Q   q<bang>

nmap <leader>cx :tabclose<cr>
nmap <leader>td :tab split<CR>
nmap <leader>tt :tabedit<CR>
nmap <leader>cd :cd <c-r>=expand("%:p:h")<cr>/
nmap <leader>e  :e! <c-r>=expand("%:p:h")<cr>/
nmap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nmap <leader>fe :e!<CR>
" }}}

" etc plugin settings {{{
" pairs {{{
let g:pear_tree_map_special_keys = 0
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_timeout = 23
let g:pear_tree_repeatable_expand = 0
" assumes nosmartindent
imap <expr> <CR> match(getline('.'), '\w') >= 0 ? "\<C-G>u\<Plug>(PearTreeExpand)" : "\<Plug>(PearTreeExpand)"
imap <BS> <Plug>(PearTreeBackspace)

" 'a'ny block from matchup
xmap aa a%
omap aa a%
xmap ia i%
omap ia i%

augroup MyTargets | au!
    " NOTE: can't expand by repeating → use builtin for simple objects
    " NOTE: can't select **text <newline> text** using i*
    " https://github.com/wellle/targets.vim/issues/175
    " - a'r'guments, any 'q'uote, any 'b'lock, separators + 'n'ext,'l'ast
    " - Leave a for matchup any-block.
    autocmd User targets#mappings#user call targets#mappings#extend({
    \ '(': {},
    \ ')': {},
    \ '{': {},
    \ '}': {},
    \ 'B': {},
    \ '[': {},
    \ ']': {},
    \ '<': {},
    \ '>': {},
    \ '"': {},
    \ "'": {},
    \ '`': {},
    \ 't': {},
    \ 'a': {},
    \ 'r': {'argument': [{'o': '[([]', 'c': '[])]', 's': ','}]},
    \ })
augroup END
" }}}

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
" }}}

" Explorers {{{
let g:loaded_netrwPlugin = 1
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>
vnoremap <silent> <Plug>NetrwBrowseXVis :<c-u>call netrw#BrowseXVis()<cr>
nmap gx <Plug>NetrwBrowseX
vmap gx <Plug>NetrwBrowseXVis

let NERDTreeHijackNetrw = 0
let g:NERDTreeIgnore=['\~$', '\.glob$', '\v\.vo[sk]?$', '\.v\.d$', '\.o$']
let g:NERDTreeStatusline = -1
nmap <silent><leader>nn :NERDTreeToggle<cr>
nmap <silent><leader>nf :NERDTreeFind<cr>

" TODO: make preview use preview window https://github.com/justinmk/vim-dirvish/pull/65/commits/9e3f16aa5413479919b540e1f0db594d3f997f15
command! -nargs=? -complete=dir Sexplore split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore vsplit | silent Dirvish <args>
nmap <silent><C-w>es :Sexplore %<CR>
nmap <silent><C-w>ev :Vexplore %<CR>
nmap <leader>D <Plug>(dirvish_up)
hi! link DirvishSuffix Special
" }}}

let g:EditorConfig_exclude_patterns = ['.*[.]git/.*', 'fugitive://.*', 'scp://.*']

" firenvim {{{
" chrome://extensions/shortcuts -> this may break chrome keymaps like <C-w>
" TODO: Maybe some edge case in fallback? Just use GhostText?
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
    augroup FirenvimStuff | au!
        au UIEnter * call FirenvimUIEnter(deepcopy(v:event))
    augroup END
    function! s:IsFirenvimActive(event) abort
        let l:ui = nvim_get_chan_info(a:event.chan)
        return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') && l:ui.client.name =~? 'Firenvim'
    endfunction
    function! FirenvimUIEnter(event) abort
        if !s:IsFirenvimActive(a:event) | return | endif
        " inoremap <buffer> <M-CR> <Esc>:w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa
    endfunction
else
    let g:firenvim_loaded = 1
endif
" }}}

" textobj
let s:url_regex = '\c\<\(\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)\)'
call textobj#user#plugin('url', { 'url': { 'pattern': s:url_regex, 'select': ['au', 'iu'] } })
call textobj#user#plugin('path', { 'path': { 'pattern': '\f\+', 'select': ['aP', 'iP'] } })

" comments
let g:NERDCreateDefaultMappings = 0
" NOTE: indentation is incorrect sometimes. Use i_CTRL-f
imap <M-/> <C-G>u<Plug>NERDCommenterInsert
map <M-/> <Plug>NERDCommenterComment
xmap <leader>c<Space> <Plug>NERDCommenterToggle
nmap <leader>c<Space> <Plug>NERDCommenterToggle
xmap <leader>cs <Plug>NERDCommenterSexy
nmap <leader>cs <Plug>NERDCommenterSexy
xmap <leader>cm <Plug>NERDCommenterMinimal
nmap <leader>cm <Plug>NERDCommenterMinimal
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
            \ 'python' : { 'left': '#', 'leftAlt': '#' },
            \ 'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
            \ 'coq': { 'left': '(*', 'right': '*)', 'nested': 1 },
            \}
let g:NERDDefaultAlign = 'left'

" undotree
let g:undotree_WindowLayout = 4
nnoremap U :UndotreeToggle<CR>
" }}}

" etc util {{{
func! SynStackName()
    return map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
func! SynGroup()
    return synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunc
nmap <leader>st :echo SynStackName() '->' SynGroup()<CR>
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

func! Execute(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunc
command! -nargs=* -complete=command Execute silent call Execute(<q-args>)

function! GotoJump()
  jumps
  let j = input("Jump to ([+]N): ")
  if j != ''
    let plus = '\v\c^\+'
    if j =~ plus
      let j = substitute(j, plus, '', 'g')
      execute "normal!" j."\<C-i>"
    else
      execute "normal!" j."\<C-o>"
    endif
  endif
endfunction
command! Jumps call GotoJump()

command! -range=% Unpdf
            \ keeppatterns <line1>,<line2>substitute/[“”]/"/ge |
            \ keeppatterns <line1>,<line2>substitute/[‘’]/'/ge |
            \ keeppatterns <line1>,<line2>substitute/\w\zs-\n//ge

" :substitute using a dict, where key == submatch (like VisualStar)
function! SubstituteDict(dict) range
    exe a:firstline . ',' . a:lastline . 'substitute'
                \ . '/\C\%(' . join(map(keys(a:dict), 'escape(v:val, ''\.*$^~[]'')'), '\|'). '\)'
                \ . '/\=' . string(a:dict) . '[submatch(0)]/ge'
endfunction
command! -range=% -nargs=1 SubstituteDict :<line1>,<line2>call SubstituteDict(<args>)
" }}}
