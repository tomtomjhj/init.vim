-- https://github.com/smjonas/snippet-converter.nvim/blob/main/doc/documentation.md

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
  settings = { ui = { use_nerdfont_icons = false } },
  templates = { template },
  -- To change the default settings (see configuration section in the documentation)
  -- settings = {},
}
