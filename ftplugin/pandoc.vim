let s:pandoc_textobj = {
            \   'begin-end': {
            \     'pattern': ['\\begin{[^}]\+}\s*\n\?', '\s*\\end{[^}]\+}'],
            \     'select-a': 'ae',
            \     'select-i': 'ie',
            \   },
            \   'code': {
            \     'select-a-function': 'tomtomjhj#markdown#PandocFencedCodeBlocka',
            \     'select-a': 'ad',
            \     'select-i-function': 'tomtomjhj#markdown#PandocFencedCodeBlocki',
            \     'select-i': 'id',
            \   },
            \  'dollar-math': {
            \     'select-a-function': 'tomtomjhj#markdown#PandocDollarMatha',
            \     'select-a': 'am',
            \     'select-i-function': 'tomtomjhj#markdown#PandocDollarMathi',
            \     'select-i': 'im',
            \   },
            \  'dollar-mathmath': {
            \     'select-a-function': 'tomtomjhj#markdown#PandocDollarMathMatha',
            \     'select-a': 'aM',
            \     'select-i-function': 'tomtomjhj#markdown#PandocDollarMathMathi',
            \     'select-i': 'iM',
            \   },
            \ }
call textobj#user#plugin('pandoc', s:pandoc_textobj)
TextobjPandocDefaultKeyMappings!

" set to notoplevel in haskell.vim
syntax spell toplevel

command! -buffer -bang Pandoc call tomtomjhj#markdown#RunPandoc(<bang>0)

nmap <buffer><silent><leader>C :Pandoc<CR>
nmap <buffer><silent><leader>O :Pandoc!<CR>
nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h").'/'.expand("%:t:r").'.pdf'<CR>")<CR>
nmap <buffer><silent>gx <Plug>(pandoc-hypertext-open-system)
nmap <buffer><silent><leader>py vid:AsyncRun python3<CR>:CW<CR>
nmap <buffer>zM :call pandoc#folding#Init()\|unmap <lt>buffer>zM<CR>zM
