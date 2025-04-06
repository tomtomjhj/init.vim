" don't highlight `i64:` in `array<i64: 1, 2>`
syntax clear  mlirLabel
" syn match mlirLabel /\v[<]@1<!<[-a-zA-Z$._][-a-zA-Z$._0-9]*:/

syntax keyword mlirCommentTodo TODO
    \ containedin=mlirComment contained
hi def link mlirCommentTodo Todo

hi! def link mlirAttrIdentifier NONE
