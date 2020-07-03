command -nargs=+ HiLink hi! link <args>
" PROOFS
HiLink coqTactic            Function " Keyword
HiLink coqLtac              Function
HiLink coqProofKwd          Function
HiLink coqProofPunctuation  Operator
HiLink coqTacticKwd         Function
" HiLink coqTacNotationKwd    coqTactic
" HiLink coqEvalFlag          coqTactic
HiLink coqEqnKwd            Function
" Exception
HiLink coqProofDot          coqVernacular

" PROOF DELIMITERS ("Proof", "Qed", "Defined", "Save")
HiLink coqProofDelim        Underlined

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
HiLink coqIdent             Identifier
HiLink coqNotationString    coqIdent

" CONSTRUCTORS AND FIELDS
HiLink coqConstructor       Constant " Keyword
HiLink coqField             coqConstructor

" NOTATION SPECIFIC ("at level", "format", etc)
HiLink coqNotationKwd       Special
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
