" vim: set foldmethod=marker foldlevel=0 nomodeline:

let g:ide_client = get(g:, 'ide_client', 'coc')

" Plug {{{
call plug#begin('~/.vim/plugged')

" appearance
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'tomtomjhj/zenbruh.vim'

" editing
" similar to the result of Sneak_;
Plug 'tomtomjhj/vim-sneak'
" TODO: machakann/vim-sandwich?
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tomtomjhj/pear-tree'
Plug 'andymass/vim-matchup' " i%, a%, ]%, z%, g% TODO: % that seeks backward https://github.com/andymass/vim-matchup/issues/49#issuecomment-470933348
Plug 'wellle/targets.vim' " multi (e.g. ib, iq), separator, argument
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'pianohacker/vim-textobj-indented-paragraph', { 'do': 'rm -rf plugin' }
Plug 'preservim/nerdcommenter', { 'on': '<Plug>NERDCommenter' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'AndrewRadev/splitjoin.vim'
" TODO Plug 'mg979/vim-visual-multi'
" TODO Plug 'chrisbra/unicode.vim'
" TODO Plug 'https://github.com/chaoren/vim-wordmotion'

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
" TODO Plug 'https://github.com/kshenoy/vim-signature'
" TODO Plug https://github.com/pwntester/octo.nvim
" TODO: Plug 'https://github.com/lambdalisue/fern.vim'
Plug 'justinmk/vim-dirvish'
Plug 'preservim/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'kassio/neoterm'

" lanauges
Plug 'dense-analysis/ale', { 'on': ['<Plug>(ale_', 'ALEEnable'] } ")
if g:ide_client == 'coc'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
    " Plug '~/apps/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
    Plug 'antoinemadec/coc-fzf'
else
    " https://github.com/hrsh7th/nvim-compe
    Plug 'nvim-lua/completion-nvim'
    Plug 'steelsojka/completion-buffers'
    Plug 'kristijanhusak/completion-tags'
    Plug 'neovim/nvim-lspconfig'
    " https://github.com/anott03/nvim-lspinstall
    Plug 'nvim-lua/lsp_extensions.nvim'
    Plug 'nvim-lua/lsp-status.nvim'
    " Plug 'https://github.com/RishabhRD/nvim-lsputils'
    " Plug 'https://github.com/glepnir/lspsaga.nvim'
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
Plug 'whonore/Coqtail' | let g:coqtail_nomap = 1
" Plug 'puremourning/vimspector' | let g:vimspector_enable_mappings = 'HUMAN'
Plug 'cespare/vim-toml'
Plug 'neoclide/jsonc.vim'
Plug 'rhysd/vim-llvm'
Plug 'fatih/vim-go', { 'do': 'rm -rf plugin ftplugin' }
Plug 'vim-python/python-syntax'
Plug 'tbastos/vim-lua'
Plug 'leafgarland/typescript-vim'
" Plug 'rhysd/vim-grammarous', { 'for': ['markdown', 'tex'] } | let g:grammarous#use_location_list = 1

" etc etc
if has('nvim')
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    " https://github.com/wbthomason/packer.nvim
    " https://github.com/fsouza/vimfiles/tree/main/lua/fsouza
    " https://github.com/phaazon/hop.nvim/
    " Plug 'nvim-lua/plenary.nvim'
    " Plug 'nvim-lua/popup.nvim'
    " Plug 'tjdevries/nlua.nvim'
    " Plug 'nvim-telescope/telescope.nvim'
    " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " Plug 'mfussenegger/nvim-dap'
    " Plug 'mfussenegger/nvim-fzy'
    " Plug 'https://github.com/vijaymarupudi/nvim-fzf'
    " Plug 'https://github.com/TimUntersberger/neogit'
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
set list listchars=tab:\|\ ,trail:-,nbsp:+,extends:>

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
set wildignore=*.o,*~,*.pyc,*.pdf,*.v.d,*.vo,*.vos,*.vok,*.glob,*.aux
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/__pycache__/

set magic
set ignorecase smartcase
set hlsearch incsearch

set noerrorbells novisualbell t_vb=
set shortmess+=Ic

set noswapfile " set directory=~/.vim/swap//
set backup backupdir=~/.vim/backup//
set undofile
set history=500
if has('nvim')
    set shada=!,'150,<50,s30,h undodir=~/.vim/undoo//
else
    set viminfo=!,'150,<50,s30,h undodir=~/.vim/undo//
endif

set autoread
set splitright splitbelow
set switchbuf=useopen,usetab
set hidden
set lazyredraw

set exrc secure
set diffopt+=algorithm:histogram

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
    let &pumheight = min([&window/4, 20])
    au VimResized * let &pumheight = min([&window/4, 20])
augroup END

if has('unix')
    let g:python_host_prog  = '/usr/bin/python2'
    let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}

