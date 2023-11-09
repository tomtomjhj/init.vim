" git log viewer {{{
" NOTE: queries that take too long
" - don't auto-rerun if query is complex?
" - just manually pass -1 in
" - Do something like fugitive's :Git! and CTRL-D to show the ouput so far?
"   FugitiveExecute can be passed callback for async execution.
" - when CTLR-C'ed, show the output so far?

command! -nargs=? -complete=customlist,fugitive#LogComplete GL call GLStart(<q-mods>, empty(trim(<q-args>)) ? '--all' : <q-args>)

augroup GL | au!
  au User FugitiveChanged if exists('b:gl_args') | call GLRun() | endif
augroup END

function! GLStart(mods, args) abort
  let git_dir = FugitiveGitDir()
  let tree = FugitiveWorkTree()
  " NOTE: Args may contain things like %, so should be expanded here.
  let [args, after] = GLSplitExpandChain(a:args, tree)

  if !(empty(bufname('')) && b:changedtick <= 2 && line('$') == 1 && empty(getline(1)))
    exe a:mods 'new'
  endif
  setfiletype gl
  let b:git_dir = git_dir
  let b:gl_tree = tree
  let b:gl_args = '' " set by GLRun
  setlocal buftype=nofile bufhidden=wipe noswapfile nomodeline undolevels=-1
  setlocal nowrap cursorline
  setlocal nomodifiable
  " NOTE: <C-R><C-F> (<Plug><cfile>) expands to fugitive URL.
  " NOTE: traces.vim masks c_<C-R><C-F>.
  call fugitive#MapCfile() " done by FileType git
  call fugitive#MapJumps() " assumping nomodifiable
  silent! unmap <buffer> *
  silent! unmap <buffer> #
  " NOTE: fugitive's ri doesn't work as expected
  nnoremap <buffer> ri :<C-U>Git rb -i <C-R>=<SID>line_commit('.')<CR>~<CR>
  nnoremap <buffer> gq <C-W><C-Q>
  " The "current fugitive-object" doesn't make sense for GL buffer.
  cnoremap <buffer><expr> <C-R><C-G> <SID>line_commit('.')
  nnoremap <buffer><silent> y<C-G> :<C-U>call setreg(v:register, <SID>line_commit('.'))<CR>

  nnoremap <buffer><silent> u :call GLRun()<CR>
  nnoremap <buffer><expr> U ':GL ' . join(b:gl_args) . ' '
  nnoremap <buffer><silent> a :call GLRun(<SID>toggle(b:gl_args, '--all'))<CR>

  command! -buffer -nargs=? -complete=customlist,fugitive#LogComplete GL call GLRun(GLSplitExpandChain(<q-args>, b:gl_tree)[0])

  syn region GL start='^' matchgroup=GLDate end='\s\zs\d\d\d\d-\d\d-\d\d\ze\s' oneline
  syn match GLHash '\v[*|]\s+\zs\x{6,}' containedin=GL contained
  syn match GLDecorate '\v\([^)]+\)' containedin=GL contained
  syn match GLAuthor '\v\[[^][]*\]$'

  hi def link GLHash Identifier
  hi def link GLDate Number
  hi def link GLDecorate Label
  hi def link GLAuthor String

  call GLRun(args)

  exe after
endfunction

" New value for b:gl_args. If None, use previous args ("refresh").
function! GLRun(...) abort
  let jumpto = '\v^.{-}\([^)]{-}/@<!<HEAD' " by default, jump to HEAD
  if a:0
    let b:gl_args = a:1
  else
    " If refreshed, return to commit at cursor.
    let jumpto = '\v^.{-}[*|]\s+' . s:line_commit('.')
  endif
  " NOTE: If `-<number>` is specified multiple times, the last one is used.
  let args = ['log', '--graph', '--format=format:%h%d %as %s [%an]', '-1111'] + b:gl_args
  let res = FugitiveExecute(args, b:git_dir)
  setlocal modifiable
  " NOTE: This invalidates jumplist and marks. Use :lockmarks when refreshing?
  silent %delete _
  call setline(1, res.exit_status is# 0 ? res.stdout : res.stderr)
  setlocal nomodifiable

  call cursor(1, 1)
  call search(jumpto, 'c', 0, 0, '')
  clearjumps
endfunction

function! s:toggle(args, opt) abort
  let args = deepcopy(a:args)
  let idx = index(args, a:opt)
  if idx >= 0
    call remove(args, idx)
  else
    let args = [a:opt] + args
  endif
  return args
endfunction

" NOTE: Hack to use s:SplitExpandChain() in autoload/fugitive.vim.
function! GLSplitExpandChain(string, tree) abort
  if !exists('s:SplitExpandChain')
    call fugitive#Expand('')
    let s:SplitExpandChain = matchstr(execute(':function /_SplitExpandChain$'), '<SNR>\d\+_SplitExpandChain')
  endif
  return call(s:SplitExpandChain, [a:string, a:tree])
endfunction

function! s:line_commit(line) abort
  return matchstr(getline(a:line), '\v[*|]\s+\zs\x{6,}')
endfunction

" }}}

" vim: set fdm=marker et sw=2:
