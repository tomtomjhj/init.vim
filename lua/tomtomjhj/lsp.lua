local lspconfig = require('lspconfig')

local M = {}

-- utils {{{

local function position_mark_to_api(position)
  return { position[1] - 1, position[2] }
end

local function position_api_to_lsp(bufnr, position, offset_encoding)
  local row, col = unpack(position)
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, true)[1]
  if not line then
    return { line = 0, character = 0 }
  end
  return { line = row, character = vim.lsp.util._str_utfindex_enc(line, col, offset_encoding) }
end

local function in_range(pos, range)
  if pos.line < range.start.line or pos.line > range['end'].line then return false end
  if
    pos.line == range.start.line and pos.character < range.start.character or
    pos.line == range['end'].line and pos.character > range['end'].character
  then
    return false
  end
  return true
end

function M.toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    -- TODO: with ltex, diagnostic.lua:1010: Invalid 'line': out of range
    vim.diagnostic.enable()
    print('Enabled diagnostics')
  else
    vim.diagnostic.disable()
    print('Disabled diagnostics')
  end
end
--- }}}

-- breadcrumb {{{

-- TODO: activate winbar for window with buffer attached to lsp supporting documentSymbol..
-- Just check the existence of vim.b.breadcrumb?

-- NOTE: Symbol kind stuff is very arbitary. rust-analyzer uses "Object" for `impl`. lua-ls uses "Package" for `if`.
local breadcrumb_kind = {}
for _, kind in ipairs { "Class", "Function", "Method", "Struct", "Enum", "Interface", "Namespace", "Module", } do
  breadcrumb_kind[vim.lsp.protocol.SymbolKind[kind]] = true
end

local function build_breadcrumb(symbols, position)
  local stack = {}
  local function search(cur)
    if cur == nil then return end
    for _, symbol in ipairs(cur) do
      -- pylsp still uses deprecated SymbolInformation https://github.com/python-lsp/python-lsp-server/issues/110
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol
      if in_range(position, symbol.range or symbol.location.range) then
        if breadcrumb_kind[symbol.kind] then
          stack[#stack+1] = symbol.name
        end
        return search(symbol.children)
      end
    end
  end
  search(symbols)
  return table.concat(stack, " > ")
end

local function update_breadcrumb()
  local win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  vim.lsp.buf_request_all(bufnr, 'textDocument/documentSymbol', params, function(results)
    if not vim.api.nvim_win_is_valid(win) then return end
    pcall(vim.api.nvim_win_del_var, win, 'breadcrumb')
    -- alternative: update breadcrumb in all windows with vim.fn.win_findbuf()
    if bufnr ~= vim.api.nvim_win_get_buf(win) then return end
    local offset_encoding, symbols
    for _client_id, _result in pairs(results) do
      if _result.error == nil then
        offset_encoding = vim.lsp.get_client_by_id(_client_id).offset_encoding
        symbols = _result.result
        break
      end
    end
    if symbols == nil then return end
    local position = position_api_to_lsp(bufnr, position_mark_to_api(vim.api.nvim_win_get_cursor(win)), offset_encoding)
    vim.api.nvim_win_set_var(win, 'breadcrumb', build_breadcrumb(symbols, position))
    vim.cmd.redrawstatus { bang = true }
  end)
end

---@type table<window, true>
local need_cleanup_breadcrumb = {}

local function register_breadcrumb(ag, client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      group = ag,
      buffer = bufnr,
      desc = "update breadcrumb",
      callback = update_breadcrumb,
    })
    -- Clean breadcrumb when another buffer is shown to the window: (b1, w) → (b2, w).
    -- This should be "window-local" autocmd, but vim doesn't have such thing.
    -- So this is implemented in 3 steps: BufLeave → WinLeave → BufEnter.
    vim.api.nvim_create_autocmd("BufLeave", {
      group = ag,
      buffer = bufnr,
      desc = "initiate breadcrumb cleanup",
      callback = function()
        need_cleanup_breadcrumb[vim.api.nvim_get_current_win()] = true
      end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
      group = ag,
      buffer = bufnr,
      desc = "cancel breadcrumb cleanup",
      callback = function()
        need_cleanup_breadcrumb[vim.api.nvim_get_current_win()] = nil
      end,
    })
  end
end

local function register_breadcrumb_global(ag)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = ag,
    desc = "execute breadcrumb cleanup",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if need_cleanup_breadcrumb[win] then
        pcall(vim.api.nvim_win_del_var, win, 'breadcrumb')
        need_cleanup_breadcrumb[win] = nil
      end
    end,
  })
end
-- }}}

