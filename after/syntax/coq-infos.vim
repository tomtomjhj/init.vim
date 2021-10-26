syn clear coqKwd
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then as return
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"
syn match coqKwd contained "/\\\|∧\|\\/\|∨\|<->\|->\|→\|=>\|<-\|←\|∗"


" fix default highlight links
hi! def link coqVernacPunctuation Operator
hi! def link coqIdent             Constant
hi! def link coqConstructor       Constant
hi! def link coqNotationKwd       NONE
