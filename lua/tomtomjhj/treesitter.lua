require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true;
    disable = {
      "python",
      "vim",  -- less complete
      "markdown" -- slow on big files; fenced code block @text.literal is not cleared
    };
  },
  indent = {
    enable = true;
    disable = {};
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

-- local ag = vim.api.nvim_create_augroup("treesitter-custom", { clear = true })
-- vim.api.nvim_create_autocmd(
--   { "FileType" },
--   { group = ag, pattern = "markdown",
--     desc = 'treesitter fold',
--     callback = function()
--       vim.wo.foldmethod = 'expr'
--       vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
--       vim.wo.foldtext = 'foldtext()'
--     end
--   }
-- )

-- TODO: how to add additional pattern-based highlight?
-- * matchadd(): this is window-local
-- * https://github.com/folke/paint.nvim
-- * enable regex highlight, set b:current_syntax to disable the usual syntax/*.vim, and add :syn as needed
