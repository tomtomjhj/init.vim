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
  nmap     <silent><buffer>       <M-\|> :call CocAction('jumpDefinition', 'pedit')<CR>
  nmap     <silent><buffer>        <M-.> :call CocAction('doHover')<CR>
  nmap     <silent><buffer>        <M-,> :call CocAction('diagnosticInfo')<CR>
  nmap     <silent><buffer><leader>gy    <Plug>(coc-type-definition)
  nmap     <silent><buffer><leader>gi    <Plug>(coc-implementation)
  nmap     <silent><buffer><leader>rf    <Plug>(coc-references)
  nmap             <buffer><leader>rn    <Plug>(coc-rename)
  nmap     <silent><buffer><leader>fm    <Plug>(coc-format)
  vmap     <silent><buffer><leader>fm    <Plug>(coc-format-selected)
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
  " TODO: coc resets showbreak on hover.
  " showbreak is not local in nvim!
  " https://github.com/vim/vim/commit/ee85702c10495041791f728e977b86005c4496e8
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

" TODO: nvim lsp stuff
" Plug 'haorenW1025/diagnostic-nvim'
" Plug 'haorenW1025/completion-nvim'
" lua << EOF
" local nvim_lsp = require'nvim_lsp'
" nvim_lsp.ocamllsp.setup{}
" EOF
" nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" vim: set sw=2 ts=2:
