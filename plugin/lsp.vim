function! SetupALELSP()
  nmap <M-.> <Plug>(ale_hover)
  nmap <M-]> <Plug>(ale_go_to_definition)
  nmap <silent><M-\> <Plug>(ale_go_to_definition_in_tab)
  nmap <silent><leader><M-\> :if IsWide() \| ALEGoToDefinitionInVSplit \| else \| ALEGoToDefinitionInSplit \| endif<CR>
  nmap <leader>rn :ALERename<CR>
  nmap <leader>rf <Plug>(ale_find_references)
endfunction

function! SetupLSP()
endfunction

function! CheckerStatus()
  return ''
endfunction
function! CheckerErrors()
  return ''
endfunction
function! CheckerWarnings()
  return ''
endfunction

" vim: set sw=2 ts=2 fdm=marker fdl=0:
