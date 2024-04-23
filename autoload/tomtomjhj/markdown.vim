" text object {{{1
func! tomtomjhj#markdown#FencedCodeBlocka()
    if get(g:, 'nvim_latest_stable', 0)
        return luaeval('require("tomtomjhj.treesitter").markdown_fenced_codeblock(true)')
    endif
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
    if get(g:, 'nvim_latest_stable', 0)
        return luaeval('require("tomtomjhj.treesitter").markdown_fenced_codeblock(false)')
    endif
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

function tomtomjhj#markdown#FencedCodeBlockLines() abort
    let view = winsaveview()
    let [_, head, tail] = tomtomjhj#markdown#FencedCodeBlocki()
    call winrestview(view)
    return getline(head[1], tail[1])
endfunction

" etc {{{1
" * --defaults file in dots repo https://pandoc.org/MANUAL.html#default-files
" * option for --pdf-engine=xelatex .. or more general command
" * --from=commonmark_x by default? https://github.com/jgm/pandoc/wiki/Roadmap#pandocs-markdown-transition-to-commonmark
" * -V mainfont="DejaVu Serif" if the doc contains unicode chars (this is NOT fallback mechanism)
" * project-local include?
" * more run options
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p --from commonmark_x -o %:p:h/%:t:r.docx
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p --from commonmark_x -o %:p:h/%:t:r.txt --strip-comments
" * for complex sets of options, use make or something
" * NOTE: 9.1.0276 adds pandoc :compiler
func! tomtomjhj#markdown#RunPandoc(open)
    let src = expand("%:p")
    let out = expand('%:p:s?[.]\w*$?.pdf?')
    let params = '-Vurlcolor=blue --highlight-style=kate'
    let post = 'cwindow'
    if a:open
        let post .= printf(' | if !g:asyncrun_code | call Zathura(%s) | endif', string(l:out))
    endif
    call asyncrun#run(0,
                \ {'save': 1, 'cwd': expand("%:p:h"), 'post': l:post },
                \ 'pandoc ' . shellescape(l:src) . ' -o ' . shellescape(l:out) . ' ' . l:params)
endfunc
" vim: set fdm=marker fdl=0:
