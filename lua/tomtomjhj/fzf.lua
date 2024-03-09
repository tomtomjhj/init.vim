local fzf = require('fzf-lua')

-- notes
-- * Preview buffer's ftdetect uses `:filetype detect`, which is somewhat broken? `*.v` file doesn't get recognized as coq.
-- * Does not reuse the buffer for preview <https://github.com/ibhagwan/fzf-lua/issues/208#issuecomment-962550013>...

fzf.setup {
  "fzf-native",
  winopts = {
    border = false, -- Use fzf's --border=top instead
    height = 0.5,
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
    code_actions = {
      winopts = {
        row = 1,
      },
    },
  },
}

fzf.register_ui_select()

-- default highlights are quite broken
for group, hl in pairs {
  FzfLuaHeaderBind = { force = true, link = "NONE" },
  FzfLuaHeaderText = { force = true, link = "NONE" },
  FzfLuaBufName = { force = true, link = "NONE" },
  FzfLuaBufNr = { force = true, link = "NONE" },
  FzfLuaBufLineNr = { force = true, link = "NONE" },
  FzfLuaBufFlagCur = { force = true, link = "NONE" },
  FzfLuaBufFlagAlt = { force = true, link = "NONE" },
  FzfLuaTabTitle = { force = true, link = "NONE" },
  FzfLuaTabMarker = { force = true, link = "NONE" },
  FzfLuaLiveSym = { force = true, link = "NONE" },
} do
  vim.api.nvim_set_hl(0, group, hl)
end

vim.keymap.set("n", "<leader>b", function() fzf.buffers({ fzf_opts = { ["--layout"] = "default" } }) end)
