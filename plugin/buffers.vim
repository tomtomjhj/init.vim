" buffer list operations {{{
" bw, bd, setlocal bufhidden=delete don't work on the buf being hidden
" https://stackoverflow.com/questions/6552295.
func! s:WipeGarbageBufs()
    " NOTE: getbufinfo bufmodified != getbufvar(.., '&mod') for new No Name buffer
    let garbages = map(filter(getbufinfo({'buflisted': 1}), 'empty(v:val.name) && v:val.hidden && !v:val.changed'), 'v:val.bufnr')
    if !empty(garbages)
        exe 'bwipeout' join(garbages, ' ')
    endif
endfunc

function! s:format_buffer(b)
  let l:name = bufname(a:b)
  let l:name = empty(l:name) ? '[No Name]' : fnamemodify(l:name, ":p:~:.")
  let l:flag = a:b == bufnr('')  ? '%' :
          \ (a:b == bufnr('#') ? '#' : ' ')
  let l:modified = getbufvar(a:b, '&modified') ? ' [+]' : ''
  let l:readonly = getbufvar(a:b, '&modifiable') ? '' : ' [RO]'
  let l:extra = join(filter([l:modified, l:readonly], '!empty(v:val)'), '')
  return substitute(printf("[%s] %s\t%s\t%s", a:b, l:flag, l:name, l:extra), '^\s*\|\s*$', '', 'g')
endfunction

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-726526334
function! s:ls_delete(cmd)
  call s:WipeGarbageBufs()

  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [
  \   '-m',
  \   '--tiebreak=index',
  \   '-d', '\t',
  \   '--prompt', a:cmd . '> '
  \ ]
  if len(l:preview_window)
    let l:options = extend(l:options, get(fzf#vim#with_preview(
          \   {"placeholder": "{2}"},
          \   l:preview_window
          \ ), 'options', []))
  endif

  return fzf#run(fzf#wrap({
  \ 'source':  map(
  \   filter(
  \     range(1, bufnr('$')),
  \     {_, nr -> buflisted(nr) && !getbufvar(nr, "&modified")}
  \   ),
  \   {_, nr -> s:format_buffer(nr)}
  \ ),
  \ 'sink*': {
  \   lines -> execute(a:cmd . ' ' . join(map(lines, {
  \     _, line -> substitute(split(line)[0], '^\[\|\]$', '', 'g')
  \   })), 'silent!')
  \ },
  \ 'options': l:options,
  \}))
endfunction
" }}}
command! Lsdelete call <SID>ls_delete('bdelete')
command! Lswipeout call <SID>ls_delete('bwipeout')

" Delete buffer while keeping window layout (don't close buffer's windows). {{{
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif
" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(cmd, bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute a:cmd.a:bang btarget
  execute wcurrent.'wincmd w'
endfunction
" }}}
command! -bang -complete=buffer -nargs=? Bdelete  call <SID>Bclose('bdelete', <q-bang>, <q-args>)
command! -bang -complete=buffer -nargs=? Bwipeout call <SID>Bclose('bwipeout', <q-bang>, <q-args>)

" vim: set ts=2 sw=2 fdm=marker fdl=0:
