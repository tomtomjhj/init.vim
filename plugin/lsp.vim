function! SetupALELSP()
  nmap <M-.> <Plug>(ale_hover)
  nmap <M-]> <Plug>(ale_go_to_definition)
  nmap <silent><M-\> <Plug>(ale_go_to_definition_in_tab)
  nmap <silent><leader><M-\> :if IsWide() \| ALEGoToDefinitionInVSplit \| else \| ALEGoToDefinitionInSplit \| endif<CR>
  nmap <leader>rn :ALERename<CR>
  nmap <leader>rf <Plug>(ale_find_references)
endfunction

function! SetupCoc()
  nmap     <silent><buffer>        <M-]> <Plug>(coc-definition)
  nmap     <silent><buffer>        <M-\> :call CocAction('jumpDefinition', 'tabe')<CR>
  nmap     <silent><buffer><leader><M-\> :call CocAction('jumpDefinition', winwidth(0)>170 ? 'vsplit' : 'split')<CR>
  nmap     <silent><buffer>        <M-.> :call CocAction('doHover')<CR>
  nmap     <silent><buffer>        <M-,> :call CocAction('diagnosticInfo')<CR>
  nmap     <silent><buffer><leader>gy    <Plug>(coc-type-definition)
  nmap     <silent><buffer><leader>gi    <Plug>(coc-implementation)
  nmap     <silent><buffer><leader>rf    <Plug>(coc-references)
  nmap             <buffer><leader>rn    <Plug>(coc-rename)
  nmap     <silent><buffer><leader>fm    <Plug>(coc-format)
  vmap     <silent><buffer><leader>fm    <Plug>(coc-format-selected)
  xmap             <buffer>        if    <Plug>(coc-funcobj-i)
  xmap             <buffer>        af    <Plug>(coc-funcobj-a)
  omap             <buffer>        if    <Plug>(coc-funcobj-i)
  omap             <buffer>        af    <Plug>(coc-funcobj-a)
  nmap     <silent><buffer><leader><tab> v<Plug>(coc-range-select)
  xmap     <silent><buffer><leader><tab> <Plug>(coc-range-select)
  xmap     <silent><buffer>      <S-tab> <Plug>(coc-range-select-backward)
  nmap             <buffer><leader>ac    <Plug>(coc-codelens-action)
  nmap     <silent><buffer><leader>O     :<C-u>CocList outline<CR>
  nmap     <silent><buffer><leader>sb    :<C-u>CocList -I symbols<CR>
  nmap     <silent><buffer>        [a    <Plug>(coc-diagnostic-prev)
  nmap     <silent><buffer>        ]a    <Plug>(coc-diagnostic-next)
endfunction
" TODO: how does CocList preview stuff work? so wow.

augroup CocStuff
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  " Highlight the symbol and its references when holding the cursor.
  " autocmd CursorHold * silent call CocActionAsync('highlight')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
  " TODO: nvim local showbreak
  autocmd User CocOpenFloat set showbreak=>\ 
  autocmd BufLeave list://* hi! CursorLine cterm=NONE gui=NONE
  autocmd BufEnter list://* hi! CursorLine cterm=underline gui=underline
augroup end

" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold   :call CocAction('fold', <f-args>)

" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" vim: set sw=2 ts=2:
