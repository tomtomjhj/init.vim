local template = {
  -- name = "t1", (optionally give your template a name to refer to it in the `ConvertSnippets` command)
  sources = {
    ultisnips = {
      vim.fn.expand("~/.vim/UltiSnips"),
    },
  },
  output = {
    vsnip = {
      vim.fn.expand("~/.vim/vsnip-scratch"),
    },
  },
}

require("snippet_converter").setup {
  templates = { template },
  -- To change the default settings (see configuration section in the documentation)
  -- settings = {},
}
