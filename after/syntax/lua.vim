syn clear luaConstant
syn keyword luaNil nil
syn keyword luaBool true false
syn cluster luaBase add=luaNil,luaBool
hi! link luaNil Constant
hi! link luaBool Boolean

hi! link luaBuiltIn Constant
hi! link luaErrHand Type
hi! link luaFuncCall Function
hi! link luaLocal Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue Type

hi! link luaParens Delimiter
hi! link luaFuncParens Delimiter
hi! link luaBraces Delimiter
hi! link luaBrackets Delimiter
