syn clear htmlError

syn clear htmlTag
syn region htmlTag start=+<[[:alnum:]]+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster

syn keyword htmlTodo TODO FIXME NOTE containedin=htmlCommentPart contained
hi link htmlTodo Todo
