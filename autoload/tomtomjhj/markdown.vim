" text object {{{1
func! tomtomjhj#markdown#FencedCodeBlocka()
    if !InSynStack('\v(markdownCode|markdownHighlight|pandocDelimitedCodeBlock)')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    let head_pos[2] = 1
    if !search('```', 'W') | return 0 | endif
    exec 'norm! E'
    let tail_pos = getpos('.')
    return ['V', head_pos, tail_pos]
endfunc
func! tomtomjhj#markdown#FencedCodeBlocki()
    if !InSynStack('\v(markdownCode|markdownHighlight|pandocDelimitedCodeBlock)')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    exec 'norm! j0'
    let head_pos = getpos('.')
    let head_pos[2] = 1
    if !search('```', 'W') | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['V', head_pos, tail_pos]
endfunc

func! tomtomjhj#markdown#PandocDollarMatha()
    if !InSynStack('pandocLaTeXInlineMath')
        return 0
    endif
    if !search('\v\$', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! tomtomjhj#markdown#PandocDollarMathi()
    if !InSynStack('pandocLaTeXInlineMath')
        return 0
    endif
    if !search('\v\$', 'bW') | return 0 | endif
    exec 'norm! l'
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    exec 'norm! h'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! tomtomjhj#markdown#PandocDollarMathMatha()
    if !InSynStack('pandocLaTeXMathBlock')
        return 0
    endif
    if !search('\v\$\$', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('\v\$\$', 'W') | return 0 | endif
    exec 'norm! l'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! tomtomjhj#markdown#PandocDollarMathMathi()
    if !InSynStack('pandocLaTeXMathBlock')
        return 0
    endif
    if !search('\v\$\$', 'bW') | return 0 | endif
    exec 'norm! l'
    call search('\v\S', 'W')
    let head_pos = getpos('.')
    if !search('\v\$\$', 'W')  | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc

" etc {{{1
" TODO: refactor
" * --defaults file in dots repo https://pandoc.org/MANUAL.html#default-files
" * option for --pdf-engine=xelatex .. or more general command
" * --from=commonmark_x by default? https://github.com/jgm/pandoc/wiki/Roadmap#pandocs-markdown-transition-to-commonmark
"   * NOTE: commonmark_x seems to break latex in header-includes..
" * project-local include?
" * more run options
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p --from commonmark_x -o %:p:h/%:t:r.docx
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p --from commonmark_x -o %:p:h/%:t:r.txt --strip-comments
func! tomtomjhj#markdown#RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    let params = '-Vurlcolor=blue --highlight-style=kate'
    let post = a:open ? "call Zathura('" . l:out . "',!g:asyncrun_code)" : ''
    let post = escape(post, ' ')
    " set manually or by local vimrc, override header-includes in yaml metadata
    " TODO: local_vimrc or editorconfig hook
    if exists('b:custom_pandoc_include_file')
        let l:params .= ' --include-in-header=' . b:custom_pandoc_include_file
    endif
    let cmd = 'pandoc ' . l:src . ' -o ' . l:out . ' ' . l:params
    augroup pandoc_quickfix | au!
        au QuickFixCmdPost pandoc ++once belowright copen 8 | winc p
    augroup END
    exec 'AsyncRun -save=1 -cwd=' . expand("%:p:h") '-auto=pandoc' '-post=' . l:post l:cmd
endfunc
" vim: set fdm=marker fdl=0:
