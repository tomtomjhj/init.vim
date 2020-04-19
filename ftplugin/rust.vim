if !exists('b:AutoPairs')
    let b:AutoPairs = AutoPairsDefine({'|': '|'}, ["'"])
endif

call SetupCoc()
nmap <buffer><leader>C :AsyncRun -program=make -post=OQ test --no-run<CR>
vmap <buffer><leader>fm :RustFmtRange<CR>
" using ale-rls
nmap <buffer>]a <Plug>(ale_next_wrap)
nmap <buffer>[a <Plug>(ale_previous_wrap)
