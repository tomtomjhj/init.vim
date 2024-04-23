local parsers = require("nvim-treesitter.parsers")

M = {}

local disable = {
  "vim",  -- less complete
}
local disable_highlight = vim.list_extend({'latex'}, disable)
local disable_indent = vim.list_extend({'latex', 'markdown', 'lua', 'c'}, disable)

-- lua indet broken
-- f(function()
--   g()
-- end, {
--   f = function()
--       -- two indents here. this also ignores autoindent
--   end,
-- })


local custom_queries = {
  markdown = {
    -- NOTE: section doesn't work for setext heading https://github.com/MDeiml/tree-sitter-markdown/issues/59
    -- NOTE: the paragraphs at the start of the document also make up a section. https://github.com/MDeiml/tree-sitter-markdown/blob/936cc84289f6de83c263ae8e659fb342867ceb16/tree-sitter-markdown/grammar.js#L24C18-L24C18
    folds = '(section) @fold',
  }
  -- TODO(latex): include trailing comment fold
}

local ag = vim.api.nvim_create_augroup("treesitter-custom", { clear = true })

-- NOTE: This autocmd is run AFTER syntaxset autocmd, which loads syntax/*.vim
-- files, because this file must be sourced after plug#end, because it depends
-- on nvim-treesitter.
vim.api.nvim_create_autocmd(
  { "FileType" },
  { group = ag, pattern = "*",
    desc = 'enable treesitter stuff and custom treesitter stuff',
    callback = function(ev)
      local lang = vim.treesitter.language.get_lang(ev.match)
      if not lang or vim.tbl_contains(disable, lang) or not parsers.has_parser(lang) then return end
      if custom_queries[lang] then
        for name, query in pairs(custom_queries[lang]) do
          vim.treesitter.query.set(lang, name, query)
        end
        custom_queries[lang] = nil
      end
      if not vim.tbl_contains(disable_highlight, lang) then
        vim.treesitter.start(ev.buf, lang)
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. '|' or '') .. [[exe 'lua vim.treesitter.stop()']]
      end
      if vim.treesitter.query.get(lang, 'folds') and vim.wo.foldmethod ~= 'diff' then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. '|' or '') .. [[setl foldexpr< foldmethod<]]
      end
    end
  }
)

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  indent = {
    enable = false; -- uses full buffer query. 100ms latency for 10K line file
    -- disable = disable_indent,
  },
  incremental_selection = {
    enable = true,
    disable = disable,
    keymaps = {
      init_selection = "<leader><tab>",
      node_incremental = "<tab>", -- fine, because the builtin CTRL-I doesn't work in visual mode
      node_decremental = "<s-tab>",
      scope_incremental = "<leader><tab>",
    },
  },
  -- TODO; matchup treesitter incurs noticeable input lag in the middle of big c file e.g. normal.c
  -- 73%  matches
  --   <- 100%  (for generator) < collect_group_results < fn < for_each_tree < fn < get_matches < fn < get_active_nodes < get_delim
  matchup = {
    enable = true,
  },
}

--- function for textobj-user
function M.markdown_fenced_codeblock(outer)
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return 0 end
  if node:type() == 'block_continuation' then
    node = node:parent()
  end
  if node:type() ~= 'code_fence_content' then return 0 end
  local srow, _, erow, _ = node:range()
  return {'V', {0, srow + 1 - (outer and 1 or 0), 1, 0}, {0, erow + 1 - (outer and 0 or 1), 1, 0}}
end

return M
