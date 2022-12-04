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

-- TODO: how to add additional pattern-based highlight?
-- * matchadd(): this is window-local
-- * https://github.com/folke/paint.nvim
-- * enable regex highlight, set b:current_syntax to disable the usual syntax/*.vim, and add :syn as needed
