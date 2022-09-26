local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')

fzf.setup {
  winopts = {
    border = false, -- Use fzf's --border=top instead
    height = 0.5,
    width = 1,
    row = 1,
    col = 0,
    preview = {
      default = 'bat',
    }
  },
  actions = {
    files = {
      -- files, git_files, git_status, grep, lsp oldfiles, quickfix, loclist, tags, btags args
      ["default"]     = actions.file_edit_or_qf,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-x"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["alt-q"]       = actions.file_sel_to_qf,
      ["alt-l"]       = actions.file_sel_to_ll,
    },
    buffers = {
      -- buffers, tabs, lines, blines
      ["default"]     = actions.buf_edit,
      ["ctrl-s"]      = actions.buf_split,
      ["ctrl-x"]      = actions.buf_split,
      ["ctrl-v"]      = actions.buf_vsplit,
      ["ctrl-t"]      = actions.buf_tabedit,
    }
  },
  fzf_opts = {
    ['--border']      = 'top',
  }
}

fzf.register_ui_select()
