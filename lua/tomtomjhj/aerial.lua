local aerial = require('aerial')

-- NOTE: aerial overrides documentSymbol handler
aerial.setup {
  backends = {
    tex = {},
  },
  link_tree_to_folds = false,
  on_attach = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft ~= 'tex' then
      vim.keymap.set('n', '[[', function()
        -- https://github.com/stevearc/aerial.nvim/issues/266
        vim.cmd [[normal! m']]
        aerial.prev(vim.v.count1)
      end, { buffer = bufnr })
      vim.keymap.set('n', ']]', function()
        vim.cmd [[normal! m']]
        aerial.next(vim.v.count1)
      end, { buffer = bufnr })
    end
    vim.keymap.set('n', '<leader>fl', '<Cmd>call aerial#fzf()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>ol', '<Cmd>AerialToggle! right<CR>', { buffer = bufnr })
  end
}
