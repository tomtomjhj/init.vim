-- An alternative implmentation of <https://github.com/folke/paint.nvim>
-- with decoration provider

local M = {}

---@class PaintHighlight
---@field filter fun(b: integer): any
---@field pattern string
---@field hl string

---@type PaintHighlight[]
M.config = {
  {
    filter = function(b)
      local ft = vim.bo[b].filetype
      return ft == '' or ft == 'markdown'
    end,
    pattern = "TODO",
    hl = "Todo",
  },
}

local ns = vim.api.nvim_create_namespace('tomtomjhj/hightlight')

---@return PaintHighlight[]
local function get_highlights(buf)
  return vim.tbl_filter(
  ---@param hl PaintHighlight
    function(hl)
      return hl.filter(buf)
    end,
    M.config
  )
end

---@return boolean
local function set_marks(buf, topline, botline)
  local highlights = get_highlights(buf)
  if #highlights == 0 then
    return false
  end

  local lines = vim.api.nvim_buf_get_lines(buf, topline, botline + 1, false)
  for l, line in ipairs(lines) do
    local lnum = topline + (l - 1)
    if #line > 1024 then
      line = line:sub(1, 1024)
    end

    for _, hl in ipairs(highlights) do
      local from, to, match = line:find(hl.pattern)

      while from do
        if match and match ~= "" then
          from, to = line:find(match, from, true)
        end

        vim.api.nvim_buf_set_extmark(buf, ns, lnum, from - 1, {
          end_col = to, hl_group = hl.hl, priority = 110, ephemeral = true,
        })

        from, to, match = line:find(hl.pattern, to + 1)
      end
    end
  end

  return true
end

vim.api.nvim_set_decoration_provider(ns, {
  -- Fast enough.
  on_win = function(_, _, buf, topline, botline)
    return set_marks(buf, topline, botline)
  end
})

return M
