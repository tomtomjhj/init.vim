syn clear luaConstant
syn keyword luaNil nil
syn keyword luaBool true false
syn cluster luaBase add=luaNil,luaBool
hi! def link luaNil Constant
hi! def link luaBool Boolean

hi! def link luaParens Delimiter
hi! def link luaFuncParens Delimiter
hi! def link luaBraces Delimiter
hi! def link luaBrackets Delimiter
