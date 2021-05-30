set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

lua << EOF
tomtomjhj = tomtomjhj or {}

function P(v)
  print(vim.inspect(v))
  return v
end
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

" TODO: how to customize highlighting queries? → read readme
if has('nvim-0.5')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true;
    disable = {"python"};
  },
  indent = {
    enable = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader><tab>",
      node_incremental = "<leader><tab>",
      node_decremental = "<s-tab>",
      scope_incremental = "<leader><s-tab>",
    },
  },
}
EOF
endif
