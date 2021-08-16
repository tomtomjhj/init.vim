" override the link set in after/plugin/zenbruh.vim
hi ALEError term=underline cterm=underline gui=undercurl
hi ALEWarning term=NONE cterm=NONE gui=NONE
hi ALEInfo term=NONE cterm=NONE gui=NONE

" if lazy-loaded, g:ale_enabled doesn't exist when after/plugin/zenbruh.vim is sourced
hi! link ALEErrorSign          ZenbruhRed
hi! link ALEWarningSign        ZenbruhOrange
hi! link ALEInfoSign           ZenbruhCyan

hi! link ALEVirtualTextError   Comment
hi! link ALEVirtualTextWarning Comment


" TODO: fix nvim lsp highlights from colors/zenbruh.vim
" hi! link LspReferenceText ZenbruhSelection
" hi! link LspReferenceRead ZenbruhSelection
" hi! link LspReferenceWrite ZenbruhSelection
" hi! link LspDiagnosticsDefaultInformation ZenbruhCyan
" hi! link LspDiagnosticsDefaultHint ZenbruhCyan
" hi! link LspDiagnosticsDefaultError ZenbruhError
" hi! link LspDiagnosticsDefaultWarning ZenbruhOrange
" hi! link LspDiagnosticsUnderlineError ZenbruhErrorLine
" hi! link LspDiagnosticsUnderlineHint ZenbruhInfoLine
" hi! link LspDiagnosticsUnderlineInformation ZenbruhInfoLine
" hi! link LspDiagnosticsUnderlineWarning ZenbruhWarnLine
