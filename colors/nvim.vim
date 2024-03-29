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
"   NvimLightGrey1 #eef1f8
"   NvimLightGrey2 #e0e2ea
"   NvimLightGrey3 #c4c6cd
"   NvimLightGrey4 #9b9ea4
"   NvimDarkGrey4  #4f5258
"   NvimDarkGrey3  #2c2e33
"   NvimDarkGrey2  #14161b
"   NvimDarkGrey1  #07080d
"   - foldcolumn vs. linenr
"   - DiffChange vs. Visual
"   - MatchParen vs. Visual
" - doesn't set terminal_color_x
" - Todo is not noisy enough
" - conceal too dim
" - not enough saturation for red
" - cterm Visual assumes 0 = absolute black and 15 = absolute white
" - cterm TabLine and TabLineSel

if &background is# 'dark'
    hi Normal guifg=#eeeeee guibg=#151618
    hi Todo guibg=NvimDarkRed ctermbg=1
    hi @function ctermfg=14 cterm=bold guifg=NvimLightCyan gui=bold
    hi @module guifg=NvimLightGrey2
    hi @markup.raw.block guifg=NvimLightGreen
    hi DiffAdd guibg=#114422 guifg=NONE
    hi DiffChange guibg=#333435 guifg=NONE
    hi MatchParen guibg=#333435
    hi Visual guibg=#55585e
    hi QuickFixLine guifg=NvimLightGrey1 guibg=NvimDarkCyan gui=bold ctermfg=0 ctermbg=14 cterm=bold
    " hi CurSearch guifg=NvimDarkGrey1 guibg=NvimLightMagenta
    hi FlashLabel gui=bold guifg=NvimDarkGrey1 guibg=#d777d7 cterm=bold ctermfg=0 ctermbg=13
    if str2nr(&t_Co) >= 256
        hi Comment ctermfg=250
    endif
else
    hi Normal guibg=#e8e9ea
    hi Todo guibg=NvimLightRed ctermbg=9
    hi @function ctermfg=6 cterm=bold guifg=NvimDarkCyan gui=bold
    hi @module guifg=NvimDarkGrey2
    hi @markup.raw.block guifg=NvimDarkGreen
    hi DiffAdd guibg=#aaddbb guifg=NONE
    hi DiffChange guibg=#b7b8b9 guifg=NONE
    hi MatchParen guibg=#b7b8b9
    hi Visual guibg=#94979e
    hi QuickFixLine guifg=NvimDarkGrey1 guibg=NvimLightCyan gui=bold ctermfg=15 ctermbg=6 cterm=bold
    " hi CurSearch guifg=NvimLightGrey1 guibg=NvimDarkMagenta
    hi FlashLabel gui=bold guifg=NvimLightGrey1 guibg=#871087  cterm=bold ctermfg=0 ctermbg=5
    if str2nr(&t_Co) >= 256
        hi Comment ctermfg=241
    endif
endif

hi Visual ctermfg=Black ctermbg=Grey

hi! link LineNr Comment
hi SignColumn ctermfg=8
hi CurSearch gui=bold cterm=bold
hi clear Conceal

hi DiagnosticUnderlineError gui=undercurl cterm=undercurl
hi DiagnosticUnderlineWarn  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineInfo  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineHint  gui=undercurl cterm=undercurl
hi DiagnosticUnderlineOk    gui=undercurl cterm=undercurl

hi LspReferenceText  gui=underline cterm=underline
hi LspReferenceRead  gui=underline cterm=underline
hi LspReferenceWrite gui=underline cterm=underline
hi! link LspCodeLens NonText
hi! link LspCodeLensSeparator NonText

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

hi! link Character String
hi! link Number String
hi! link Boolean String
hi! link Float String

hi! link @markup.quote @markup.raw.block

hi Title gui=bold,underline cterm=bold,underline
