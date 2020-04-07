hi! link goBuiltins Constant
hi! link goFunctionCall Function
syn region      goParen matchgroup=Delimiter start='(' end=')' transparent
if go#config#FoldEnable('block')
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent fold
else
  syn region    goBlock matchgroup=Delimiter start="{" end="}" transparent
endif
