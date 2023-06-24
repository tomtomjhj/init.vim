if get(g:, 'ide_client', '') == 'coc' " {{{
function! SetupLSP()
  if !get(g:, 'coc_enabled', 0) | return | endif
  augroup LocalCocStuff | au! * <buffer>
    au User CocJumpPlaceholder <buffer> call CocActionAsync('showSignatureHelp')
    au CursorHold <buffer> call CocActionAsync('getCurrentFunctionSymbol', { e, r -> 0 })
  augroup END
  nmap     <silent><buffer>        <M-[> <Plug>(coc-definition)
  nmap     <silent><buffer>        <M-]> <Plug>(coc-definition)
  nmap     <silent><buffer><leader><M-\> :call CocAction('jumpDefinition', 'tabe')<CR>
  nmap     <silent><buffer>        <M-\> :call CocAction('jumpDefinition', winwidth(0)>170 ? 'vsplit' : 'split')<CR>
  nmap     <silent><buffer>       <M-\|> :call CocAction('jumpDefinition', 'Pedit')<CR><C-w>p
  nmap     <silent><buffer>        <M-.> :call CocActionAsync('doHover')<CR>
  " Send hover float to preview
  nmap     <silent><buffer><leader><M-.> <Plug>(coc-float-jump)<cmd>silent! pedit<CR><C-w>P<cmd>set winhl= nu<CR><C-w>p<Plug>(coc-float-hide)
  nmap     <silent><buffer>        <M-,> :call CocAction('diagnosticInfo')<CR>
  nmap     <silent><buffer><leader>gy    <Plug>(coc-type-definition)
  nmap     <silent><buffer><leader>gi    <Plug>(coc-implementation)
  nmap     <silent><buffer><leader>rf    <Plug>(coc-references-used)
  nmap             <buffer><leader>rn    <Plug>(coc-rename)
  nmap     <silent><buffer><leader>fm    <Plug>(coc-format)
  xmap     <silent><buffer><leader>fm    <Plug>(coc-format-selected)
  nmap     <silent><buffer><leader>fd    :exe 'normal! zE'\|Fold<CR>
  nnoremap <silent><buffer><leader><tab> v:<C-u>call CocAction('rangeSelect', visualmode(),  v:true)<CR>
  xnoremap <silent><buffer><leader><tab>  :<C-u>call CocAction('rangeSelect', visualmode(),  v:true)<CR>
  xnoremap <silent><buffer>      <S-tab>  :<C-u>call CocAction('rangeSelect', visualmode(), v:false)<CR>
  nmap             <buffer><leader>ac    <Plug>(coc-codelens-action)
  nmap     <silent><buffer><leader>ol    :<C-u>CocFzfList outline<CR>
  nmap             <buffer><leader>sb    :<C-u>CocFzfList symbols<space>
  nmap     <silent><buffer><leader>dl    :<C-U>CocFzfList diagnostics<CR>
  nmap     <silent><buffer>        [d    <Plug>(coc-diagnostic-prev)
  nmap     <silent><buffer>        ]d    <Plug>(coc-diagnostic-next)
endfunction

function! STLBreadCrumb()
  return ''
endfunction
function! STLProgress()
  return get(g:, 'coc_status', '')
endfunction
function! STLDiagnosticErrors()
  if has_key(b:, 'coc_diagnostic_info')
    let errors = b:coc_diagnostic_info['error']
    return errors ? 'E' . errors : ''
  endif
  return ''
endfunction
function! STLDiagnosticWarnings()
  if has_key(b:, 'coc_diagnostic_info')
    let warnings = b:coc_diagnostic_info['warning']
    return warnings ? 'W' . warnings : ''
  endif
  return ''
endfunction

augroup GlobalCocStuff
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " TODO: Cursor disappears after redrawstatus in terminal vim.
  " CocStatusChange is fired on the first CursorHold after moving Cursor.
  if has('nvim') || has('gui_running')
    autocmd User CocStatusChange,CocDiagnosticChange redrawstatus
  endif
  autocmd BufLeave list://* hi! CursorLine cterm=NONE gui=NONE
  autocmd BufEnter list://* hi! CursorLine cterm=underline gui=underline
  " https://github.com/neoclide/coc.nvim/issues/2043
  autocmd VimLeave * call coc#rpc#kill()
  " NOTE: some langs need to override Coc mappings
  autocmd FileType c,cpp,python,lua,go,ocaml,rust,tex,json,sh,javascript,typescript,vim call SetupLSP() | call SetupLSPPost()
augroup end

command! -nargs=0 Format call CocAction('format')
" TODO fold level too high in some languages (e.g. ccls)
command! -nargs=? Fold   call CocAction('fold', <f-args>)
" }}}

elseif get(g:, 'ide_client', '') == 'nvim' " {{{

lua require('tomtomjhj/lsp')

