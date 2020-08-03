" added coqString
syn cluster coqTerm contains=coqString,coqKwd,coqTermPunctuation,coqKwdMatch,coqKwdLet,coqKwdParen

" remove non-alphanumeric
syn clear coqKwd
syn keyword coqKwd contained else end exists2 fix cofix forall fun if in struct then as return
syn match coqKwd contained "\<where\>"
syn match coqKwd contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"

" remove non-alphanumeric, add some ssr stuff
syn clear coqLtac
syn keyword coqLtac contained do info progress repeat try
syn keyword coqLtac contained abstract constr context end external eval fail first fresh fun goal
syn keyword coqLtac contained idtac in let ltac lazymatch multimatch match of rec reverse solve type with
syn keyword coqLtac contained have congr last done

" added coqString
syn region coqProofBody  contains=coqString,coqProofPunctuation,coqTactic,coqTacticKwd,coqProofComment,coqProofKwd,coqProofEnder,coqProofDelim,coqLtac matchgroup=coqProofDelim start="\<P\zeroof\>" start="\<\%(O\zebligation\_s\+\d\+\)\|\%(N\zeext\_s\+Obligation\)\>" matchgroup=NONE end="\<\%(Qed\|Defined\|Admitted\|Abort\)\.\_s" end="\<Save\>.*\.\_s" keepend

syn clear coqProofKwd
syn keyword coqProofKwd contained else end exists exists2 forall fun if in match let struct then where with as return
syn match coqProofKwd contained "∀\|∃\|λ"

syn region coqDefContents1  contained contains=@coqTerm matchgroup=coqVernacPunctuation start=":=" matchgroup=coqVernacPunctuation end="\.\_s"

syn sync minlines=321

command -nargs=+ HiLink hi! link <args>
" PROOFS
HiLink coqTactic            Function " Keyword
HiLink coqLtac              Function
HiLink coqProofKwd          coqKwd
HiLink coqProofPunctuation  Operator
HiLink coqTacticKwd         Function
" HiLink coqTacNotationKwd    coqTactic
" HiLink coqEvalFlag          coqTactic
HiLink coqEqnKwd            Function
" Exception
HiLink coqProofDot          coqVernacular

" PROOF DELIMITERS ("Proof", "Qed", "Defined", "Save")
HiLink coqProofDelim        Keyword

" TERMS AND TYPES
HiLink coqTerm              Type
HiLink coqKwd               coqTerm
HiLink coqTermPunctuation   Operator " coqTerm

" VERNACULAR COMMANDS
HiLink coqVernacular        PreProc
HiLink coqVernacCmd         coqVernacular
HiLink coqVernacPunctuation Operator
HiLink coqHint              coqVernacular
HiLink coqFeedback          coqVernacular
HiLink coqTopLevel          coqVernacular

" DEFINED OBJECTS
HiLink coqIdent             Constant
HiLink coqNotationString    String

" CONSTRUCTORS AND FIELDS
HiLink coqConstructor       Constant " Keyword
HiLink coqField             coqConstructor

" NOTATION SPECIFIC ("at level", "format", etc)
HiLink coqNotationKwd       NONE
HiLink coqEqnOptions        coqNotationKwd

" USUAL VIM HIGHLIGHTINGS
" Comments
HiLink coqComment           Comment
HiLink coqProofComment      coqComment

" Todo
HiLink coqTodo              Todo

" Errors
HiLink coqError             Error
HiLink coqProofAdmit        coqError

" Strings
HiLink coqString            String

delcommand HiLink
