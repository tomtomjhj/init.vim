func! MkdFencedCodeBlocka()
    if !InSynStack('mkdSnippet')
        return 0
    endif
    if !search('```\w*', 'bW') | return 0 | endif
    let head_pos = getpos('.')
    if !search('```', 'W') | return 0 | endif
    exec 'norm! E'
    let tail_pos = getpos('.')
    return ['v', head_pos, tail_pos]
endfunc
func! MkdFencedCodeBlocki()
    if !InSynStack('mkdSnippet')
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

let s:mkd_textobj = {
            \   'code': {
            \     'select-a-function': 'MkdFencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'MkdFencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \ }
call textobj#user#plugin('markdown', s:mkd_textobj)

function! s:MarkdownSetupFolding()
    if get(g:, "vim_markdown_folding_style_pythonic", 0)
        if get(g:, "vim_markdown_override_foldtext", 1)
            setlocal foldtext=Foldtext_markdown()
        endif
    endif
    setlocal foldexpr=Foldexpr_markdown(v:lnum)
    setlocal foldmethod=expr
endfunction

nmap <buffer>zM :call <SID>MarkdownSetupFolding()\|unmap <lt>buffer>zM<CR>zM
nmap <buffer><leader>pd :set ft=pandoc\|unmap <lt>buffer><lt>leader>pd<CR>
