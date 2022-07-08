" statusline {{{
" based on fugitive#535389b9a64be18349394c192bcf0348c0dee64e
if exists('+shellslash')
  let s:dir_commit_file = '\c^fugitive://\%(/\a\@=\)\=\(.\{-\}\)//\%(\(\x\{40,\}\|[0-3]\)\(/.*\)\=\)\=$'
  function! s:Slash(path) abort
    return tr(a:path, '\', '/')
  endfunction
else
  let s:dir_commit_file = '\c^fugitive://\(.\{-\}\)//\%(\(\x\{40,\}\|[0-3]\)\(/.*\)\=\)\=$'
  function! s:Slash(path) abort
    return a:path
  endfunction
endif

function! s:DirCommitFile_1(path) abort
  let vals = matchlist(s:Slash(a:path), s:dir_commit_file)
  if empty(vals)
    return ''
  endif
  return empty(vals[2]) ? '' : vals[2]
endfunction

function! GitStatusline() abort
  let dir = FugitiveGitDir(bufnr(''))
  if empty(dir)
    return ''
  endif
  let commit = s:DirCommitFile_1(@%)
  let status = fugitive#Head(7, dir)
  if len(commit)
    let status .= ':' . commit[0:6]
  endif
  return '['.status.']'
endfunction
" }}}

" git log viewer {{{
command! -nargs=? -complete=customlist,fugitive#LogComplete GL call GLStart(<q-mods>, empty(trim(<q-args>)) ? '--all' : <q-args>)

augroup GL | au!
  au User FugitiveChanged if exists('b:gl_args') | call GLRun() | endif
augroup END

function! GLStart(mods, args) abort
  let git_dir = FugitiveGitDir()
  let tree = FugitiveWorkTree()
  " NOTE: Args may contain things like %, so should be expanded here.
  let [args, after] = GLSplitExpandChain(a:args, tree)

  exe a:mods 'new'
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

  hi! link GLHash Identifier
  hi! link GLDate Number
  hi! link GLDecorate Label
  hi! link GLAuthor String

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
  " NOTE: This invalidates jumplist and marks.
  %delete _
  call setline(1, res.exit_status is# 0 ? res.stdout : res.stderr)
  setlocal nomodifiable

  keepjumps normal! 1G
  call search(jumpto, 'c', 0, 0, '')
  clearjumps
  echo 'git log' b:gl_args
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
