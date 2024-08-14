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
" - CurSearch cursor is not eligible in gnome-terminal because the Normal bg matches CurSearch + Cursor bg.
"   So CurSearch fg should be opposite of Normal bg.

if &background is# 'dark'
    hi Normal guifg=#eeeeee guibg=#151618
    hi Todo guibg=NvimDarkRed ctermbg=1
    hi @variable.builtin guifg=NvimLightGrey2 gui=italic cterm=italic
    hi @constant.builtin guifg=NvimLightGrey2 gui=italic cterm=italic
    hi @module.builtin   guifg=NvimLightGrey2 gui=italic cterm=italic
    hi @type.builtin     guifg=NvimLightGrey2 gui=italic cterm=italic
    hi @function ctermfg=14 cterm=bold guifg=NvimLightCyan gui=bold
    hi @module guifg=NvimLightGrey2
    hi @markup.raw.block guifg=NvimLightGreen
    hi DiffAdd guibg=#114422 guifg=NONE
    hi DiffChange guibg=#333435 guifg=NONE
    hi MatchParen guibg=#333435
    hi Visual guibg=#55585e
    hi QuickFixLine guifg=NvimLightGrey1 guibg=NvimDarkCyan gui=bold ctermfg=0 ctermbg=14 cterm=bold
    hi SpellBad guisp=#ff5f5f
    hi CurSearch guifg=#000000
    " hi CurSearch guifg=NvimLightGrey1 guibg=#991199
    hi FlashLabel gui=bold guifg=NvimDarkGrey1 guibg=#d777d7 cterm=bold ctermfg=0 ctermbg=13
    if str2nr(&t_Co) >= 256
        hi Comment ctermfg=250
    endif
else
    hi Normal guibg=#e8e9ea
    hi Todo guibg=NvimLightRed ctermbg=9
    hi @variable.builtin guifg=NvimDarkGrey2 gui=italic cterm=italic
    hi @constant.builtin guifg=NvimDarkGrey2 gui=italic cterm=italic
    hi @module.builtin   guifg=NvimDarkGrey2 gui=italic cterm=italic
    hi @type.builtin     guifg=NvimDarkGrey2 gui=italic cterm=italic
    hi @function ctermfg=6 cterm=bold guifg=NvimDarkCyan gui=bold
    hi @module guifg=NvimDarkGrey2
    hi @markup.raw.block guifg=NvimDarkGreen
    hi DiffAdd guibg=#aaddbb guifg=NONE
    hi DiffChange guibg=#b7b8b9 guifg=NONE
    hi MatchParen guibg=#b7b8b9
    hi Visual guibg=#94979e
    hi QuickFixLine guifg=NvimDarkGrey1 guibg=NvimLightCyan gui=bold ctermfg=15 ctermbg=6 cterm=bold
    hi SpellBad guisp=#991111
    hi CurSearch guifg=#ffffff
    " hi CurSearch guifg=NvimDarkGrey1 guibg=#ff5fff
    hi FlashLabel gui=bold guifg=NvimLightGrey1 guibg=#871087  cterm=bold ctermfg=0 ctermbg=5
    if str2nr(&t_Co) >= 256
        hi Comment ctermfg=241
    endif
endif

hi Visual ctermfg=Black ctermbg=Grey

hi! link LineNr Comment
hi SignColumn ctermfg=8
hi CurSearch gui=bold,underline cterm=bold,underline
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

hi! link @markup.raw String
hi! link @markup.quote NONE

hi! link Operator Keyword

hi! link StorageClass Keyword
hi! link Structure Keyword
hi! link Typedef Keyword

hi! link Character String
hi! link Number String
hi! link Boolean String
hi! link Float String

hi Title gui=bold,underline cterm=bold,underline

hi PmenuMatch cterm=reverse guibg=NvimDarkGrey3 gui=bold
hi PmenuMatchSel cterm=underline,reverse guifg=NvimDarkGrey3 guibg=NvimLightGrey2 gui=bold blend=0

hi CmpItemAbbrMatch gui=bold cterm=bold
hi! link CmpItemKind NONE

hi! link Sneak FlashLabel

hi! link coqTerm Keyword
hi! link coqVernacCmd Keyword


" https://github.com/neovim/neovim/issues/26857 + tweaks for 0, 8, 15
let s:bg = &background is# 'dark' ? 'NvimDark'  : 'NvimLight'
let s:fg = &background is# 'dark' ? 'NvimLight' : 'NvimDark'
let g:terminal_color_0  = s:bg .. 'Grey1'
let g:terminal_color_1  = s:fg .. 'Red'
let g:terminal_color_2  = s:fg .. 'Green'
let g:terminal_color_3  = s:fg .. 'Yellow'
let g:terminal_color_4  = s:fg .. 'Blue'
let g:terminal_color_5  = s:fg .. 'Magenta'
let g:terminal_color_6  = s:fg .. 'Cyan'
let g:terminal_color_7  = s:fg .. 'Grey2'
let g:terminal_color_8  = s:bg .. 'Grey3'
let g:terminal_color_9  = s:fg .. 'Red'
let g:terminal_color_10 = s:fg .. 'Green'
let g:terminal_color_11 = s:fg .. 'Yellow'
let g:terminal_color_12 = s:fg .. 'Blue'
let g:terminal_color_13 = s:fg .. 'Magenta'
let g:terminal_color_14 = s:fg .. 'Cyan'
let g:terminal_color_15 = s:fg .. 'Grey1'
unlet! s:bg s:fg
