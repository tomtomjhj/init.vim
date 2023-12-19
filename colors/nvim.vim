" customization for nvim's default colorscheme
hi clear
let g:colors_name = 'nvim'

" issues with colorscheme system
" * setting Normal prevents default colors defining Normal???
" * https://github.com/vim/vim/issues/13610
" * nvim --clean on light terminal still does bg flicker  https://github.com/neovim/neovim/issues/26372
"   especially noticeable when starting with man


" color issues
" - need more greys
"   - foldcolumn vs. linenr
"   - DiffChange vs. Visual
"   - TabLine
" - no IncSearch
" - doesn't set terminal_color_x
" - Todo is not noisy enough

if &background is# 'dark'
    hi diffRemoved ctermfg=9 guifg=NvimLightRed
    hi @function ctermfg=14 cterm=bold guifg=NvimLightCyan gui=bold
    hi DiffAdd guibg=#114422
else
    hi diffRemoved ctermfg=1 guifg=NvimDarkRed
    hi @function ctermfg=6 cterm=bold guifg=NvimDarkCyan gui=bold
    hi DiffAdd guibg=#aaddbb
endif

hi! link LineNr Comment
hi CurSearch gui=bold cterm=bold
hi! link IncSearch CurSearch
hi QuickFixLine gui=bold cterm=bold

hi DiagnosticUnderlineError gui=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineInfo  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineHint  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineOk    gui=undercurl cterm=undercurl

hi! link @function.call Function
hi! link @method @function
hi! link @method.call @function.call

hi! link diffAdded String
