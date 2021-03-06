syn match pythonDelimiter "[(){}[\],:;\\]"
hi def link pythonDelimiter Delimiter

syn keyword pythonTodo NOTE

hi! link pythonBuiltinObj       Constant
hi! link pythonBuiltinFunc      Function
hi! link pythonBuiltinType      Type

hi! link pythonExClass          Type
hi! link pythonClass            Type
hi! link pythonClassVar         Constant
