set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

lua << EOF
tomtomjhj = tomtomjhj or {}

function P(v)
  print(vim.inspect(v))
  return v
end

-- nil, false and 0 are falsy
function TT(x) return x and x ~= 0 end
EOF

source ~/.vim/configs.vim

augroup NvimStuff | au!
    au TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" TODO: these are removed https://github.com/neovim/neovim/issues/14090#issuecomment-921312955
" vim doesn't have `numhl`
sign define LspDiagnosticsSignError       text=>> texthl=ALEErrorSign   linehl= numhl=
sign define LspDiagnosticsSignWarning     text=>> texthl=ALEWarningSign linehl= numhl=
sign define LspDiagnosticsSignInformation text=-- texthl=ALEInfoSign    linehl= numhl=
sign define LspDiagnosticsSignHint        text=-- texthl=ALEInfoSign    linehl= numhl=

hi! def link LspDiagnosticsVirtualTextError TypeHint
hi! def link LspDiagnosticsVirtualTextWarning TypeHint
hi! def link LspDiagnosticsVirtualTextInformation TypeHint
hi! def link LspDiagnosticsVirtualTextHint TypeHint

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
