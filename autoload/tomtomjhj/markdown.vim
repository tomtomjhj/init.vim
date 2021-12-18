" text object {{{1
func! tomtomjhj#markdown#FencedCodeBlocka()
    if !InSynStack('\v(mkdSnippet|mkdCode|pandocDelimitedCodeBlock)')
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
    if !InSynStack('\v(mkdSnippet|mkdCode|pandocDelimitedCodeBlock)')
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

" folding {{{1
" adapted tpope/vim-markdown/ftplugin/markdown.vim + plasticboy/vim-markdown pythonic foldtext
" NOTE: doesn't handle yaml front matter

function! s:IsCodeBlock(lnum) abort
    return InSynStack('^mkd\%(Code\|Snippet\)', synstack(a:lnum, 1))
endfunction

function! tomtomjhj#markdown#foldexpr() abort
    let line = getline(v:lnum)
    let hashes = matchstr(line, '^#\+')
    let is_code = -1
    if !empty(hashes)
        let is_code = s:IsCodeBlock(v:lnum)
        if !is_code
            return ">" . len(hashes)
        endif
    endif
    if !empty(line)
        let nextline = getline(v:lnum + 1)
        if nextline =~ '^=\+$'
            if is_code == -1
                let is_code = s:IsCodeBlock(v:lnum)
            endif
            if !is_code
                return ">1"
            endif
        endif
        if nextline =~ '^-\+$'
            if is_code == -1
                let is_code = s:IsCodeBlock(v:lnum)
            endif
            if !is_code
                return ">2"
            endif
        endif
    endif
    return "="
endfunction

function! tomtomjhj#markdown#foldtext()
    let line = getline(v:foldstart)
    let has_numbers = &number || &relativenumber
    let nucolwidth = &fdc + has_numbers * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 6
    let foldedlinecount = v:foldend - v:foldstart
    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let line = substitute(line, '\%("""\|''''''\)', '', '')
    let fillcharcount = windowwidth - strdisplaywidth(line) - len(foldedlinecount) + 1
    return line . ' ' . repeat("-", fillcharcount) . ' ' . foldedlinecount
endfunction

" etc {{{1
" TODO: refactor
" * use ++once
" * --defaults file in dots repo https://pandoc.org/MANUAL.html#default-files
" * option for --pdf-engine=xelatex .. or more general command
" * --from=commonmark_x by default? https://github.com/jgm/pandoc/wiki/Roadmap#pandocs-markdown-transition-to-commonmark
" * remove pandoc-citeproc? (2.11 got built-in citation support)
" * project-local include?
" * more run options
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p --from commonmark_x -o %:p:h/%:t:r.docx
"   * AsyncRun -save=1 -cwd=%:p:h pandoc %:p -o %:p:h/%:t:r.txt --strip-comments
"     * NOTE: --strip-comment doesn't work for commonmark_x. Manual says "This
"       does not apply to HTML comments inside raw HTML blocks when the
"       markdown_in_html_blocks extension is not set.". Regardless of whether
"       commonmark_x supports markdown_in_html_blocks, shouldn't it strip
"       top-level comments?
"       https://github.com/jgm/pandoc/issues/2552
func! tomtomjhj#markdown#RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    let params = '-Vurlcolor=blue --highlight-style=kate'
    " need to pass --filter=pandoc-citeproc here in order to specify bibliography in yaml
    if executable('pandoc-citeproc')
        let params .= ' --filter=pandoc-citeproc'
    endif
    let post = "exec 'au! pandoc_quickfix'"
    let post .= a:open ? "|call Zathura('" . l:out . "',!g:asyncrun_code)" : ''
    let post = escape(post, ' ')
    " set manually or by local vimrc, override header-includes in yaml metadata
    " TODO: local_vimrc or editorconfig hook
    if exists('b:custom_pandoc_include_file')
        let l:params .= ' --include-in-header=' . b:custom_pandoc_include_file
    endif
    let cmd = 'pandoc ' . l:src . ' -o ' . l:out . ' ' . l:params
    augroup pandoc_quickfix | au!
        au QuickFixCmdPost caddexpr belowright copen 8 | winc p
    augroup END
    exec 'AsyncRun -save=1 -cwd=' . expand("%:p:h") '-post=' . l:post l:cmd
endfunc
" vim: set fdm=marker fdl=0:
