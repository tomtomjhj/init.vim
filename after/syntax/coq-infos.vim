syn cluster coqTerm contains=coqString,coqKwd,coqTermPunctuation,coqKwdMatch,coqKwdLet,coqKwdParen

syn clear coqKwd
syn keyword coqKwd             contained else end exists2 fix forall fun if in struct then as return
syn match   coqKwd             contained "\<where\>"
syn match   coqKwd             contained "\<exists!\?"
syn match coqKwd contained "∀\|∃\|λ"

" Define the default highlighting.
command -nargs=+ HiLink hi def link <args>

" TERMS AND TYPES
HiLink coqTerm              Type
HiLink coqKwd               coqTerm
HiLink coqTermPunctuation   coqTerm

" VERNACULAR COMMANDS
HiLink coqVernacCmd         coqVernacular
HiLink coqVernacPunctuation Operator
HiLink coqTopLevel          coqVernacular
HiLink coqSectionDecl       coqTopLevel
HiLink coqModuleEnd         coqTopLevel

" DEFINED OBJECTS
HiLink coqIdent             Constant
HiLink coqSectionName       Identifier
HiLink coqDefName           Identifier
HiLink coqDefNameHidden     Identifier
HiLink coqNotationString    String

" CONSTRUCTORS AND FIELDS
HiLink coqConstructor       Constant
HiLink coqField             coqConstructor

" NOTATION SPECIFIC ("at level", "format", etc)
HiLink coqNotationKwd       NONE

" SPECIFICATIONS
HiLink coqArgumentSpecificationKeywords Underlined
HiLink coqScopeSpecification            Underlined

" WARNINGS AND ERRORS
HiLink coqBad               WarningMsg
HiLink coqVeryBad           ErrorMsg
HiLink coqWarningMsg        WarningMsg
HiLink coqBad               WarningMsg


" USUAL VIM HIGHLIGHTINGS
" Comments
HiLink coqComment           Comment
HiLink coqSectionDelimiter  Comment
HiLink coqProofComment      coqComment

" Todo
HiLink coqTodo              Todo

" Errors
HiLink coqError             Error

" Strings
HiLink coqString            String

delcommand HiLink
