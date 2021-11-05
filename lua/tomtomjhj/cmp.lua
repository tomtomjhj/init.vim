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

-- TODO: move this to lsp.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- TODO
-- cmp issues
-- * matching/filter
--   * exact matching on the first char e.g.  ")" should not match "c)" snippet.
--   * smartcase matching
-- * scroll_docs() should fallback when *documentation window* is not visible
-- * mappings are not set on InsertEnter if Coq is already active
-- * buffer source: first letter adjustment like coc
-- * sometime completion dies. No anomally detected by :CmpStatus
-- 
-- Old issues from compe that might have been fixed in cmp
-- * buffer source: don't add the word currently being inserted e.g. `presuffix` in the above example.
--   Note: this only happens when inserting prefix of the word
-- * sometimes completion deletes the text on the left of the input??

-- TODO: what's keyword_pattern?? It does 2 things: the pattern for item,
-- condition to list the source's item (pattern of the word before cursor)
-- See also: https://github.com/hrsh7th/nvim-cmp/issues/444
cmp.setup {
  completion = {
    completeopt = [[menuone,noselect]],
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer',
      opts = {
        keyword_pattern = [[\K\k\{-,30}\>]], -- TODO: help file's iskeyword
        get_bufnrs = get_visible_bufnrs,
      }
    },
    { name = 'ultisnips' },
    { name = 'tags' },
  },
  experimental = {
    native_menu = false,
    ghost_text = false,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true, -- automatically select the entry
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
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

-- TODO cmp.setup.cmdline {}


vim.cmd [[
hi! CmpItemAbbrMatch guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=bold cterm=bold
]]
-- CmpItemAbbr
-- CmpItemAbbrDeprecated
-- CmpItemAbbrMatch
-- CmpItemAbbrMatchFuzzy
-- CmpItemKind
-- CmpItemMenu
