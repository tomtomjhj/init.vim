local parsers = require("nvim-treesitter.parsers")

local disable = {
  "latex", -- use vimtex for latex file; but use treesitter for markdown inline latex
  "vim",  -- less complete
}

local custom_queries = {
  markdown = {
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
      vim.treesitter.start(ev.buf, lang)
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  }
)

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  indent = {
    enable = true;
    disable = vim.list_extend({'markdown'}, disable);
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
