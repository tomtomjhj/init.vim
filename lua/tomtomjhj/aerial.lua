local aerial = require('aerial')

-- NOTE: aerial overrides documentSymbol handler, which breaks vim.lsp.buf.document_symbol()
aerial.setup {
  backends = {
    tex = {},
    c = {'lsp', 'treesitter'}, -- trailing macro stuff in function def confuses treesitter
    cpp = {'lsp', 'treesitter'},
  },
  link_tree_to_folds = false,
  post_jump_cmd = 'normal! zv',
  on_attach = function(bufnr)
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
}
