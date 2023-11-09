local aerial = require('aerial')

-- NOTE: aerial overrides documentSymbol handler
aerial.setup {
  backends = {
    tex = {},
    c = {'lsp', 'treesitter'}, -- trailing macro stuff in function def confuses treesitter
  },
  link_tree_to_folds = false,
  post_jump_cmd = 'normal! zv',
  on_attach = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft ~= 'tex' then
      vim.keymap.set('n', '[[', function()
        -- https://github.com/stevearc/aerial.nvim/issues/266
        local count = vim.v.count1
        vim.cmd [[normal! m']]
        aerial.prev(count)
      end, { buffer = bufnr })
      vim.keymap.set('n', ']]', function()
        local count = vim.v.count1
        vim.cmd [[normal! m']]
        aerial.next(count)
      end, { buffer = bufnr })
    end
    vim.keymap.set('n', '<leader>fl', '<Cmd>call aerial#fzf()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>ol', '<Cmd>AerialToggle! right<CR>', { buffer = bufnr })
  end
}
