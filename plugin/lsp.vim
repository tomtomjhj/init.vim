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
  vmap     <silent><buffer><leader>fm    <Plug>(coc-format-selected)
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
  autocmd BufLeave list://* hi! CursorLine cterm=NONE gui=NONE
  autocmd BufEnter list://* hi! CursorLine cterm=underline gui=underline
  " https://github.com/neoclide/coc.nvim/issues/2043
  autocmd VimLeave * call coc#rpc#kill()
  " NOTE: some langs need to override Coc mappings
  autocmd FileType c,cpp,python,lua,go,ocaml,rust,tex,json,sh,javascript,typescript call SetupLSP() | call SetupLSPPost()
augroup end

command! -nargs=0 Format call CocAction('format')
" TODO fold level too high in some languages (e.g. ccls)
command! -nargs=? Fold   call CocAction('fold', <f-args>)
" }}}

elseif get(g:, 'ide_client', '') == 'nvim' " {{{
lua << EOF
tomtomjhj.lsp = require('tomtomjhj/lsp')
EOF

" lsp_markdown can't be customized..
hi! link markdownError NONE

function! SetupLSP()
  augroup LocalNvimLSPStuff | au! * <buffer>
  augroup END
  setlocal tagfunc=v:lua.vim.lsp.tagfunc
  nnoremap <buffer>        <M-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer>        <M-.> <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer><leader>gi    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <buffer><leader>gy    <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <buffer><leader>rf    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <buffer><leader>gd    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <buffer><leader>fm    <cmd>lua vim.lsp.buf.format{async=true}<CR>
  xnoremap <buffer><expr><leader>fm  NvimLSPRangeFormat('')
  nnoremap <buffer><leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
  nnoremap <buffer><leader>ac    <cmd>lua vim.lsp.buf.code_action()<CR>
  nnoremap <buffer>        [d    <cmd>lua vim.diagnostic.goto_prev{float=false}<CR>
  nnoremap <buffer>        ]d    <cmd>lua vim.diagnostic.goto_next{float=false}<CR>
  nnoremap <buffer>        <M-,> <cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>
  nnoremap <buffer><leader>dl    <cmd>LspDiagnosticsAll<CR>
  nnoremap <buffer><leader>ol    <cmd>lua vim.lsp.buf.document_symbol()<CR>
  " TODO: <ESC> on workspace_symbol prompt doesn't cancel
  nnoremap <buffer><leader>sb    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  inoremap <buffer>        <M-i> <cmd>lua vim.lsp.buf.signature_help()<CR>
  " TODO: codelens? codeaction? how do I run tests??
  " TODO: |lsp-handler| default location_handler
  " * goto def in split, etc https://github.com/neovim/neovim/pull/12966
  " * hover in preview window
endfunction

function! CurrentFunction()
  return get(b:,'lsp_current_function', '')
endfunction
" TODO: Too much stl flickering when typing if the message is too long.
" TODO: Do I still need lsp-status? See vim.lsp.util.get_progress_messages(), LspProgressUpdate
" https://github.com/neovim/neovim/pull/13294
" https://github.com/teto/home/blob/373966b5cd8cbcc7ca20a07da28de218668a656a/config/nvim/lua/statusline.lua
" https://github.com/j-hui/fidget.nvim/issues/51
function! CheckerStatus()
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval('require("lsp-status").status_progress()')
  endif
  return ''
endfunction
function! CheckerErrors()
  let errors = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.ERROR})')
  return errors ? 'E' . errors : ''
endfunction
function! CheckerWarnings()
  let warnings = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.WARN})')
  return warnings ? 'W' . warnings : ''
endfunction

function! NvimLSPRangeFormat(type) abort
  if a:type == ''
    set opfunc=NvimLSPRangeFormat
    return 'g@'
  endif
  lua vim.lsp.buf.range_formatting({}, vim.api.nvim_buf_get_mark(0, '['), vim.api.nvim_buf_get_mark(0, ']'))
endfunction

augroup GlobalNvimLSPStuff | au!
  au DiagnosticChanged * call lightline#update()
  " override lspconfig's LspLog
  au VimEnter * command! LspLog exe '<mods> pedit +setlocal\ nobuflisted|$' v:lua.vim.lsp.get_log_path()
augroup end
" }}}

elseif get(g:, 'ide_client', '') == 'ale' " {{{
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

" common {{{
" Override things done in SetupLSP
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
