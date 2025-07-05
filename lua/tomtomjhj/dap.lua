local api = vim.api

-- TODO
-- * dap-view: don't mask motion keymaps. currently not customizable
-- * dap-view: various invalid window/buffer errors after bufwipe? maybe state not cleared
-- * what to do with multiple signs? (e.g., breakpoint + diagnostics)
-- * highlights for breakpoint + cursorline?

local M = {}

local dap_view = require('dap-view')
local dap = require('dap')

-- Custom method for switchbuf config.
-- nvim-dap and nvim-dap-view should be patched to use this function,
-- because do not yet support proper customization.
-- See also: https://github.com/mfussenegger/nvim-dap/pull/1485
function M.smartsplit(bufnr)
  local base_win_candidates = {}
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    local bo = vim.bo[api.nvim_win_get_buf(win)]
    if not bo.filetype:match('^dap-')
      and bo.buftype == ''
      and api.nvim_win_get_config(win).relative == ''
    then
      base_win_candidates[#base_win_candidates + 1] = {
        win,
        api.nvim_win_get_width(win),
        api.nvim_win_get_height(win),
      }
    end
  end
  -- sort by area
  table.sort(base_win_candidates, function(l, r) return l[2] * l[3] < r[2] * r[3] end)
  if #base_win_candidates > 0 then
    local base_win, width, _ = unpack(base_win_candidates[#base_win_candidates])
    local saved_curwin = api.nvim_get_current_win()
    api.nvim_set_current_win(base_win)
    if width >= 160 then
      vim.cmd('vert sbuffer ' .. bufnr)
    else
      vim.cmd('sbuffer ' .. bufnr)
    end
    -- make CTRL-W_p work as expected
    local target_win = api.nvim_get_current_win()
    api.nvim_set_current_win(saved_curwin)
    api.nvim_set_current_win(target_win)
  else
    vim.cmd('topleft sbuffer ' .. bufnr)
  end
end

dap_view.setup {
  switchbuf = "useopen", -- NOTE: my nvim-dap-view patch to use smartsplit as fallback
  winbar = {
    headers = {
      breakpoints = "[B]reakpoints",
      scopes = "[S]copes",
      exceptions = "[E]xceptions",
      watches = "[W]atches",
      threads = "[T]hreads",
      repl = "[R]EPL",
      console = "[C]onsole",
    },
    controls = {
      enabled = true,
      icons = {
        pause = "⏸︎",
        play = "⏵︎",
        step_into = "↓",
        step_over = "→",
        step_out = "↑",
        step_back = "←",
        run_last = "↻",
        terminate = "⏹︎",
        disconnect = "⏏︎",
      },
    }
  }
}

-- NOTE: my nvim-dap patch to use smartsplit
dap.defaults.fallback.switchbuf = "usevisible,useopen,smartsplit"

dap.listeners.before.event_initialized['tomtomjhj'] = dap_view.open
-- dap.listeners.before.event_terminated["tomtomjhj"] = dap_view.close
-- dap.listeners.before.event_exited["tomtomjhj"] = dap_view.close

require("dap.ext.vscode").json_decode = function(str)
  return vim.json.decode(require("plenary.json").json_strip_comments(str))
end

-- Use the binary installed in mason's PATH
require('dap-python').setup("debugpy-adapter")
-- NOTE: The default for cwd is the parent directory of the script being
-- debugged, which in most cases not what I would expect. Set it to workspace
-- root. vscode does something similar (launches debugpy after cd-ing into
-- workspaceFolder).
-- For configs in launch.json, put this:
--   "cwd": "${workspaceFolder}"
for _, conf in ipairs(dap.configurations.python) do
  conf.cwd = "${workspaceFolder}"
  -- still does not show call stack for those code..
  conf.justMyCode = false
end

return M
