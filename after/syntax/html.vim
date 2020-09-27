syn clear htmlError

" https://html.spec.whatwg.org/multipage/syntax.html#start-tags
syn clear htmlTag
syn region htmlTag start=+<[[:alnum:]]+ end=+>+ fold contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster

" https://html.spec.whatwg.org/#comments
" The text
" 1. must not start with the string ">", nor start with the string "->",
"    → don't match them as comment from the start
" 2. nor contain the strings "<!--", "-->", or "--!>",
"                                     ^^^ end the comment as early as possible
" 3. nor end with the string "<!-",
" 4. but allowed to end with the string "<!"
" test.html
" <!-- --!> --> error
" <!-- <!-- --> error
" <!-- <!----> error
" <!-- <!---> error
" <!-- <!--> ok
" <!-- --!> --> error
" <!--#config --> PreProc
syn clear htmlComment htmlCommentPart htmlCommentError
syn region htmlComment matchgroup=htmlCommentStart start=+<!--\%(>\|->\|#\)\@!+ matchgroup=htmlCommentEnd end=+-->+ contains=htmlCommentError,@Spell
syn match htmlCommentError contained "\%(<!-\ze-->\|<!-->\@!\|--!>\)"
syn region htmlComment start=+<!DOCTYPE+ keepend end=+>+
hi link htmlCommentStart Comment
hi link htmlCommentEnd Comment

syn keyword htmlTodo TODO FIXME NOTE containedin=htmlComment contained
hi link htmlTodo Todo
