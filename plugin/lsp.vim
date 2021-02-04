if g:ide_client == 'coc' " {{{
function! SetupLSP()
  if !get(g:, 'coc_enabled', 0) | return | endif
  augroup LocalCocStuff | au!
    au User CocJumpPlaceholder <buffer> call CocActionAsync('showSignatureHelp')
    au CursorHold <buffer> call CocActionAsync('getCurrentFunctionSymbol', { e, r -> 0 })
  augroup END
  nmap     <silent><buffer>        <M-[> <Plug>(coc-definition)
  nmap     <silent><buffer>        <M-]> <Plug>(coc-definition)
  nmap     <silent><buffer><leader><M-\> :call CocAction('jumpDefinition', 'tabe')<CR>
  nmap     <silent><buffer>        <M-\> :call CocAction('jumpDefinition', winwidth(0)>170 ? 'vsplit' : 'split')<CR>
  nmap     <silent><buffer>       <M-\|> :call CocAction('jumpDefinition', 'Pedit')<CR><C-w>p
  " TODO: preview hover doesn't use the renderer used for float hover
  nmap     <silent><buffer>        <M-.> :call CocActionAsync('doHover')<CR>
  nmap     <silent><buffer>        <M-,> :call CocAction('diagnosticInfo')<CR>
  nmap     <silent><buffer><leader>gy    <Plug>(coc-type-definition)
  nmap     <silent><buffer><leader>gi    <Plug>(coc-implementation)
  nmap     <silent><buffer><leader>rf    <Plug>(coc-references-used)
  nmap             <buffer><leader>rn    <Plug>(coc-rename)
  nmap     <silent><buffer><leader>fm    <Plug>(coc-format)
  vmap     <silent><buffer><leader>fm    <Plug>(coc-format-selected)
  nmap     <silent><buffer><leader>fd    :exe 'normal! zE'\|Fold<CR>
  nnoremap <silent><buffer><leader><tab> v:<C-u>call CocAction('rangeSelect', visualmode(),  v:true)<CR>
  xnoremap <silent><buffer><leader><tab>  :<C-u>call CocAction('rangeSelect', visualmode(),  v:true)<CR>
  xnoremap <silent><buffer>      <S-tab>  :<C-u>call CocAction('rangeSelect', visualmode(), v:false)<CR>
  nmap             <buffer><leader>ac    <Plug>(coc-codelens-action)
  nmap     <silent><buffer><leader>O     :<C-u>CocFzfList outline<CR>
  nmap     <silent><buffer><leader>sb    :<C-u>CocFzfList symbols<CR>
  nmap     <silent><buffer><leader>dl    :<C-U>CocFzfList diagnostics<CR>
  nmap     <silent><buffer>        [a    <Plug>(coc-diagnostic-prev)
  nmap     <silent><buffer>        ]a    <Plug>(coc-diagnostic-next)
endfunction

function! CurrentFunction()
  return get(b:,'coc_current_function', '')
endfunction
function! CheckerStatus()
  return get(g:, 'coc_status', '')
endfunction
function! CheckerErrors()
  if has_key(b:, 'coc_diagnostic_info')
    let errors = b:coc_diagnostic_info['error']
    return errors ? 'E' . errors : ''
  endif
  return ''
endfunction
function! CheckerWarnings()
  if has_key(b:, 'coc_diagnostic_info')
    let warnings = b:coc_diagnostic_info['warning']
    return warnings ? 'W' . warnings : ''
  endif
  return ''
endfunction

augroup GlobalCocStuff
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
  " TODO: coc resets showbreak on flotwin hover. showbreak is not local in nvim!
  " https://github.com/vim/vim/commit/ee85702c10495041791f728e977b86005c4496e8
  autocmd User CocOpenFloat set showbreak=>\ 
  autocmd BufLeave list://* hi! CursorLine cterm=NONE gui=NONE
  autocmd BufEnter list://* hi! CursorLine cterm=underline gui=underline
  " https://github.com/neoclide/coc.nvim/issues/2043
  autocmd VimLeave * call coc#rpc#kill()
  " NOTE: some langs need to override Coc mappings
  autocmd FileType json,sh,javascript,typescript,lua call SetupLSP()
augroup end

command! -nargs=0 Format call CocAction('format')
" TODO fold level too high in some languages (e.g. ccls)
command! -nargs=? Fold   call CocAction('fold', <f-args>)
" }}}

elseif g:ide_client == 'nvim' " {{{
lua << EOF
tomtomjhj.lsp = require('tomtomjhj/lsp')
EOF

function! SetupLSP()
  augroup LocalNvimLSPStuff | au!
    " NOTE: g:completion_enable_auto_signature
  augroup END
  nnoremap <buffer><silent>        <M-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer><silent>        <M-.> <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer><silent><leader>gi    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <buffer><silent><leader>gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <buffer><silent><leader>rf    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <buffer><silent><leader>gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <buffer><silent><leader>fm    <cmd>lua vim.lsp.buf.formatting()<CR>
  nnoremap <buffer><silent><leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer><silent>        [a    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
  nnoremap <buffer><silent>        ]a    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
  " nnoremap <buffer><silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  " nnoremap <buffer><silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  " nnoremap <buffer><silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  " TODO: goto def in split, etc
  " TODO: hover in preview window
  " TODO: codelens not implemented
endfunction

function! CurrentFunction()
  return get(b:,'lsp_current_function', '')
endfunction
function! CheckerStatus()
  return v:lua.tomtomjhj.lsp.status()
endfunction
function! CheckerErrors()
  if luaeval('#vim.lsp.buf_get_clients() > -1')
    let errors = luaeval('vim.lsp.diagnostic.get_count(0, "Error")')
    return errors ? 'E' . errors : ''
  endif
  return ''
endfunction
function! CheckerWarnings()
  if luaeval('#vim.lsp.buf_get_clients() > -1')
    let warnings = luaeval('vim.lsp.diagnostic.get_count(0, "Warning")')
    return warnings ? 'W' . warnings : ''
  endif
  return ''
endfunction

augroup GlobalNvimLSPStuff | au!
    au InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
                \ lua require'lsp_extensions'.inlay_hints{ prefix = '‣ ', highlight = "TypeHint", enabled = {"ChainingHint"} }
    au User LspDiagnosticsChanged call lightline#update()
    au FileType lua call SetupLSP()
augroup end
" }}}

else " ale {{{
function! SetupLSP()
  nmap <buffer><M-.> <Plug>(ale_hover)
  nmap <buffer><M-]> <Plug>(ale_go_to_definition)
  nmap <buffer><silent><M-\> <Plug>(ale_go_to_definition_in_tab)
  nmap <buffer><silent><leader><M-\> :if IsWide() \| ALEGoToDefinitionInVSplit \| else \| ALEGoToDefinitionInSplit \| endif<CR>
  nmap <buffer><leader>rn :ALERename<CR>
  nmap <buffer><leader>rf <Plug>(ale_find_references)
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
endif " }}}

" utils {{{
" CocAction jumpDefinition assumes that openCommand changes the current window
" to the target file, but :pedit doesn't.
command! -nargs=1 -complete=file Pedit call s:Pedit(<f-args>)
function! s:Pedit(file)
  exe 'pedit' a:file
  wincmd P
endfunction
" }}}
" vim: set fdm=marker fdl=0 et ts=2 sw=2:
