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
