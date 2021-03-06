if exists('+shellslash')
  function! s:Slash(path) abort
    return tr(a:path, '\', '/')
  endfunction
else
  function! s:Slash(path) abort
    return a:path
  endfunction
endif

function! s:DirCommitFile(path) abort
  let vals = matchlist(s:Slash(a:path), '\c^fugitive:\%(//\)\=\(.\{-\}\)\%(//\|::\)\(\x\{40,\}\|[0-3]\)\(/.*\)\=$')
  if empty(vals)
    return ['', '', '']
  endif
  return vals[1:3]
endfunction

function! GitStatusline() abort
  let dir = FugitiveGitDir(bufnr(''))
  if empty(dir)
    return ''
  endif
  let status = ''
  let commit = s:DirCommitFile(@%)[1]
  let status .= FugitiveHead(7, dir)
  if len(commit)
    let status .= ':' . commit[0:6]
  endif
  return '['.status.']'
endfunction
