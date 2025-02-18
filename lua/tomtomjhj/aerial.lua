local aerial = require('aerial')

local function on_attach(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft ~= 'tex' then
    vim.keymap.set('n', '[[', aerial.prev, { buffer = bufnr })
    vim.keymap.set('n', ']]', aerial.next, { buffer = bufnr })
  end
  vim.keymap.set('n', '<leader>fl', '<Cmd>call aerial#fzf()<CR>', { buffer = bufnr })
  if ft ~= 'help' then
    vim.keymap.set('n', 'gO', '<Cmd>AerialToggle! right<CR>', { buffer = bufnr })
  end
end

aerial.setup {
  backends = {
    tex = {},
    c = {'lsp', 'treesitter'}, -- trailing macro stuff in function def confuses treesitter
    cpp = {'lsp', 'treesitter'},
  },
  link_tree_to_folds = false,
  post_jump_cmd = 'normal! zv',
  on_attach = on_attach,
}

-- NOTE: aerial calls on_attach only once.
-- But FileType autocmd may run multiple times (e.g. :e), so my aerial mappings may be overwritten.
-- So prevent this, call my on_attach again on FileType.
-- btw aerial on_enter_buffer is throttled and vim.schedule()ed
-- https://github.com/stevearc/aerial.nvim/issues/449
local ag = vim.api.nvim_create_augroup("aerial-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = ag,
  callback = function(ev)
    local ab = require('aerial.backends')
    if vim.b[ev.buf].aerial_backend then
      on_attach(ev.buf)
      aerial.refetch_symbols(ev.buf)
    end
  end,
})