-- progress {{{

local progress_message_clear_timer = assert(vim.loop.new_timer())

-- TODO: cleanup after 0.10 release
local get_status_message ---@type fun(): string|nil
if vim.fn.exists('##LspProgress') == 1 then
  get_status_message = function()
    local msg = vim.lsp.status()
    if #msg == 0 then return end
    return '[' .. msg .. ']'
  end
else
  get_status_message = function()
    local report = vim.lsp.util.get_progress_messages()[1]
    if not report then return end
    local msg = string.format('[%s] %s', report.name, report.title)
    local details = {}
    if report.message then
      details[#details+1] = report.message
    end
    if report.done then
      details[#details+1] = 'Done'
    end
    if #details > 0 then
      msg = msg .. ': ' .. table.concat(details, '. ')
    end
    return msg
  end
end

local function update_status_message()
  local msg = get_status_message()
  -- NOTE: this doesn't cancel already scheduled callback, but this isn't critical
  progress_message_clear_timer:stop()
  progress_message_clear_timer:start(
    2345,
    0,
    vim.schedule_wrap(function()
      vim.g.lsp_status = nil
      vim.cmd.redrawstatus { bang = true }
    end)
  )
  vim.g.lsp_status = msg
  vim.cmd.redrawstatus { bang = true }
end

local function register_progress_message(ag)
  if vim.fn.exists('##LspProgress') == 1 then
    vim.api.nvim_create_autocmd("LspProgress", {
      group = ag,
      callback = update_status_message
    })
  else
    vim.api.nvim_create_autocmd("User", {
      group = ag,
      pattern = 'LspProgressUpdate',
      callback = update_status_message
    })
  end
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = ag,
    callback = function() progress_message_clear_timer:close() end,
  })
end
-- }}}

vim.diagnostic.config {
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  serverity_sort = true,
}

require('mason').setup()
require('mason-lspconfig').setup() -- registers some hooks for lspconfig setup

local ag = vim.api.nvim_create_augroup("nvim-lsp-custom", { clear = true })

register_breadcrumb_global(ag)
register_progress_message(ag)
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = ag,
  command = 'redrawstatus!',
})
-- override lspconfig's LspLog
vim.api.nvim_create_autocmd("VimEnter", {
  group = ag,
  callback = function()
    vim.api.nvim_create_user_command('LspLog',
      function(opts)
        -- NOTE: nvim_cmd doesn't work well with complex +cmd
        -- vim.cmd.pedit {
        --   args = { [[+setlocal\ nobuflisted|$ ]] .. vim.lsp.get_log_path() },
        --   mods = opts.smods,
        -- }
        vim.cmd([[pedit +setlocal\ nobuflisted\ nowrap|$ ]] .. vim.lsp.get_log_path() )
      end,
      { force = true, }
    )
  end
})

-- Disable workspace/didChangeWatchedFiles. Uses too much cpu.
-- https://github.com/neovim/neovim/issues/23291
local capabilities = vim.tbl_deep_extend('force', require('cmp_nvim_lsp').default_capabilities(), {
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = false,
    },
  },
})

