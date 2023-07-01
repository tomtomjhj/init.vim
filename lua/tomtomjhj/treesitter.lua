local parsers = require("nvim-treesitter.parsers")

M = {}

local disable = {
  "vim",  -- less complete
  "bash", -- broken https://github.com/tree-sitter/tree-sitter-bash/issues/66
}
local disable_highlight = vim.list_extend({'latex'}, disable)
local disable_indent = vim.list_extend({'latex', 'markdown'}, disable)

local custom_queries = {
  markdown = {
    -- NOTE: section doesn't work for setext heading https://github.com/MDeiml/tree-sitter-markdown/issues/59
    folds = '[ (section) ] @fold',
  }
}

local ag = vim.api.nvim_create_augroup("treesitter-custom", { clear = true })

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
      end
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  }
)

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  indent = {
    enable = true;
    disable = disable_indent,
  },
  incremental_selection = {
    enable = true,
    disable = disable,
    keymaps = {
      init_selection = "<leader><tab>",
      node_incremental = "<leader><tab>",
      node_decremental = "<s-tab>",
      scope_incremental = "<leader><s-tab>",
    },
  },
}

local highlighter = vim.treesitter.highlighter
-- comment injection is slow https://gist.github.com/tomtomjhj/95c2feec72f35e6a6942fd792587bb4e
require("paint").setup {
  highlights = {
    {
      filter = function(b) return highlighter.active[b] end,
      pattern = "TODO",
      hl = "Todo",
    },
    {
      -- lua ---@ comment
      filter = function(b)
        return highlighter.active[b] and vim.bo[b].filetype == 'lua'
      end,
      pattern = "%s*%-%-%-%s*(@%w+)",
      hl = "Constant",
    },
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
