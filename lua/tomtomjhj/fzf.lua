-- -- now fzf-lua always overrides these????
-- vim.cmd[[
-- hi def link FzfLuaHeaderBind String
-- hi def link FzfLuaHeaderText Comment
-- hi def link FzfLuaBufName    Normal
-- hi def link FzfLuaBufNr      Number
-- hi def link FzfLuaBufLineNr  LineNr
-- hi def link FzfLuaBufFlagCur Label
-- hi def link FzfLuaBufFlagAlt Label
-- hi def link FzfLuaTabTitle   Title
-- hi def link FzfLuaTabMarker  Normal
-- hi def link FzfLuaLiveSym    Special
-- ]]

local fzf = require('fzf-lua')

-- notes
-- * Preview buffer's ftdetect uses `:filetype detect`, which is somewhat broken? `*.v` file doesn't get recognized as coq.
-- * Does not reuse the buffer for preview <https://github.com/ibhagwan/fzf-lua/issues/208#issuecomment-962550013>...

-- TODO: add selected items to quickfix. useful for collecting non-immediate references

fzf.setup {
  "fzf-native",
  winopts = {
    border = false, -- Use fzf's --border=top instead
    height = 0.499,
    width = 1,
    row = 1,
    col = 0,
    preview = {
      vertical = "up:45%",
    },
  },
  keymap = {
    fzf = {
      ["ctrl-alt-j"] = "preview-half-page-down",
      ["ctrl-alt-k"] = "preview-half-page-up",
      ["shift-down"] = "preview-down",
      ["shift-up"]   = "preview-up",
      ["ctrl-/"]     = "toggle-preview",
      ["alt-a"]      = "select-all",
      ["alt-d"]      = "deselect-all",
    },
  },
  fzf_opts = {
    ['--border'] = 'top',
    -- ["--layout"] = "default",
    --   default: near the position of cmdline
    --   reverse: prompt at the center, avg shorter eye travel
    --   reverse-list: like default, but preserves the natural line order
  },
  previewers = {
    builtin = { syntax = false },
  },

  -- providers
  default = {
    file_icons = false,
  },
  lsp = {
    includeDeclaration = false,
    symbols = {
      symbol_fmt = function() return "" end,  -- this symbol thing is more or less useless
    },
    code_actions = {
      winopts = {
        row = 1,
      },
    },
  },
}

fzf.register_ui_select()

vim.keymap.set("n", "<leader>b", function() fzf.buffers({ fzf_opts = { ["--layout"] = "default" } }) end)
