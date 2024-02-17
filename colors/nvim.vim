if !has('nvim-0.10') | finish | endif

" customization for nvim's default colorscheme
hi clear
let g:colors_name = 'nvim'

" issues with colorscheme system
" * setting Normal prevents default colors defining Normal???
" * https://github.com/vim/vim/issues/13610
" * those two are why I have to use a separate colorscheme file
" * nvim --clean on light terminal still does bg flicker  https://github.com/neovim/neovim/issues/26372
"   especially noticeable when starting with man
" * @markup.raw.block.* should be NONE
" * how to modify built-in color? vim has v:colornames


" color issues
" - need more greys
"   - foldcolumn vs. linenr
"   - DiffChange vs. Visual
" - doesn't set terminal_color_x
" - Todo is not noisy enough
" - conceal too dim
" - not enough saturation for red

if &background is# 'dark'
    hi Normal guifg=#eeeeee guibg=#151618
    hi Todo guibg=NvimDarkRed ctermbg=1
    hi @function ctermfg=14 cterm=bold guifg=NvimLightCyan gui=bold
    hi @module guifg=NvimLightGrey2
    hi DiffAdd guibg=#114422 guifg=NONE
    hi DiffChange guibg=#333435 guifg=NONE
    hi QuickFixLine guifg=NvimLightGrey1 guibg=NvimDarkCyan gui=bold ctermfg=0 ctermbg=14 cterm=bold
else
    hi Normal guibg=#e8e9ea
    hi Todo guibg=NvimLightRed ctermbg=9
    hi @function ctermfg=6 cterm=bold guifg=NvimDarkCyan gui=bold
    hi @module guifg=NvimDarkGrey2
    hi DiffAdd guibg=#aaddbb guifg=NONE
    hi DiffChange guibg=#c0c1c2 guifg=NONE
    hi QuickFixLine guifg=NvimDarkGrey1 guibg=NvimLightCyan gui=bold ctermfg=15 ctermbg=6 cterm=bold
endif

hi! link LineNr Comment
hi SignColumn ctermfg=8
hi CurSearch gui=bold cterm=bold
hi clear Conceal

hi DiagnosticUnderlineError gui=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineInfo  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineHint  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineOk    gui=undercurl cterm=undercurl

hi! link @function.call Function
hi! link @function.macro Function
hi! link @function.method @function
hi! link @function.method.call @function.call

hi! link Operator Keyword

hi! link StorageClass Keyword
hi! link Structure Keyword
hi! link Typedef Keyword
hi! link @type.qualifier StorageClass
hi! link @keyword.storage.lifetime NONE

hi @variable.builtin gui=italic cterm=italic
hi @constant.builtin gui=italic cterm=italic
hi @module.builtin   gui=italic cterm=italic
hi @type.builtin     gui=italic cterm=italic

hi! link @markup.raw String
hi! link @markup.quote String

hi Title gui=bold,underline cterm=bold,underline
