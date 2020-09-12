setl tabstop=2 shiftwidth=2

call SetupLSP()
" ocamlformat on ocaml-lsp doesn't format stuff
nmap <buffer><leader>fm <Plug>(ale_fix)
nmap <buffer><leader>C :AsyncRun -program=make -post=CocRestart<CR>
