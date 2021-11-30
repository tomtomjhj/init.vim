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
    enable = true;
    disable = {"lua",   -- doesn't work at all
               "rust"}; -- comment indentation is broken
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
