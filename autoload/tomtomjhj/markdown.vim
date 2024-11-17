" text object {{{1
func! tomtomjhj#markdown#FencedCodeBlocka()
    if get(g:, 'nvim_latest_stable', 0)
        return luaeval('require("tomtomjhj.markdown").fenced_codeblock(true)')
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
        return luaeval('require("tomtomjhj.markdown").fenced_codeblock(false)')
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

" go to anchor {{{1
" [path, anchor]
function! tomtomjhj#markdown#target(url) abort
    let match = matchlist(a:url, '\v^(\f{-})%(/)?%(#(\f*))?$')
    if empty(match) | return ['', ''] | endif
    let path = match[1]
    if !empty(path)
        " In GFM, path starting with '/' is relative wrt. repository root
        if path[0] ==# '/'
            let path = FugitiveWorkTree() . path
        else " relative
            let path = simplify(fnamemodify(bufname('%'), ':p:h') . '/' . path)
        endif
    endif
    return [path, match[2]]
endfunction

function! tomtomjhj#markdown#goto(open) abort
    " Not using tagfunc because it uses cword
    let [path, anchor] = tomtomjhj#markdown#target(expand('<cfile>'))
    if !empty(path) && !filereadable(path)
        echo 'File not found: "' . path . '"'
        return
    endif

    let buf = empty(path) ? bufnr('%') : bufadd(path)
    if empty(anchor) | exe a:open buf | return | endif
    let headings = luaeval('require("tomtomjhj.markdown").headings(_A)', buf)
    let anchor_pat = substitute(anchor, '-', '', 'g')
    let matched = matchfuzzy(headings, anchor_pat, #{matchseq: 1, key: 'text'})
    if empty(matched)
        exe a:open buf
        echo 'No match found for "' . anchor . '"'
        return
    endif

    normal! m'
    let from = getpos('.') | let from[0] = bufnr('%')
    call settagstack(win_getid(), #{items: [#{tagname: anchor_pat, from: from}]}, 't')
    exe printf('keepjumps %s +%d %d', a:open, matched[0].line, buf)
    normal! zv
endfunction

" NOTE: Ideally it should implement https://github.com/Flet/github-slugger, but that's too complex.
function! tomtomjhj#markdown#slug(text) abort
    let text = substitute(a:text, '\s\+', '-', 'g')
    " Remove non-keywords chars
    let text = substitute(text, '\v(\k|_|-)@!.', '', 'g')
    " \k may include ascii punctuations. Remove them.
    let text = substitute(text, '\v(_|-)@![[:punct:]]', '', 'g')
    " Remove emoji. Pattern taken from syntax/mail.vim
    let text = substitute(text, '\%#=2\v[\U1f300-\U1f64f\U1f900-\U1f9ff]', '', 'g')
    return tolower(text)
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