" Themes {{{
" TODO: buffer_title: merge specialbuf and shortrelpath; and do more fancy stuff for special buffers e.g. w:quickfix_title, term:///, fugitive://, ..
" TODO: merge readonly and modified
let g:lightline = {
      \ 'colorscheme': 'powerwombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['readonly', 'specialbuf', 'shortrelpath', 'modified'],
      \             ['curr_func', 'git'] ],
      \   'right': [ ['lineinfo'], ['percent'],
      \              ['checker_errors', 'checker_warnings', 'checker_status'],
      \              ['asyncrun'] ]
      \ },
      \ 'inactive': {
      \   'left': [ ['specialbuf', 'shortrelpath'],
      \             ['winnr'] ],
      \   'right': [ ['lineinfo'], ['percent'],
      \              ['checker_errors_inactive', 'checker_warnings_inactive'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly && &filetype !=# "help" ? "🔒" : ""}',
      \   'specialbuf': '%q%w',
      \   'modified': '%{&filetype==#"help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'asyncrun': '%{g:asyncrun_status[:3]}',
      \ },
      \ 'component_function': {
      \   'git': 'GitStatusline',
      \   'shortrelpath': 'ShortRelPath',
      \   'curr_func': 'CurrentFunction',
      \   'checker_status': 'CheckerStatus',
      \   'checker_errors_inactive': 'CheckerErrors',
      \   'checker_warnings_inactive': 'CheckerWarnings',
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
      \   'specialbuf': '&pvw||&buftype==#"quickfix"',
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
    " TODO: completion-nvim improvements
    " * source name abbrev (`complete-items` menu)
    " * scoring, priority
    " * per-source trigger character (esp for path)
    " * somewhat less smooth?
    " * more sources (words, ...)
    " * chain completion isn't good because it uses built-in synchronous i_CTRL-X stuff
    " * prefix-only completion: e.g. `prefix_suffix` in buffer, input `suffix` and type `pre` and complete.
    "   Note: https://github.com/neoclide/coc.nvim/blob/8be4f03aff75363818372a755daa8a0dc2071cf0/src/completion/complete.ts#L202-L206
    " * buffer source: don't add the word currently being inserted e.g. `presuffix` in the above example.
    "   Note: this only happens when inserting prefix of the word
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
                \    {'complete_items': ['lsp', 'tags', 'UltiSnips', 'buffers']},
                \ ],
                \}
    let g:completion_timer_cycle = 123
    let g:completion_auto_change_source = 0
    let g:completion_matching_strategy_list = ['exact', 'fuzzy']
    let g:completion_confirm_key = "\<C-y>"
    let g:completion_matching_ignore_case = 0
    let g:completion_matching_smart_case = 0
    let g:completion_customize_lsp_label = {'Buffers': '[B]', 'UltiSnips': '[US]'}

    let g:completion_word_separator = '\%(\k\)\@!.'
endif

let g:UltiSnipsExpandTrigger = '<c-l>'
" }}}

" ALE, LSP, ... global settings {{{
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
" coc-rust-analyzer coc-pyright coc-texlab coc-clangd coc-tsserver coc-go
let g:coc_global_extensions = ['coc-vimlsp', 'coc-ultisnips', 'coc-json', 'coc-tag']
let g:coc_quickfix_open_command = 'CW'
let g:coc_fzf_preview = 'up:66%'

hi! TypeHint ctermfg=Grey guifg=#999999
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

nmap <leader>fm <Plug>(ale_fix)
nmap <M-,> <Plug>(ale_detail)<C-W>p
nmap ]d <Plug>(ale_next_wrap)
nmap [d <Plug>(ale_previous_wrap)
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
augroup SetupPython | au!
    au FileType python call SetupLSP()
    au FileType python set formatoptions+=ro
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
" TODO: inspect some auto-expanded snippets
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
let g:mkdp_page_title = '${name}'
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
" TODO: coq ctags (there's etags generator `coqtags`)
function! g:CoqtailHighlight()
    " TODO: interaction with listchar? NonText highlighting disappears when CoqtailChecked is applied
    hi def CoqtailChecked ctermbg=237 guibg=#3a3a3a
    hi def CoqtailSent ctermbg=60 guibg=#5f5f87
endfunction
augroup SetupCoq | au!
    au FileType coq,coq-goals,coq-infos
                \ call tomtomjhj#coq#mappings() |
                \ set matchpairs+=⌜:⌝,⎡:⎤
    " NOTE: 'r', 'o' flags don't distinguish bullet '*' and comment leader '*'
    au FileType coq
                \ let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), { "'": {'closer': ''} }) |
                \ setl shiftwidth=2 |
                \ setl comments=s:(*,e:*) formatoptions=tcqnj " no middle piece & comment leader
                " \ setl comments=sr:(*,mb:*,ex:*) formatoptions=tcroqnj
    let g:coqtail_noindent_comment = 1
augroup END
" }}}

" Lua {{{
let g:lua_syntax_noextendedstdlib = 1
augroup SetupLua | au!
    au FileType lua call SetupLSP()
    au FileType lua setl shiftwidth=2
augroup END
" }}}

let g:lisp_rainbow = 1
let g:vimsyn_embed = 'l' " TODO: only loads $VIMRUNTIME/syntax/lua.vim
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
nnoremap <leader><C-t> :Tags ^<C-r><C-w>\  <CR>

" TODO: https://github.com/jonhoo/proximity-sort
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
command! -bang -nargs=* Tags call fzf#vim#tags(<q-args>, fzf#vim#with_preview({ "placeholder": "--tag {2}:{-1}:{3}", 'options': ['-d', '\t', '--nth', '..-2'] }))

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
    let spec = FzfOpts(v:count, {'options': ['--info=inline', '--layout=reverse-list']})
    call fzf#vim#grep(cmd, 1, spec)
endfunc
func! RipgrepFly(query)
    let command_fmt = s:rg_cmd_base . '-- %s || true'
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

nnoremap <space> <C-d>
nnoremap <c-space> <C-u>

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
            \ 'a': '[aα∀]', 'b': '[bβ]', 'c': '[cξ]', 'd': '[dδ]', 'e': '[eε∃]', 'f': '[fφ]', 'g': '[gγ]', 'h': '[hθ]', 'i': '[iι]', 'j': '[jϊ]', 'k': '[kκ]', 'l': '[lλ]', 'm': '[mμ]', 'n': '[nν]', 'o': '[oο]', 'p': '[pπ]', 'q': '[qψ]', 'r': '[rρ]', 's': '[sσ]', 't': '[tτ]', 'u': '[uυ]', 'v': '[vϋ𝓥]', 'w': '[wω]', 'x': '[xχ]', 'y': '[yη]', 'z': '[zζ]',
            \ '*': '[*∗]',
            \ '/': '[/∧]', '\': '[\∨]',
            \ '<': '[<≼]',
            \ '>': '[>↦→⇒⇝]',
            \ '[': '[[⌜⎡⊑⊓]', ']': '[\]⌝⎤⊒⊔]',
            \}

" TODO: (special char -> non-blank, non-keyword), user-defined (paren -> pair?)
" s-word: (a keyword | repetition of non-paren special char | a paren | whitespace)
let g:sword = '\v(\k+|([^[:alnum:]_[:blank:](){}[\]<>$])\2*|[(){}[\]<>$]|\s+)'
"                     %(\k|[()[\]{}<>[:blank:]$])@!(.)\1*

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

" i_CTRL-W and i_CTRL-U without 'stop once at the start of insert' (resolved https://github.com/vim/vim/pull/5940)
inoremap <M-w> <C-\><C-o><ESC><C-w>
inoremap <C-u> <C-\><C-o><ESC><C-g>u<C-u>
" Delete a single character of other non-blank chars
inoremap <silent><expr><C-w>  FineGrainedICtrlW(0)
" Like above, but first consume whitespace
" TODO: more fine-grained like emacs syntax-subword
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
            return "\<C-\>\<C-o>\<ESC>\<C-w>"
        endif
        let l:sts = &softtabstop
        setlocal softtabstop=0
        return repeat("\<BS>", l:idx)
                    \ . "\<C-R>=execute('setl sts=".l:sts."')\<CR>"
                    \ . (a:finer ? "" : "\<C-R>=pear_tree#insert_mode#Backspace()\<CR>")
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

" disable annoying q and Q (use c_CTRL-F and gQ) and streamline record/execute
" TODO: q quits hit-enter and *starts recording* unlike q of more-prompt → open a vim issue
noremap q: :
noremap q <nop>
noremap <M-q> q
noremap <expr> qq empty(reg_recording()) ? 'qq' : 'q'
noremap Q @q

" v_u mistake is  hard to notice. Use gu instead (works for visual mode too).
xnoremap u <nop>

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
noremap  <M-+> <C-a>
vnoremap <M-+> g<C-a>
noremap  <M--> <C-x>
vnoremap <M--> g<C-x>

" <C-b> <C-e>
cnoremap <C-j> <S-Right>
cnoremap <C-k> <S-Left>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

command! -count Wfh set winfixheight | if <count> | exe "normal! z".<count>."\<CR>" | endif

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
    \ '(': {}, ')': {}, '{': {}, '}': {}, 'B': {}, '[': {}, ']': {}, '<': {}, '>': {}, '"': {}, "'": {}, '`': {}, 't': {}, 'a': {},
    \ 'r': {'argument': [{'o': '[([]', 'c': '[])]', 's': ','}]},
    \ })
augroup END
" }}}

" asyncrun
map <leader>R :AsyncRun<space>
map <leader>ST :AsyncStop\|let g:asyncrun_status = ''<CR>
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
map <leader>M :Make<space>
command! -bang -bar -nargs=* -complete=customlist,fugitive#PushComplete Gpush  execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git push' <q-args>
command! -bang -bar -nargs=* -complete=customlist,fugitive#FetchComplete Gfetch execute 'AsyncRun<bang> -cwd=' . fnameescape(FugitiveGitDir()) 'git fetch' <q-args>

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

" textobj {{{
let s:url_or_filename_regex = '\c\(\<\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)\|\f\+\)'
call textobj#user#plugin('tomtomjhj', {
\   'url_or_filename': { 'pattern': s:url_or_filename_regex, 'select': ['au', 'iu'] },
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
let g:NERDCreateDefaultMappings = 0
" NOTE: indentation is incorrect sometimes. Use i_CTRL-f
imap <M-/> <C-G>u<Plug>NERDCommenterInsert
map <M-/> <Plug>NERDCommenterComment
" TODO: <Plug>NERDCommenterComment using block comment on visual block whose last char is unicode (e.g. "a가") breaks up the unicode char
xmap <leader>c<Space> <Plug>NERDCommenterToggle
nmap <leader>c<Space> <Plug>NERDCommenterToggle
xmap <leader>cs <Plug>NERDCommenterSexy
nmap <leader>cs <Plug>NERDCommenterSexy
xmap <leader>cm <Plug>NERDCommenterMinimal
nmap <leader>cm <Plug>NERDCommenterMinimal
xmap <leader>cu <Plug>NERDCommenterUncomment
nmap <leader>cu <Plug>NERDCommenterUncomment
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters = {
            \ 'python' : { 'left': '#', 'leftAlt': '#' },
            \ 'c': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
            \ 'coq': { 'left': '(*', 'right': '*)', 'nested': 1 },
            \}
let g:NERDDefaultAlign = 'left'
" TODO: nested comment gets uncommented! e.g.
" (*
" (* *)
" *)
" → command to remove exactly one layer?
" }}}

" undotree
let g:undotree_WindowLayout = 4
nnoremap U :UndotreeToggle<CR>

" neoterm
let g:neoterm_default_mod = 'rightbelow'
let g:neoterm_automap_keys = '<leader>T'
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

command! -range=% Unpdf
            \ keeppatterns <line1>,<line2>substitute/[“”ł]/"/ge |
            \ keeppatterns <line1>,<line2>substitute/[‘’]/'/ge |
            \ keeppatterns <line1>,<line2>substitute/\w\zs-\n//ge

" :substitute using a dict, where key == submatch (like VisualStar)
function! SubstituteDict(dict) range
    exe a:firstline . ',' . a:lastline . 'substitute'
                \ . '/\C\%(' . join(map(keys(a:dict), 'escape(v:val, ''\.*$^~[]'')'), '\|'). '\)'
                \ . '/\=a:dict[submatch(0)]/ge'
endfunction
command! -range=% -nargs=1 SubstituteDict :<line1>,<line2>call SubstituteDict(<args>)

command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
" }}}
