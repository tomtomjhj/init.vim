" Configuration: {{{

let g:colors_name = 'zen'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:white     = ['#FFFFFF', 15]
let s:fg        = ['#F8F8F2', 255]
let s:fgdarkish = ['#d0d0d0', 252]
let s:fgdark    = ['#bcbcbc', 250]
let s:bglighter = ['#424450', 236]
let s:bglight   = ['#343746', 235]
let s:bg        = ['#1c1c1c', 234]
let s:bgdark    = ['#121212', 233]
let s:bgdarker  = ['#121212', 233]
let s:black     = ['#000000', 0]

let s:subtle    = ['#424450', 238]

let s:selection = ['#44475A', 239]
let s:comment   = ['#afd7af', 151]
let s:cyan      = ['#87d7d7', 116]
" #afd7ff
let s:lightcyan = ['#afd7d7', 152] 
let s:green     = ['#afd75f', 149]
let s:orange    = ['#FFB86C', 215]
let s:pink      = ['#ffafd7', 218]
let s:purple    = ['#d7afff', 183]
let s:red       = ['#FF5555', 203]
let s:redish    = ['#d78787', 174]
let s:yellow    = ['#F1FA8C', 228]

let s:yellowish = ['#ffd7af', 223]

let s:special   = ['#ffd7d7', 224]

let s:none      = ['NONE', 'NONE']

if has('nvim')
  let g:terminal_color_0  = '#44475A'
  let g:terminal_color_1  = '#DE312B'
  let g:terminal_color_2  = '#2FD651'
  let g:terminal_color_3  = '#D0D662'
  let g:terminal_color_4  = '#9C6FCF'
  let g:terminal_color_5  = '#DE559C'
  let g:terminal_color_6  = '#6AC5D3'
  let g:terminal_color_7  = '#D7D4C8'
  let g:terminal_color_8  = '#656B84'
  let g:terminal_color_9  = '#FF5555'
  let g:terminal_color_10 = '#50FA7B'
  let g:terminal_color_11 = '#F1FA8C'
  let g:terminal_color_12 = '#BD93F9'
  let g:terminal_color_13 = '#FF79C6'
  let g:terminal_color_14 = '#8BE9FD'
  let g:terminal_color_15 = '#F8F8F2'
endif

" }}}2
" User Configuration: {{{2

if !exists('g:zen_bold')
  let g:zen_bold = 1
endif

if !exists('g:zen_italic')
  let g:zen_italic = 1
endif

if !exists('g:zen_underline')
  let g:zen_underline = 1
endif

if !exists('g:zen_undercurl') && g:zen_underline != 0
  let g:zen_undercurl = 1
endif

if !exists('g:zen_inverse')
  let g:zen_inverse = 1
endif

if !exists('g:zen_colorterm')
  let g:zen_colorterm = 1
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:zen_bold == 1 ? 'bold' : 0,
      \ 'italic': g:zen_italic == 1 ? 'italic' : 0,
      \ 'underline': g:zen_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:zen_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:zen_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), {idx, val -> type(val) == 1})
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " Falls back to coloring foreground group on terminals because
  " nearly all do not support undercurl
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !has('gui_running')
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

"}}}2
" Zen Highlight Groups: {{{2

call s:h('ZenBgLight', s:none, s:bglight)
call s:h('ZenBgLighter', s:none, s:bglighter)
call s:h('ZenBgDark', s:none, s:bgdark)
call s:h('ZenBgDarker', s:none, s:bgdarker)

call s:h('ZenFg', s:fg)
call s:h('ZenFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('ZenFgBold', s:fg, s:none, [s:attrs.bold])
call s:h('ZenFgItalic', s:fg, s:none, [s:attrs.italic])

call s:h('ZenFgDark', s:fgdark)

call s:h('ZenComment', s:comment)
call s:h('ZenCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('ZenSelection', s:none, s:selection)

call s:h('ZenSubtle', s:subtle)

call s:h('ZenCyan', s:cyan)
call s:h('ZenCyanItalic', s:cyan, s:none, [s:attrs.italic])
call s:h('ZenLightCyan', s:lightcyan)

call s:h('ZenGreen', s:green)
call s:h('ZenGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('ZenGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('ZenGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('ZenOrange', s:orange)
call s:h('ZenOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('ZenOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('ZenOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('ZenOrangeInverse', s:bg, s:orange)

call s:h('ZenPink', s:pink)
call s:h('ZenPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('ZenPurple', s:purple)
call s:h('ZenPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('ZenPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('ZenRed', s:red)
call s:h('ZenRedInverse', s:fg, s:red)
call s:h('ZenRedish', s:redish)

call s:h('ZenYellow', s:yellow)
call s:h('ZenYellowItalic', s:yellow, s:none, [s:attrs.italic])
call s:h('ZenYellowish', s:yellowish)
call s:h('ZenYellowishBold', s:yellowish, s:none, [s:attrs.bold])

call s:h('ZenError', s:red, s:none, [s:attrs.undercurl], s:red)
call s:h('ZenWarn', s:orange, s:none, [s:attrs.undercurl], s:orange)

call s:h('ZenErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('ZenWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('ZenInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

"call s:h('ZenTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('ZenTodo', s:pink, s:none, [s:attrs.bold, s:attrs.inverse])
"call s:h('ZenSearch', s:green, s:none, [s:attrs.inverse])
call s:h('ZenSearch', s:fgdarkish, s:none, [s:attrs.bold, s:attrs.inverse, s:attrs.underline])
call s:h('ZenBoundary', s:comment, s:bgdark)
call s:h('ZenLink', s:cyan, s:none, [s:attrs.underline])

call s:h('ZenDiffChange', s:none, s:none)
call s:h('ZenDiffText', s:bg, s:orange)
call s:h('ZenDiffDelete', s:red, s:bgdark)

call s:h('ZenSpecial', s:special)
" }}}2

" }}}
" User Interface: {{{

" Core: {{{2
set background=dark
call s:h('Normal', s:fg, g:zen_colorterm == 1 ? s:bg : s:none)

hi! link Visual ZenSelection
hi! link VisualNOS Visual
hi! link Search ZenSearch
hi! link IncSearch ZenOrangeInverse

" Status / Command Line
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])

" Tabs
hi! link TabLine ZenBoundary
hi! link TabLineFill ZenBgDarker
hi! link TabLineSel Normal

" Popup Menu
hi! link Pmenu ZenBgDark
hi! link PmenuSel ZenSelection
hi! link PmenuSbar ZenBgDark
hi! link PmenuThumb ZenSelection

" Messages
hi! link ErrorMsg ZenRedInverse
hi! link WarningMsg ZenOrangeInverse
hi! link ModeMsg ZenFgBold
hi! link MoreMsg ZenFgBold
hi! link Question ZenFgBold
hi! link Title ZenGreenBold

" Folds
hi! link Folded ZenBoundary
hi! link VertSplit ZenBoundary
hi! link FoldColumn ZenSubtle

" Line Numbers
hi! link CursorLineNr ZenYellow
"hi! link LineNr ZenComment
hi LineNr guifg=#9fafaf  ctermfg=248 
hi! link SignColumn ZenComment

" Whitespace / Non-text
call s:h('CursorLine', s:none, s:subtle) " Required as some plugins will overwrite
" hi! Cursor guifg=bg guibg=fg ctermfg=bg ctermbg=fg gui=underline cterm=underline
hi! link NonText ZenSubtle
hi! link CursorColumn ZenSelection
hi! link ColorColumn ZenSelection

" Diffs
hi! link DiffAdd ZenGreen
hi! link DiffChange ZenDiffChange
hi! link DiffText ZenDiffText
hi! link DiffDelete ZenDiffDelete

"}}}2
" NetRW: {{{2

hi! link Directory ZenPurpleBold

" }}}2
" GitGutter: {{{2
hi! link GitGutterAdd ZenGreen
hi! link GitGutterChange ZenYellow
hi! link GitGutterChangeDelete ZenOrange
hi! link GitGutterDelete ZenRed
"}}}2

" }}}
" Syntax: {{{

hi! link Comment ZenComment
hi! link Underlined ZenFgUnderline
hi! link Todo ZenTodo

hi! link Error ZenError
hi! link SpellBad ZenErrorLine
hi! link SpellLocal ZenWarnLine
hi! link SpellCap ZenInfoLine
hi! link SpellRare ZenInfoLine

" hi! link Constant ZenPurple
hi! link Constant ZenLightCyan
hi! link String ZenRedish
hi! link Character ZenRedish
hi! link Number ZenPurple
hi! link Boolean ZenPurple
hi! link Float ZenPurple 
" hi! link Number Constant
" hi! link Boolean Constant
" hi! link Float Constant

"hi! link Identifier ZenFg
hi! link Identifier ZenSpecial
hi! link Function ZenGreen

" pink
hi! link Statement ZenYellowishBold
hi! link Conditional ZenYellowishBold
hi! link Repeat ZenYellowishBold
hi! link Label ZenYellowishBold
hi! link Operator ZenYellowish
hi! link Keyword ZenYellowishBold
hi! link Exception ZenYellowishBold

" pink
hi! link PreProc ZenYellowishBold
hi! link Include ZenYellowishBold
hi! link Define ZenYellowishBold
hi! link Macro ZenYellowishBold
hi! link PreCondit ZenYellowishBold
hi! link StorageClass ZenYellowishBold
hi! link Structure ZenYellowishBold
hi! link Typedef ZenYellowishBold

hi! link Type ZenCyan

"hi! link Delimiter ZenFg
hi! link Delimiter ZenFgDark

"hi! link Special ZenPink
hi! link Special ZenSpecial
hi! link SpecialKey ZenRed
"hi! link SpecialComment ZenCyanItalic
hi! link SpecialComment ZenCommentBold
hi! link Tag ZenCyan
hi! link helpHyperTextJump ZenLink
hi! link helpCommand ZenPurple
hi! link helpExample ZenGreen

call s:h('MatchParen', s:white, s:black, [s:attrs.bold, s:attrs.underline])
call s:h('Conceal', s:special, s:bg)

" CSS: {{{2

hi! link cssAttrComma Delimiter
hi! link cssBraces Delimiter
hi! link cssSelectorOp Delimiter
hi! link cssFunctionComma Delimiter
hi! link cssAttributeSelector ZenGreenItalic
hi! link cssAttrRegion ZenPink
hi! link cssUnitDecorators ZenPink
hi! link cssProp ZenCyan
hi! link cssPseudoClassId ZenGreenItalic

"}}}2
" Git Commit: {{{2

" These groups appear when editing commit messages.
" They are not part of the Diff interface of vim diff

" The following two are misnomers. Colors are correct.
hi! link diffFile ZenGreen
hi! link diffNewFile ZenRed

hi! link diffLine ZenCyanItalic
hi! link diffRemoved ZenRed
hi! link diffAdded ZenGreen

"}}}2
" HTML: {{{2

hi! link htmlTag ZenFg
hi! link htmlArg ZenGreenItalic
hi! link htmlTitle ZenFg
hi! link htmlH1 ZenFg
hi! link htmlSpecialChar ZenPurple

"}}}2
" JavaScript: {{{2

hi! link javaScriptBraces Delimiter
hi! link javaScriptNumber Constant
hi! link javaScriptNull Constant
hi! link javaScriptFunction ZenPink

"}}}2
" Markdown: {{{2

hi! link markdownH1 ZenPurpleBold
hi! link markdownH2 markdownH1
hi! link markdownH3 markdownH1
hi! link markdownH4 markdownH1
hi! link markdownH5 markdownH1
hi! link markdownH6 markdownH1
hi! link markdownHeadingDelimiter markdownH1
hi! link markdownHeadingRule markdownH1

hi! link markdownBold ZenOrangeBold
" hi! link markdownItalic ZenYellowItalic
hi! link markdownItalic ZenFgItalic
hi! link markdownBoldItalic ZenOrangeBoldItalic

hi! link markdownBlockquote ZenCyan

hi! link markdownCode ZenGreen
hi! link markdownCodeDelimiter ZenGreen

hi! link markdownListMarker ZenCyan
hi! link markdownOrderedListMarker ZenCyan

hi! link markdownRule ZenComment

hi! link markdownLinkText ZenPink
hi! link markdownUrl ZenLink

"}}}2
" Ruby: {{{2

let g:ruby_operators=1
hi! link rubyStringDelimiter ZenYellow
hi! link rubyInterpolationDelimiter ZenPink
hi! link rubyCurlyBlock ZenPink
hi! link rubyBlockParameter ZenOrangeItalic
hi! link rubyBlockArgument ZenOrangeItalic
hi! link rubyInstanceVariable ZenPurpleItalic
hi! link rubyGlobalVariable ZenPurple
hi! link rubyRegexpDelimiter ZenRed

"}}}2
" YAML: {{{2

hi! link yamlBlockMappingKey ZenCyan
hi! link yamlPlainScalar ZenYellow
hi! link yamlAnchor ZenPinkItalic
hi! link yamlAlias ZenGreenItalicUnderline
hi! link yamlNodeTag ZenPink
hi! link yamlFlowCollection ZenPink
hi! link yamlFlowIndicator Delimiter

"}}}2
" Vim Script: {{{2

hi! link vimOption ZenCyanItalic
hi! link vimAutoEventList ZenCyanItalic
hi! link vimAutoCmdSfxList ZenCyanItalic
hi! link vimSetSep Delimiter
hi! link vimSetMod ZenPink
hi! link vimHiBang ZenPink
hi! link vimEnvVar ZenPurple
hi! link vimUserFunc ZenGreen
hi! link vimFunction ZenGreen
hi! link vimUserAttrbCmpltFunc ZenGreen

"}}}2

"}}}

" vim: fdm=marker ts=2 sts=2 sw=2:
