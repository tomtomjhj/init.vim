local cmp = require'cmp'

-- TODO: ignore huge buffer, ...
-- https://github.com/hrsh7th/cmp-buffer/pull/12
local function get_visible_bufnrs()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    bufs[vim.api.nvim_win_get_buf(win)] = true
  end
  return vim.tbl_keys(bufs)
end

local function after_iskeyword()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col > 0 and vim.regex([[\k]]):match_str(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)) ~= nil
end

-- TODO
-- cmp issues
-- * matching/filter
--   * exact matching on the first char e.g.  ")" should not match "c)" snippet.
--   * smartcase matching
-- * scroll_docs() should fallback when *documentation window* is not visible
-- * buffer source: first letter adjustment like coc
-- * sometime completion dies. No anomally detected by :CmpStatus
-- 
-- Old issues from compe that might have been fixed in cmp
-- * buffer source: don't add the word currently being inserted e.g. `presuffix` in the above example.
--   Note: this only happens when inserting prefix of the word
-- * sometimes completion deletes the text on the left of the input??

-- NOTE: keyword_pattern does 2 things: the pattern for item, and
-- condition to list the source's item (pattern of the word before cursor)
cmp.setup {
  completion = {
    completeopt = [[menuone,noselect]],
  },
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer',
      option = {
        keyword_pattern = [[\<\K\k\{-,30}\>]], -- TODO: per-ft keyword pattern? e.g. no \k for help file
        get_bufnrs = get_visible_bufnrs,
      }
    },
    { name = 'ultisnips' },
    { name = 'tags' },
  },
  experimental = {
    native_menu = true, -- NOTE: temporary mitigation for https://github.com/hrsh7th/nvim-cmp/issues/328
    ghost_text = false,
  },
  mapping = {
    -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true, -- automatically select the entry
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif after_iskeyword() then
        cmp.complete()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif after_iskeyword() then
        cmp.complete()
      else
        fallback()
      end
    end,
  },
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      if vim_item.kind == "Text" then
        vim_item.kind = ""
      end
      vim_item.menu = ({
          buffer = "[B]",
          nvim_lsp = "[LS]",
          ultisnips = "[US]",
          tags = "[T]",
        })[entry.source.name]
      return vim_item
    end,
  },
}

-- TODO: This disables hlsearch when the menu is refreshed.
-- cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

-- TODO: breaks completion when :command-count and :command-modifiers are used
-- https://github.com/hrsh7th/cmp-cmdline/issues/20
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })
