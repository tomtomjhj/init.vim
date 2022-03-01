syn sync minlines=321

" per-colorscheme customization
function! s:colors()
  " TODO: interaction with listchar? NonText highlighting disappears when CoqtailChecked is applied
  if &background ==# 'dark'
    hi! CoqtailChecked ctermbg=237 guibg=#3a3a3a
    hi! CoqtailSent ctermbg=60 guibg=#5f5f87
  else
    hi! CoqtailChecked ctermbg=252 guibg=#d0d0d0
    hi! CoqtailSent ctermbg=146 guibg=#afafd7
  endif

  if get(g:, 'colors_name', '') ==# 'zenbruh'
    hi! link coqTactic            ZenbruhGreen
    hi! link coqLtac              ZenbruhGreen
    hi! link coqTacticKwd         ZenbruhGreen
  elseif get(g:, 'colors_name', '') ==# 'taiga'
    " NOTE: wip coqIdentDef stuff
    hi! link coqIdentDef          TaigaGreenHigh
  endif
endfunction
call s:colors()
augroup AfterSyntaxCoq | au!
  au ColorScheme * call s:colors()
augroup END

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
