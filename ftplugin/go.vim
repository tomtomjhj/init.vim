let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setl fo< com< cms<"
      \ . "| exe 'au! vim-go-buffer * <buffer>'"

setlocal formatoptions-=t

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal noexpandtab

compiler go

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

call SetupCoc()
nmap <buffer><leader>fm <Plug>(ale_fix)
" vim: sw=2 ts=2 et
