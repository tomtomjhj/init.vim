hi! def link goBuiltins Function
hi! def link goFunctionCall Function
hi! def link goTypeConstructor Constant
syn region      goParen matchgroup=Delimiter start='(' end=')' transparent
if go#config#FoldEnable('block')
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent fold
else
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent
endif
