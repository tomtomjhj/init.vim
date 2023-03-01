local disable = {
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

local highlighter = require "vim.treesitter.highlighter"
require("paint").setup {
  highlights = {
    {
      filter = function(b)
        return highlighter.active[b] and vim.api.nvim_buf_get_option(b, 'filetype') == 'markdown'
      end,
      pattern = "TODO",
      hl = "Todo",
    },
  },
}
