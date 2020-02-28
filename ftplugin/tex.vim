setlocal conceallevel=2
set foldlevel=99

" defaults to asyncrun-project-root
let b:ale_lsp_root = asyncrun#get_root("%")

" override textobj-comment
xmap <buffer> ic <Plug>(vimtex-ic)
omap <buffer> ic <Plug>(vimtex-ic)
xmap <buffer> ac <Plug>(vimtex-ac)
omap <buffer> ac <Plug>(vimtex-ac)