function! SetupLSP()
  augroup LocalNvimLSPStuff | au! * <buffer>
  augroup END
  " vim.lsp.formatexpr() doesn't format comments like built-in gq.
  " So use my custom wrapper for vim.lsp.buf.format().
  " Or just use gw for built-in formatter.
  setlocal formatexpr=

  " TODO: hover floating window width is not sufficient
  nnoremap <buffer>        <M-.> <cmd>lua vim.lsp.buf.hover()<CR>

  " location_handler
  nnoremap <buffer><leader>rf    <cmd>lua require('fzf-lua').lsp_references{jump_to_single_result=true}<CR>
  nnoremap <buffer>        <M-]> <cmd>lua require('fzf-lua').lsp_definitions{jump_to_single_result=true}<CR>
  nnoremap <buffer><leader>gd    <cmd>lua require('fzf-lua').lsp_declarations{jump_to_single_result=true}<CR>
  nnoremap <buffer><leader>gy    <cmd>lua require('fzf-lua').lsp_typedefs{jump_to_single_result=true}<CR>
  nnoremap <buffer><leader>gi    <cmd>lua require('fzf-lua').lsp_implementations{jump_to_single_result=true}<CR>
  " symbol_handler
  nnoremap <buffer><leader>ds    <cmd>lua require('fzf-lua').lsp_document_symbols()<CR>
  nnoremap <buffer><leader>sb    <cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>
  " call_hierarchy_handler

  " ...
  nnoremap <buffer><leader>ac    <cmd>lua require('fzf-lua').lsp_code_actions()<CR>
  nnoremap <buffer><leader>fm    <cmd>lua vim.lsp.buf.format{async=true}<CR>
  xnoremap <buffer><expr><leader>fm  NvimLSPRangeFormat('')
  nnoremap <buffer><leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer><localleader>*    <cmd>lua vim.lsp.buf.document_highlight()<CR>
  nnoremap <buffer><localleader><CR> <cmd>lua vim.lsp.buf.clear_references()<CR>
  inoremap <buffer>        <M-i> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <buffer>        <M-i> <cmd>lua vim.lsp.buf.inlay_hint(0)<CR>
  " NOTE: some commands require client side extension (vim.lsp.commands, etc), e.g. running test with rust-analyzer
  nnoremap <buffer><leader>cr    <cmd>lua vim.lsp.codelens.run()<CR>

  nnoremap <buffer>        [d    <cmd>lua vim.diagnostic.goto_prev{float=false, severity={min=vim.diagnostic.severity.WARN}}<CR>
  nnoremap <buffer>        ]d    <cmd>lua vim.diagnostic.goto_next{float=false, severity={min=vim.diagnostic.severity.WARN}}<CR>
  nnoremap <buffer>        [D    <cmd>lua vim.diagnostic.goto_prev{float=false}<CR>
  nnoremap <buffer>        ]D    <cmd>lua vim.diagnostic.goto_next{float=false}<CR>
  nnoremap <buffer>        <M-,> <cmd>lua vim.diagnostic.open_float(0, {scope="cursor"})<CR>
  " NOTE: severity is not highlighted at the first call, it uses diagnostic sign definition under the hood, which are defined lazily when the diagnostics are first displayed (define_default_signs)
  nnoremap <buffer><leader>dl    <cmd>lua require('fzf-lua').diagnostics_workspace{severity_limit=3}<CR>
  nnoremap <buffer><leader>DL    <cmd>lua require('fzf-lua').diagnostics_workspace()<CR>
endfunction

function! STLBreadCrumb()
  return get(w:, 'breadcrumb', '')
endfunction
function! STLProgress()
  return get(g:, 'lsp_status', '')
endfunction
function! STLDiagnosticErrors()
  let errors = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.ERROR})')
  return errors ? 'E' . errors : ''
endfunction
function! STLDiagnosticWarnings()
  let warnings = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.WARN})')
  return warnings ? 'W' . warnings : ''
endfunction

function! NvimLSPRangeFormat(type) abort
  if a:type == ''
    set opfunc=NvimLSPRangeFormat
    return 'g@'
  endif
  lua vim.lsp.buf.format{ range = { start = vim.api.nvim_buf_get_mark(0, '['), ['end'] = vim.api.nvim_buf_get_mark(0, ']') } }
endfunction
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
function! STLBreadCrumb()
  return ''
endfunction
function! STLDiagnosticErrors()
  return ''
endfunction
function! STLDiagnosticWarnings()
  return ''
endfunction
endif " }}}

" common {{{
" Override things done in SetupLSP
" TODO: in general, should run my FileType after SetupLSP
function! SetupLSPPost()
  " lsp format didn't work well for these filetypes. Format using ale.
  if &filetype =~# '\v^(go|ocaml)$'
    nmap <buffer><leader>fm <Plug>(ale_fix)
  endif
  if &filetype ==# 'vim'
    noremap <silent><buffer> <M-.> K
  endif
endfunction
" }}}

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
