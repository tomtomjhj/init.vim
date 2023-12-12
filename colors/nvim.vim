" customization for nvim's default colorscheme
hi clear
let g:colors_name = 'nvim'

" issues with colorscheme system
" * `:colorscheme default` forces background redetection,
"   and it's wrong in tmux despite recent changes
" * setting Normal prevents default colors defining Normal???
" * https://github.com/vim/vim/issues/13610

" color issues
" - QuickFixLine is not too visible
" - grey is too blue
"   { "NvimDarkGrey1", RGB_(0x0a, 0x0b, 0x10) },     // cterm=232
"   { "NvimDarkGrey2", RGB_(0x1c, 0x1d, 0x23) },     // cterm=234
"   { "NvimLightGrey1", RGB_(0xeb, 0xee, 0xf5) },    // cterm=255
"   { "NvimLightGrey2", RGB_(0xd7, 0xda, 0xe1) },    // cterm=253
" - Special is not highlighted (linked from diffRemoved)
" - no CurSearch
"   no IncSearch
" - doesn't set terminal_color_x
" - Todo
" - foldcolumn not distinguishable from linenr

if &background is# 'dark'
    hi Normal guifg=NvimLightGrey2 ctermfg=253 guibg=#181818 ctermbg=234
    hi! link diffAdded String
    hi diffRemoved ctermfg=217 guifg=NvimLightRed
    hi CurSearch ctermfg=255 ctermbg=58 cterm=bold,underline guifg=NvimLightGrey1 guibg=NvimDarkYellow gui=bold,underline
    hi @function ctermfg=123 cterm=bold guifg=NvimLightCyan gui=bold
else
    hi Normal guifg=NvimDarkGrey2 ctermfg=234 guibg=#dddddd ctermbg=253
    hi! link diffAdded String
    hi diffRemoved ctermfg=52 guifg=NvimDarkRed
    hi CurSearch ctermfg=232 ctermbg=222 cterm=bold,underline guifg=NvimDarkGrey1 guibg=NvimLightYellow gui=bold,underline
    hi @function ctermfg=30 cterm=bold guifg=NvimDarkCyan gui=bold
endif

hi! link @function.call Function
hi! link @method @function
hi! link @method.call @function.call
hi! link LineNr Comment

hi! link IncSearch CurSearch
hi QuickFixLine gui=bold,reverse cterm=bold,reverse

hi DiagnosticUnderlineError gui=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineInfo  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineHint  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineOk    gui=undercurl cterm=undercurl
