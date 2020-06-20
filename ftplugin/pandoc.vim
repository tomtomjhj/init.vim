func! PandocFencedCodeBlocka()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    exec 'norm! E'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! PandocFencedCodeBlocki()
    if !InSynStack('pandocDelimitedCodeBlock')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    exec 'norm! W'
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    call search('\v\S', 'bW')
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! PandocDollarMatha()
    if !InSynStack('pandocLaTeXInlineMath')
        return 0
    endif
    if !search('\v\$', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('\v\$', 'W') | return 0 | endif
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! PandocDollarMathi()
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
func! PandocDollarMathMatha()
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
func! PandocDollarMathMathi()
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
let s:pandoc_textobj = {
            \   'begin-end': {
            \     'pattern': ['\\begin{[^}]\+}\s*\n\?', '\s*\\end{[^}]\+}'],
            \     'select-a': 'ae',
            \     'select-i': 'ie',
            \   },
            \   'code': {
            \     'select-a-function': 'PandocFencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'PandocFencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \  'dollar-math': {
            \     'select-a-function': 'PandocDollarMatha',
            \     'select-a': 'am',
            \     'select-i-function': 'PandocDollarMathi',
            \     'select-i': 'im',
            \   },
            \  'dollar-mathmath': {
            \     'select-a-function': 'PandocDollarMathMatha',
            \     'select-a': 'aM',
            \     'select-i-function': 'PandocDollarMathMathi',
            \     'select-i': 'iM',
            \   },
            \ }
call textobj#user#plugin('pandoc', s:pandoc_textobj)

" set to notoplevel in haskell.vim
syntax spell toplevel

func! RunPandoc(open)
    let src = expand("%:p")
    let out = expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'
    " need to pass --filter=pandoc-citeproc here in order to specify bibliography in yaml
    let params = '-Vurlcolor=blue --highlight-style=kate'
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

nmap <buffer><silent><leader>C :call RunPandoc(0)<CR>
nmap <buffer><silent><leader>O :call RunPandoc(1)<CR>
nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h") . '/' . expand("%:t:r") . '.pdf'<CR>")<CR>
nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
nmap <buffer><silent><leader>py vid:AsyncRun python3<CR>:CW<CR>
nmap <buffer>zM :call pandoc#folding#Init()\|unmap <lt>buffer>zM<CR>zM
