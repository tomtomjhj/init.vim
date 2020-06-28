let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl fo< com< cms<"
      \ . "| exe 'au! vim-go-buffer * <buffer>'"

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

compiler go


" Autocommands
" ============================================================================
"
augroup vim-go-buffer
  autocmd! * <buffer>

  " The file is registered (textDocument/DidOpen) with gopls in plugin/go.vim
  " on the FileType event.

  autocmd BufEnter <buffer>
        \  if go#config#AutodetectGopath() && !exists('b:old_gopath')
        \|   let b:old_gopath = exists('$GOPATH') ? $GOPATH : -1
        \|   let $GOPATH = go#path#Detect()
        \| endif
  autocmd BufLeave <buffer>
        \  if exists('b:old_gopath')
        \|   if b:old_gopath isnot -1
        \|     let $GOPATH = b:old_gopath
        \|   endif
        \|   unlet b:old_gopath
        \| endif
augroup end

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

call SetupCoc()
nmap <buffer><leader>fm <Plug>(ale_fix)
" vim: sw=2 ts=2 et
