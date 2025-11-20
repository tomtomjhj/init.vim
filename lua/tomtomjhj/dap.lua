local api = vim.api

-- TODO
-- * dap-view: don't mask motion keymaps. currently not customizable
-- * dap-view: various invalid window/buffer errors after bufwipe? maybe state not cleared
-- * what to do with multiple signs? (e.g., breakpoint + diagnostics)
-- * highlights for breakpoint + cursorline?
-- * dap-view: <C-w><CR> to split open breakpoint/...
-- * dap-view: terminal closes on session end. https://github.com/mfussenegger/nvim-dap/discussions/1523
-- * dap-view: run_last does not up terminal properly (set nonumber, etc) if previous session not terminated

local dap_view = require('dap-view')
local dap = require('dap')

vim.keymap.set({ 'n', 'v' }, '<M->>', function()
  require('dap.ui.widgets').hover(nil, { border = 'single' })
end)
vim.keymap.set('n', '<C-M-j>', '<Cmd>DapStepOver<CR>')
vim.keymap.set('n', '<C-M-l>', '<Cmd>DapStepInto<CR>')
vim.keymap.set('n', '<C-M-h>', '<Cmd>DapStepOut<CR>')

vim.api.nvim_create_user_command('DapToggleBreakpoint', function(args)
  if #args.args > 0 then
    dap.set_breakpoint(args.args) -- conditional breakpoint
  else
    dap.toggle_breakpoint()
  end
end, {
  nargs = "?",
  force = true,
})

local function maybe_smartsplit(bufnr)
  local max_area = -1
  local max_area_win = -1
  local max_winnr = -1
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    local bo = vim.bo[api.nvim_win_get_buf(win)]
    -- only consider normal file windows
    if not bo.filetype:match('^dap-')
        and bo.buftype == ''
        and api.nvim_win_get_config(win).relative == ''
    then
      local area = api.nvim_win_get_width(win) * api.nvim_win_get_height(win)
      if area > max_area then
        max_area = area
        max_area_win = win
      elseif area == max_area and api.nvim_win_get_number(win) > max_winnr then
        max_area_win = win
      end
      max_winnr = math.max(max_winnr, api.nvim_win_get_number(win))
    end
  end

  if max_area_win < 0 then
    vim.cmd('topleft sbuffer ' .. bufnr)
    return
  end

  -- split from the largest window, if large enough
  local width = api.nvim_win_get_width(max_area_win)
  local height = api.nvim_win_get_height(max_area_win)
  if width >= 160 or height >= 30 then
    local saved_curwin = api.nvim_get_current_win()
    api.nvim_set_current_win(max_area_win)
    if width >= 160 then
      vim.cmd('vert sbuffer ' .. bufnr)
    else
      vim.cmd('sbuffer ' .. bufnr)
    end
    -- make CTRL-W_p work as expected
    local target_win = api.nvim_get_current_win()
    api.nvim_set_current_win(saved_curwin)
    api.nvim_set_current_win(target_win)
    return
  end

  api.nvim_set_current_win(vim.fn.win_getid(max_winnr))
  api.nvim_win_set_buf(0, bufnr)
end

local function set_cursor(win, line, column)
  local ok, err = pcall(api.nvim_win_set_cursor, win, { line, column - 1 })
  if ok then
    local curbuf = api.nvim_get_current_buf()
    if vim.bo[curbuf].filetype ~= "dap-repl" then
      api.nvim_set_current_win(win)
    end
    api.nvim_win_call(win, function()
      api.nvim_command('normal! zv')
    end)
  else
    local msg = string.format(
      "Adapter reported a frame in buf %d line %s column %s, but: %s. "
      .. "Ensure executable is up2date and if using a source mapping ensure it is correct",
      api.nvim_win_get_buf(win),
      line,
      column,
      err
    )
    require('dap.utils').notify(msg, vim.log.levels.WARN)
  end
end

