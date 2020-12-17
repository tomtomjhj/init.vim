set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

lua << EOF
tomtomjhj = {}
EOF

source ~/.vim/configs.vim

augroup NvimStuff | au!
    au TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" vim doesn't have `numhl`
sign define LspDiagnosticsSignError       text=>> texthl=ALEErrorSign   linehl= numhl=
sign define LspDiagnosticsSignWarning     text=>> texthl=ALEWarningSign linehl= numhl=
sign define LspDiagnosticsSignInformation text=-- texthl=ALEInfoSign    linehl= numhl=
sign define LspDiagnosticsSignHint        text=-- texthl=ALEInfoSign    linehl= numhl=

hi! link LspDiagnosticsVirtualTextError TypeHint
hi! link LspDiagnosticsVirtualTextWarning TypeHint
hi! link LspDiagnosticsVirtualTextInformation TypeHint
hi! link LspDiagnosticsVirtualTextHint TypeHint

" hi! link LspDiagnosticsUnderlineError
" hi! link LspDiagnosticsUnderlineWarning
" hi! link LspDiagnosticsUnderlineInformation
" hi! link LspDiagnosticsUnderlineHint

" hi! link LspDiagnosticsFloatingError
" hi! link LspDiagnosticsFloatingWarning
" hi! link LspDiagnosticsFloatingInformation
" hi! link LspDiagnosticsFloatingHint
