local cmp = require'cmp'

cmp.register_source('tags', require'tomtomjhj/cmp_tags'.new())

-- TODO: ignore huge buffer, huge buffer updates
local ignored_buftype = { quickfix = true, terminal = true, prompt = true }
local function get_visible_bufnrs()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, 'buflisted') and not ignored_buftype[vim.api.nvim_buf_get_option(buf, 'buftype')] then
      bufs[#bufs+1] = buf
    end
  end
  return bufs
end

local function after_iskeyword()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col > 0 and vim.regex([[\k]]):match_str(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)) ~= nil
end

-- TODO
-- cmp issues
-- * matching/filter
--   * smartcase matching
-- * buffer source
--   * first letter case adjustment like coc
--   * Don't add the word currently being editted in the middle e.g. `pre|suffix`.
-- * keyword_pattern does 2 things: the pattern for item, and condition to list
--   the source's item (pattern of the word before cursor)

vim.opt.completeopt:append('menuone')
cmp.setup {
  completion = {
    -- NOTE: this menuone doesn't apply to native popup
    completeopt = [[menuone,noselect]],
  },
  preselect = cmp.PreselectMode.None,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer',
      option = {
        keyword_pattern = [[\<\K\k\{-,38}\>]], -- TODO: per-ft keyword pattern? e.g. no \k for help file
        get_bufnrs = get_visible_bufnrs,
      }
    },
    { name = 'ultisnips' },
    { name = 'tags' },
  },
  experimental = {
    ghost_text = false,
  },
  mapping = cmp.mapping.preset.insert {
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
      -- TODO: dup = 0 for buffer source? didn't work
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
