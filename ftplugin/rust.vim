if !exists('b:AutoPairs')
    let b:AutoPairs = AutoPairsDefine({'|': '|'}, ["'"])
endif

" https://github.com/neoclide/coc.nvim/issues/1981#issuecomment-634690468
call SetupCoc()
nmap <buffer><leader>C :AsyncRun -program=make -post=CW test --no-run<CR>
vmap <buffer><leader>fm :RustFmtRange<CR>
" using ale-rls
nmap <buffer>]a <Plug>(ale_next_wrap)
nmap <buffer>[a <Plug>(ale_previous_wrap)