local function dap_switchbuf(bufnr, line, column)
  local cur_win = api.nvim_get_current_win()

  -- usevisible
  if api.nvim_win_get_buf(cur_win) == bufnr then
    local first = vim.fn.line("w0", cur_win)
    local last = vim.fn.line("w$", cur_win)
    if first <= line and line <= last then
      return true
    end
  end

  -- useopen
  if api.nvim_win_get_buf(cur_win) == bufnr then
    set_cursor(cur_win, line, column)
    return true
  end
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    if api.nvim_win_get_buf(win) == bufnr then
      set_cursor(win, line, column)
      return true
    end
  end

  maybe_smartsplit(bufnr)
  set_cursor(api.nvim_get_current_win(), line, column)
  return true
end

-- buf, win → win?; no jump needed (but ok to do)
local function dap_view_switchbuf(buf, win)
  local win = require('dap-view.views.windows.switchbuf').switchbuf_winfn.useopen(buf, win)
  if win then return win end
  maybe_smartsplit(buf)
  return api.nvim_get_current_win()
end

dap_view.setup {
  switchbuf = dap_view_switchbuf,
  winbar = {
    base_sections = {
      breakpoints = { label = "[B]reakpoints", short_label = "[B]" },
      scopes = { label = "[S]copes", short_label = "[S]" },
      exceptions = { label = "[E]xceptions", short_label = "[E]" },
      watches = { label = "[W]atches", short_label = "[W]" },
      threads = { label = "[T]hreads", short_label = "[T]" },
      repl = { label = "[R]EPL", short_label = "[R]" },
      console = { label = "[C]onsole", short_label = "[C]" },
    },
    controls = {
      enabled = true,
    }
  },
  icons = {
    disabled = "⮾",
    disconnect = "⏏︎",
    enabled = "◯",
    filter = "⊆",
    negate = "¬ ",
    pause = "⏸︎",
    play = "⏵︎",
    run_last = "↻", -- TODO: remember file and args?
    step_back = "←",
    step_into = "↓",
    step_out = "↑",
    step_over = "→",
    terminate = "⏹︎",
  },
}

-- NOTE: my nvim-dap patch to use smartsplit
dap.defaults.fallback.switchbuf = dap_switchbuf

dap.listeners.before.event_initialized['tomtomjhj'] = dap_view.open
-- dap.listeners.before.event_terminated["tomtomjhj"] = dap_view.close
-- dap.listeners.before.event_exited["tomtomjhj"] = dap_view.close

require("dap.ext.vscode").json_decode = function(str)
  return vim.json.decode(require("plenary.json").json_strip_comments(str))
end

-------------------------------------------------------------------------------

local function prompt_program()
  local ok, path = pcall(vim.fn.input, 'Path to program: ', vim.fn.getcwd() .. '/', 'file')
  if not ok then
    return dap.ABORT
  end
  return path
end
local function prompt_args()
  local ok, args_string = pcall(vim.fn.input, 'Arguments: ', '', 'file')
  if not ok then
    return dap.ABORT
  end
  return require('dap.utils').splitstr(args_string)
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
  -- NOTE: dap-view hides "subtle" frames by default. toggle with `t`
  conf.justMyCode = false
end

-- from cpptools
-- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7', -- in mason path
}
-- NOTE: OpenDebugAD7 does not have supportsTerminateRequest capability.

dap.providers.configs['global_gdb'] = function()
  return {
    {
      name = "global cppdbg",
      type = "cppdbg",
      request = "launch",
      cwd = '${workspaceFolder}',
      -- NOTE: There is no evalution ordering guarantee.
      -- Also it's impossible to prompt a single command and split into program and args.
      -- TODO: special field that takes a function and returns table of all other fields?
      program = prompt_program,
      args = prompt_args,
      console = "integratedTerminal",
      setupCommands = {
        {
          text = '-enable-pretty-printing',
          description = 'enable pretty printing',
          ignoreFailures = false,
        },
      },
    },
  }
end
