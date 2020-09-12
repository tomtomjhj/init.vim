setlocal tabstop=2 shiftwidth=2
setlocal conceallevel=2
setlocal foldlevel=99

" defaults to asyncrun-project-root
let b:ale_lsp_root = asyncrun#get_root("%")

call SetupLSP()
" override textobj-comment
xmap <buffer> ic <Plug>(vimtex-ic)
omap <buffer> ic <Plug>(vimtex-ic)
xmap <buffer> ac <Plug>(vimtex-ac)
omap <buffer> ac <Plug>(vimtex-ac)
nmap <buffer><silent><leader>oo :call Zathura("<C-r>=expand("%:p:h").'/main.pdf'<CR>")<CR>
