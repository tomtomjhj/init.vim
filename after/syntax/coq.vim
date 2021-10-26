" In markdown fenced code block, comments inside terms are not highlighted.
syn cluster coqTerm add=coqComment

" improve interaction between of coq syntax and notations using {}
syn region coqKwdBrace contained contains=@coqTerm start="{" end="}"
syn cluster coqTerm add=coqKwdBrace

" tune symbol highlighting
syn clear coqKwd
syn keyword coqKwd contained else end exists2 fix cofix forall fun if in struct then as return
syn match coqKwd contained "\<where\>"
syn match coqKwd contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"
syn match coqKwd contained "/\\\|∧\|\\/\|∨\|<->\|->\|→\|=>\|<-\|←\|∗"

" remove non-alphanumeric, add some ssr stuff
syn clear coqLtac
syn keyword coqLtac contained do info progress repeat try
syn keyword coqLtac contained abstract constr context end external eval fail first fresh fun goal
syn keyword coqLtac contained idtac in let ltac lazymatch multimatch match of rec reverse solve type with
syn keyword coqLtac contained have suff wlog congr last done

syn clear coqProofKwd
syn keyword coqProofKwd contained else end exists exists2 forall fun if in match let struct then where with as return
syn match coqProofKwd contained "∀\|∃\|λ"
syn match coqProofKwd contained "/\\\|∧\|\\/\|∨\|<->\|->\|→\|=>\|<-\|←\|∗"

syn region coqDefContents1  contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":=" matchgroup=coqVernacPunctuation end="\.\_s"

" don't highlight fields (very fragile)
syn clear coqRecContent coqRecStart coqRecField
syn region coqRecContent contained contains=coqRecStart matchgroup=coqVernacPunctuation start=":=" end="\.\_s"
syn region coqRecStart   contained contains=@coqTerm start="{" matchgroup=coqVernacPunctuation end="}"

syn sync minlines=321

" fix default links
hi! def link coqProofKwd          coqKwd
hi! def link coqProofPunctuation  Operator
hi! def link coqEqnKwd            Keyword
hi! def link coqProofDelim        Keyword
hi! def link coqTermPunctuation   Operator
hi! def link coqVernacPunctuation Operator
hi! def link coqIdent             Constant
hi! def link coqNotationString    String
hi! def link coqConstructor       Constant
hi! def link coqNotationKwd       NONE
hi! def link coqError             NONE
hi! def link coqProofAdmit        Error

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
  endif
endfunction
call s:colors()
augroup AfterSyntaxCoq | au!
  au ColorScheme * call s:colors()
augroup END

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
