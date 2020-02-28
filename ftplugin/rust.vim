if !exists('b:AutoPairs')
    let b:AutoPairs = AutoPairsDefine({'|': '|'}, ["'"])
endif

if executable('rust-analyzer')
    call LCMaps()
endif

nmap <buffer><leader>C :AsyncRun -program=make -post=OQ test --no-run<CR>
vmap <buffer><leader>af :RustFmtRange<CR>
