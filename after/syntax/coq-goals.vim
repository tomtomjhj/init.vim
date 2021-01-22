syn clear coqKwd
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then as return
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"
syn match coqKwd contained "/\\\|∧\|\\/\|∨\|<->\|->\|→\|=>\|<-\|←\|∗"

" Define the default highlighting.
command -nargs=+ HiLink hi def link <args>

" TERMS AND TYPES
HiLink coqTerm              Type
HiLink coqKwd               coqTerm
HiLink coqTermPunctuation   coqTerm

" WORK LEFT
HiLink coqNumberGoals       NONE
HiLink coqNumberUnfocused   NONE
HiLink coqNumberAdmitted    Error
HiLink coqNumberShelved     NONE
HiLink coqGoalLine          NONE

" GOAL IDENTIFIER
HiLink coqGoalNumber        Underlined
HiLink coqNextGoal          Underlined

" USUAL VIM HIGHLIGHTINGS
" Comments
HiLink coqComment           Comment

" Strings
HiLink coqString            String

delcommand HiLink
