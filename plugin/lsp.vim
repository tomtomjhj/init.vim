function! SetupALELSP()
  nmap <M-.> <Plug>(ale_hover)
  nmap <M-]> <Plug>(ale_go_to_definition)
  nmap <silent><M-\> <Plug>(ale_go_to_definition_in_tab)
  nmap <silent><leader><M-\> :if IsWide() \| ALEGoToDefinitionInVSplit \| else \| ALEGoToDefinitionInSplit \| endif<CR>
  nmap <leader>rn :ALERename<CR>
  nmap <leader>rf <Plug>(ale_find_references)
endfunction

let g:coc_quickfix_open_command = 'CW'
let g:coc_fzf_preview = 'up:66%'

function! SetupCoc()
  if !get(g:, 'coc_enabled', 0) | return | endif
  augroup CocCurrentFunction | au!
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

augroup CocStuff
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
  " TODO: coc resets showbreak on flotwin hover. showbreak is not local in nvim!
  " https://github.com/vim/vim/commit/ee85702c10495041791f728e977b86005c4496e8
  autocmd User CocOpenFloat set showbreak=>\ 
  autocmd BufLeave list://* hi! CursorLine cterm=NONE gui=NONE
  autocmd BufEnter list://* hi! CursorLine cterm=underline gui=underline
  " https://github.com/neoclide/coc.nvim/issues/2043
  autocmd VimLeave * call coc#rpc#kill()
augroup end

command! -nargs=0 Format call CocAction('format')
" TODO fold level too high in some languages (e.g. ccls)
command! -nargs=? Fold   call CocAction('fold', <f-args>)
command! -nargs=1 -complete=file Pedit call s:Pedit(<f-args>)

" CocAction jumpDefinition assumes that openCommand changes the current window
" to the target file, but :pedit doesn't.
function! s:Pedit(file)
  exe 'pedit' a:file
  wincmd P
endfunction

" TODO: nvim lsp stuff
" https://www.reddit.com/r/neovim/comments/grrxli/start_to_finish_example_of_setting_up_built_in/fs17mxy
" https://nathansmith.io/posts/neovim-lsp
" https://sharksforarms.dev/posts/neovim-rust/
" Plug 'nvim-lua/diagnostic-nvim'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
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
