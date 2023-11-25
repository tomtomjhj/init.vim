local fzf = require('fzf-lua')

-- notes
-- * Preview buffer's ftdetect uses `:filetype detect`, which is somewhat broken? `*.v` file doesn't get recognized as coq.
-- * Does not reuse the buffer for preview <https://github.com/ibhagwan/fzf-lua/issues/208#issuecomment-962550013>...

fzf.setup {
  "fzf-native",
  keymap = {
    fzf = {
      ["ctrl-alt-j"] = "preview-half-page-down",
      ["ctrl-alt-k"] = "preview-half-page-up",
      ["shift-down"] = "preview-down",
      ["shift-up"]   = "preview-up",
    },
  },
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
    code_actions = {
      winopts = {
        row = 1,
      },
    },
  }
}

fzf.register_ui_select()
