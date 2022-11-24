require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true;
    disable = {
      "python",
      "vim",  -- less complete
      "help", -- conceal broken
      "markdown" -- slow
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
