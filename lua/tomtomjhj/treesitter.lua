local disable = {
  "vim",  -- less complete
}
local disable_highlight = vim.list_extend({'latex'}, disable)
local disable_indent = vim.list_extend({'latex', 'markdown', 'lua', 'c'}, disable)
local syn = {
  "python", -- TODO: indent/python.vim relies too much on :syn
}

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
-- on nvim-treesitter. 2025-09-22: No longer true.
vim.api.nvim_create_autocmd(
  { "FileType" },
  { group = ag, pattern = "*",
    desc = 'enable treesitter stuff and custom treesitter stuff',
    callback = function(ev)
      if not vim.api.nvim_buf_is_loaded(ev.buf) then
        -- not sure why this can happen, but it did happen, which made get_parser fail
        return
      end
      local lang = vim.treesitter.language.get_lang(ev.match)
      if not lang
          or vim.tbl_contains(disable, lang)
          or not vim.treesitter.get_parser(ev.buf, lang, { error = false })
      then
        return
      end
      if custom_queries[lang] then
        for name, query in pairs(custom_queries[lang]) do
          vim.treesitter.query.set(lang, name, query)
        end
        custom_queries[lang] = nil
      end
      if not vim.tbl_contains(disable_highlight, lang) and not vim.b.ts_highlight then
        vim.treesitter.start(ev.buf, lang)
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. '|' or '') .. [[exe 'lua vim.treesitter.stop()']]
        if vim.tbl_contains(syn, lang) then
          vim.bo.syntax = 'on'
        end
      end
      -- uses full buffer query. 100ms latency for 10K line file
      if false and not vim.tbl_contains(disable_indent, lang) and vim.treesitter.query.get(lang, 'indent') then
        vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      if vim.treesitter.query.get(lang, 'folds') and vim.wo.foldmethod ~= 'diff' then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. '|' or '') .. [[setl foldexpr< foldmethod<]]
      end
    end
  }
)

-- NOTE: These are bundled with nvim, which can get out of sync with nvim-treesitter queries.
-- So I install these in vim-plug post-update hook.
-- require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" })

-- TODO: (2024) matchup treesitter incurs noticeable input lag in the middle of big c file e.g. normal.c
-- 73%  matches
--   <- 100%  (for generator) < collect_group_results < fn < for_each_tree < fn < get_matches < fn < get_active_nodes < get_delim
vim.g.matchup_treesitter_disabled = { "c" }
