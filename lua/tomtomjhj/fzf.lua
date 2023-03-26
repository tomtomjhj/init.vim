local fzf = require('fzf-lua')

fzf.setup {
  "fzf-native",
  fzf_opts = {
    ['--border']      = 'top',
  },
  global_file_icons = false,
  winopts = {
    border = false, -- Use fzf's --border=top instead
    height = 0.5,
    width = 1,
    row = 1,
    col = 0,
  },
  lsp = {
    includeDeclaration = false,
  }
}

fzf.register_ui_select()
