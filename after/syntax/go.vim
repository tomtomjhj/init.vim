hi! link goBuiltins Function
hi! link goFunctionCall Function
hi! link goTypeConstructor Constant
syn region      goParen matchgroup=Delimiter start='(' end=')' transparent
if go#config#FoldEnable('block')
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent fold
else
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent
endif
