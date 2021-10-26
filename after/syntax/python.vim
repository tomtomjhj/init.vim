syn match pythonDelimiter "[(){}[\],:;\\]"
hi def link pythonDelimiter Delimiter

syn keyword pythonTodo NOTE

hi! def link pythonBuiltinObj       Constant
hi! def link pythonBuiltinFunc      Function
hi! def link pythonBuiltinType      Type

hi! def link pythonExClass          Type
hi! def link pythonClass            Type
hi! def link pythonClassVar         Constant