local base_config = {
  on_init = function(client, initialize_result)
    -- Disable semantic highlight for now.
    client.server_capabilities.semanticTokensProvider = nil
  end,
  on_attach = function(client, bufnr)
    vim.fn['SetupLSP']()
    vim.fn['SetupLSPPost']()
    register_breadcrumb(ag, client, bufnr)
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({'BufReadPost', 'BufWritePost', 'CursorHold'}, {
        group = ag, buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end,
  capabilities = capabilities,
}

local function config(more)
  if more == nil then return base_config end
  return vim.tbl_deep_extend('force', base_config, more)
end

-- server configs {{{

-- local path = require "mason-core.path"
-- local mason_path = path.concat { vim.fn.stdpath("data"), "mason" , "packages" }
-- local codelldb_path = path.concat { mason_path, "codelldb", "extension" }
-- dap = {
--   adapter = require('rust-tools.dap').get_codelldb_adapter(
--     path.concat { codelldb_path, "adapter", "codelldb" },
--     path.concat { codelldb_path, "lldb", "lib", "liblldb.so" }
--   )
-- }

-- NOTE: rust-analyzer behaves weirdly for multi-crate project. especially workspace_symbols.
local rust_tools = require('rust-tools')
rust_tools.setup {
  tools = {
    runnables = { use_telescope = false },
    debuggables = { use_telescope = false },
    inlay_hints = { auto = false },
  },
  -- lspconfig.rust_analyzer.setup
  server = config {
    settings = { ['rust-analyzer'] = {
      rustc = { source = 'discover' }
    }}
  },
}

lspconfig.pylsp.setup(config {
  settings = { pylsp = {
    plugins = {
      pylint = {
        enabled = true,
        args = {"-dR", "-dC", "-dW0511", "-dW0614", "-dW0621", "-dW0231", "-dF0401", "--generated-members=cv2.*,onnx.*,tf.*,np.*"}
      },
      ["flake8"] = { enabled = false },
      mccabe = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      rope_completion = { enabled = false },
      yapf = { enabled = false },
    }
  }}
})

lspconfig.clangd.setup(config())

require("neodev").setup()
lspconfig.lua_ls.setup(config {
  settings = { Lua = {
    workspace = {
      -- disable "Do you need to configure your work environment as" prompts
      checkThirdParty = false,
    },
  }},
})

lspconfig.vimls.setup(config())

lspconfig.texlab.setup(config())

-- NOTE: Codeaction-ed rules are recorded in .ltex_ls_cache.json.
-- See also https://github.com/barreiroleo/ltex_extra.nvim.
require'ltex-ls'.setup(config {
  autostart = false,
  -- Not quite useful, because it's not updated on zg.
  -- In the meantime, use the built-in spellchecker.
  -- use_spellfile = true, -- ltex-ls.nvim setting
  settings = { ltex = {
    checkFrequency = "save",
    -- dictionary = {
    --   ["en-US"] = { ":~/.vim/spell/en.utf-8.add" }
    -- },
    disabledRules = {
      ["en-US"] = { "MORFOLOGIK_RULE_EN_US" }
    },
    latex = {
      commands = {
        ["\\todo{}"] = "ignore",
        ["\\jaehwang{}"] = "ignore",
      },
      environments = {
        ["mathpar"] = "ignore",
        ["algorithmic"] = "ignore",
      },
    },
    additionalRules = {
      languageModel = '~/ngram/',
    },
    ['ltex-ls'] = {
      logLevel = "severe", -- NOTE: "INFO: ltex-ls 16.0.0 - initializing..." still logged
    },
  }}
}
)

lspconfig.bashls.setup(config())

lspconfig.marksman.setup(config {
  autostart = false,
})

require'coq-lsp'.setup {
  lsp = config {
    autostart = false,
    init_options = {
      max_errors = 50,
      show_notices_as_diagnostics = true,
      debug = true,
    },
    -- trace = 'verbose',
  },
}
-- }}}

return M

-- vim:set et sw=2 ts=8 foldmethod=marker foldlevel=0:
