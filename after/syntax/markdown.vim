let s:conceal = ''
let s:concealends = ''
let s:concealcode = ''
if has('conceal') && get(g:, 'vim_markdown_conceal', 1)
  let s:conceal = ' conceal'
  let s:concealends = ' concealends'
endif
if has('conceal') && get(g:, 'vim_markdown_conceal_code_blocks', 1)
  let s:concealcode = ' concealends'
endif

" additions to HTML groups
if get(g:, 'vim_markdown_emphasis_multiline', 1)
    let s:oneline = ''
else
    let s:oneline = ' oneline'
endif

" Since `_` is frequently used without guard, remove it from mkdItalic.  Most
" of `_` pairs still work thanks to
" `syn region htmlItalic matchgroup=mkdItalic ...` stuff.
" But for an unknown reason, `\ze\S` is needed at the start.
syn clear mkdItalic
syn region mkdItalic matchgroup=mkdItalic start="\*\ze\S" end="\*"
" TODO: https://github.github.com/gfm/#emphasis-and-strong-emphasis
execute 'syn region htmlItalic matchgroup=mkdItalic start="\*\ze[^\\\*\t ]\%(\%([^*]\|\\\*\|\n\)*[^\\\*\t ]\)\?\*\_W" end="[^\\\*\t ]\zs\*\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlItalic matchgroup=mkdItalic start="\W\zs_\ze[^\\_\t ]" end="[^\\_\t ]\zs_\ze\_W" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\*\*\ze\S" end="\S\zs\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBold matchgroup=mkdBold start="\W\zs__\ze\S" end="\S\zs__" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\*\*\*\ze\S" end="\S\zs\*\*\*" keepend contains=@Spell' . s:oneline . s:concealends
execute 'syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\W\zs___\ze\S" end="\S\zs___" keepend contains=@Spell' . s:oneline . s:concealends

syn case match
syn sync minlines=200
