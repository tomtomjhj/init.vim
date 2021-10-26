syn clear coqKwd
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then as return
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"
syn match coqKwd contained "/\\\|∧\|\\/\|∨\|<->\|->\|→\|=>\|<-\|←\|∗"

" fix default highlight links
hi! def link coqNumberGoals       NONE
hi! def link coqNumberUnfocused   NONE
hi! def link coqNumberShelved     NONE
hi! def link coqGoalLine          NONE
