local disable = {
  "latex", -- use vimtex for latex file; but use treesitter for markdown inline latex
  "vim",  -- less complete
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true;
    disable = disable;
  },
  indent = {
    enable = true;
    disable = disable;
  },
  incremental_selection = {
    enable = true,
    disable = disable,
    keymaps = {
      init_selection = "<leader><tab>",
      node_incremental = "<leader><tab>",
      node_decremental = "<s-tab>",
      scope_incremental = "<leader><s-tab>",
    },
  },
}

-- TODO: fine-tune folding query
-- local ag = vim.api.nvim_create_augroup("treesitter-custom", { clear = true })
-- vim.api.nvim_create_autocmd(
--   { "FileType" },
--   { group = ag, pattern = "markdown",
--     desc = 'treesitter fold',
--     callback = function()
--       vim.wo.foldmethod = 'expr'
--       vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
--       vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- 0.9
--       vim.wo.foldtext = 'foldtext()'
--     end
--   }
-- )

-- comment injection is slow https://gist.github.com/tomtomjhj/95c2feec72f35e6a6942fd792587bb4e
local highlighter = require "vim.treesitter.highlighter"
require("paint").setup {
  highlights = {
    {
      filter = function(b) return highlighter.active[b] end,
      pattern = "TODO",
      hl = "Todo",
    },
    {
      -- lua ---@ comment
      filter = function(b)
        return highlighter.active[b] and vim.api.nvim_buf_get_option(b, 'filetype') == 'lua'
      end,
      pattern = "%s*%-%-%-%s*(@%w+)",
      hl = "Constant",
    },
  },
}
