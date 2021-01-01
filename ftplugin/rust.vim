" TODO fix 'spellcapcheck' for `//!` comments, also fix <leader>sc mapping
"
" https://github.com/neoclide/coc.nvim/issues/1981#issuecomment-634690468
call SetupLSP()

if g:ide_client == 'coc'
    command! ExpandMacro CocCommand rust-analyzer.expandMacro
endif

nmap <buffer><leader>C :AsyncRun -program=make -post=CW test --no-run<CR>
vmap <buffer><leader>fm :RustFmtRange<CR>
