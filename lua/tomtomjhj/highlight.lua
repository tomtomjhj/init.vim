-- An alternative implmentation of <https://github.com/folke/paint.nvim>
-- with decoration provider
--
-- Not using matchadd() because it's window-local and thus cumbersome to manage.
--
-- Not using the new matchbufline() function because it doesn't have column limit.

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

---@type PaintHighlight[]?
local highlighting

local function on_line(buf, lnum)
  local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1]
  -- If there is a diff filler line at the end of buffer, on_line is
  -- invoked for the next line of the last line. 0.8-0.9 are affected.
  if not line then
    return
  end

  if #line > 1024 then
    line = line:sub(1, 1024)
  end

  for _, hl in ipairs(assert(highlighting)) do
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

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, buf, _, _)
    highlighting = vim.tbl_filter(function(hl) return hl.filter(buf) end, M.config)
    return #highlighting > 0
  end,
  on_line = function(_, _, buf, lnum)
    on_line(buf, lnum)
  end,
})

return M
