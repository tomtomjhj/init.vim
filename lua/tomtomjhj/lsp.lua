-- vim.lsp.set_log_level('TRACE')

-- NOTE: lspconfig can be lazy-loaded in BufEnter,BufNewFile (LazyVim does this)

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
  return { line = row, character = vim.str_utfindex(line, offset_encoding, col, false) }
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
  local new = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(new)
  vim.api.nvim_echo({{'Diagnostics: ' .. tostring(new)}}, false, {})
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
  local result = table.concat(stack, " > ")
  -- texlab: \n in caption source preserved in symbol name. This seems to break statusline.
  local nl = result:find('\n')
  if nl then
    result = result:sub(1, nl - 1) .. ' ...'
  end
  return result
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
      if _result.err == nil then
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

local breadcrumb_autocmds = vim.api.nvim_create_augroup("tomtomjhj/lsp-breadcrumb", { clear = true })

local function register_breadcrumb(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      group = breadcrumb_autocmds,
      buffer = bufnr,
      desc = "update breadcrumb",
      callback = update_breadcrumb,
    })
    -- Clean breadcrumb when another buffer is shown to the window: (b1, w) → (b2, w).
    -- This should be "window-local" autocmd, but vim doesn't have such thing.
    -- So this is implemented in 3 steps: BufLeave → WinLeave → BufEnter.
    vim.api.nvim_create_autocmd("BufLeave", {
      group = breadcrumb_autocmds,
      buffer = bufnr,
      desc = "initiate breadcrumb cleanup",
      callback = function()
        need_cleanup_breadcrumb[vim.api.nvim_get_current_win()] = true
      end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
      group = breadcrumb_autocmds,
      buffer = bufnr,
      desc = "cancel breadcrumb cleanup",
      callback = function()
        need_cleanup_breadcrumb[vim.api.nvim_get_current_win()] = nil
      end,
    })
  end
end

local function register_breadcrumb_global()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = breadcrumb_autocmds,
    desc = "execute breadcrumb cleanup",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if need_cleanup_breadcrumb[win] then
        pcall(vim.api.nvim_win_del_var, win, 'breadcrumb')
        need_cleanup_breadcrumb[win] = nil
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = breadcrumb_autocmds,
    callback = function(ev)
      vim.api.nvim_clear_autocmds { group = breadcrumb_autocmds, buffer = ev.buf }
      for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
        pcall(vim.api.nvim_win_del_var, win, 'breadcrumb')
      end
    end
  })
end
-- }}}

-- progress {{{

local progress_autocmds = vim.api.nvim_create_augroup("tomtomjhj/lsp-progress", { clear = true })
local progress_message_throttle_timer = assert(vim.loop.new_timer())
local progress_message_clear_timer = assert(vim.loop.new_timer())

local function get_status_message()
  local msg = vim.lsp.status()
  if #msg == 0 then return end
  return '[' .. msg .. ']'
end

local function update_status_message()
  local msg = get_status_message()
  if progress_message_throttle_timer:is_active() then return end
  progress_message_throttle_timer:start(123, 0, function() end)
  vim.g.lsp_status = msg
  vim.cmd.redrawstatus { bang = true }
  -- NOTE: this doesn't cancel already scheduled callback, but this isn't critical
  progress_message_clear_timer:stop()
  progress_message_clear_timer:start(1234, 0, vim.schedule_wrap(function()
    vim.g.lsp_status = nil
    vim.cmd.redrawstatus { bang = true }
  end))
end

local function register_progress_message()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = progress_autocmds,
    callback = update_status_message
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = progress_autocmds,
    callback = function()
      progress_message_throttle_timer:close()
      progress_message_clear_timer:close()
    end,
  })
end
-- }}}

-- diagnostics {{{
vim.diagnostic.config {
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  serverity_sort = true,
}

local diagnostic_autocmds = vim.api.nvim_create_augroup("tomtomjhj/diagnostics", { clear = true })

-- texlab triggers DiagnosticChanged too frequently, which makes the cursor flicker
local diagnostic_debounce_timer = assert(vim.loop.new_timer())
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = diagnostic_autocmds,
  callback = function()
    diagnostic_debounce_timer:stop()
    diagnostic_debounce_timer:start(210, 0, vim.schedule_wrap(function()
      vim.cmd.redrawstatus { bang = true }
    end))
  end
})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = diagnostic_autocmds,
  callback = function() diagnostic_debounce_timer:close() end,
})
-- }}}

require('mason').setup()
require('mason-lspconfig').setup() -- registers some hooks for lspconfig setup

register_breadcrumb_global()
register_progress_message()

-- override lspconfig's LspLog
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
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

-- Disable workspace/didChangeWatchedFiles if a slow backend is used.
-- https://github.com/neovim/neovim/issues/23291
local capabilities = vim.tbl_deep_extend('force', require('cmp_nvim_lsp').default_capabilities(), {
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = vim.fn.has('win32') == 1 or vim.fn.has('mac') == 1 or vim.fn.executable('inotifywait') == 1,
    },
  },
})

local codelens_autocmds = vim.api.nvim_create_augroup("tomtomjhj/lsp-codelens", { clear = true })

-- "cmd" is required in vim.lsp.ClientConfig. Make it optional
---@class PartialClientConfig: vim.lsp.ClientConfig
---@field cmd? string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient

---@type PartialClientConfig
local base_config = {
  on_attach = function(client, bufnr)
    vim.fn['SetupLSP']()
    vim.fn['SetupLSPPost']()
    register_breadcrumb(client, bufnr)
    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh { bufnr = 0 }
      vim.api.nvim_create_autocmd({'BufReadPost', 'BufWritePost', 'CursorHold'}, {
        group = codelens_autocmds, buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = 0 }
        end,
        desc = 'refresh codelens',
      })
    end
  end,
  capabilities = capabilities,
}

---@param more? PartialClientConfig
---@return PartialClientConfig
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

-- NOTE: lspconfig blocks when downing rust toolchain and it can't be interrrupted just like any other blocking lua code
-- NOTE: rust-analyzer behaves weirdly for multi-crate project. especially workspace_symbols.
-- NOTE: see https://github.com/LazyVim/LazyVim/pull/2198 for more config
vim.g.rustaceanvim = {
  server = config {
    on_attach = function(client, bufnr)
      base_config.on_attach(client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'LspRestart', 'RustAnalyzer restart', {})
    end,
    settings = { ['rust-analyzer'] = {
      rustc = { source = 'discover' }
    }},
  },
}

-- lspconfig.pylsp.setup(config {
--   settings = { pylsp = {
--     plugins = {
--       pylint = {
--         enabled = true,
--         args = {"-dR", "-dC", "-dW0401", "-dW0511", "-dW0614", "-dW0621", "-dW0231", "-dF0401", "--generated-members=cv2.*,onnx.*,tf.*,np.*"}
--       },
--       ["flake8"] = { enabled = false },
--       mccabe = { enabled = false },
--       pycodestyle = { enabled = false },
--       pyflakes = { enabled = false },
--       rope_completion = { enabled = false },
--       yapf = { enabled = false },
--     }
--   }}
-- })

-- TODO: reference() seems to exclude the reference at the cursor... confusing
-- https://github.com/DetachHead/basedpyright/blob/aba927d9e09203ad37cb92054416e28e8dbd5a66/packages/pyright-internal/src/languageService/referencesProvider.ts#L152
-- https://github.com/microsoft/pyright/blob/db368a1ace131372cb78d9c866ca3f5867495052/packages/pyright-internal/src/languageService/referencesProvider.ts#L152
lspconfig.basedpyright.setup(config {
  settings = { basedpyright = {
    analysis = {
      typeCheckingMode = "basic",
    }
  }},
})
lspconfig.ruff.setup(config {
  autostart = false,
})

lspconfig.clangd.setup(config {
  --- https://github.com/clangd/clangd/issues/1394#issuecomment-1328676884
  cmd = { 'clangd', '--query-driver=/usr/bin/c++', '--log=error', }
  -- clangd doesn't support configuration via LSP
})

-- https://github.com/folke/lazydev.nvim/ is probably overkill for my usage
lspconfig.lua_ls.setup(config {
  on_init = function(client)
    -- Worse than treesitter. Doesn't highlight method definition as definition.
    client.server_capabilities.semanticTokensProvider = nil

    if client.workspace_folders and client.workspace_folders[1] then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua --[[@as table<string, lsp.LSPAny>]], {
      runtime = { version = 'LuaJIT' },
      workspace = { library = {
        vim.env.VIMRUNTIME,
        "${3rd}/luv/library",
        -- "${3rd}/busted/library",
      }},
    })
  end,
  settings = { Lua = {
    workspace = {
      -- disable "Do you need to configure your work environment as" prompts
      checkThirdParty = false,
    },
    codeLens = { enable = true, },
  }},
})

-- lspconfig.vimls.setup(config())

lspconfig.texlab.setup(config {
  settings = { texlab = {
    experimental = {
      labelDefinitionCommands = { 'axiomH', 'inferH', },
      labelReferenceCommands = { 'ruleref', },
    },
  }},
})

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
      ["en-US"] = { "MORFOLOGIK_RULE_EN_US", "ARROWS", }
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
})

lspconfig.bashls.setup(config())

lspconfig.markdown_oxide.setup(config {
  autostart = false,
})

-- Old ocamllsp spams "failed to poll dune registry" warning in lsp.log.
-- Lastest ocamllsp requires ocaml>=4.14.
-- This dune thing should be MANUALLY run with `dune build -w`.
lspconfig.ocamllsp.setup(config())

-- require'coq-lsp'.setup {
--   lsp = config {
--     autostart = false,
--     init_options = {
--       max_errors = 50,
--       show_notices_as_diagnostics = true,
--       debug = true,
--     },
--     -- trace = 'verbose',
--   },
-- }

require'vscoq'.setup {
  vscoq = {
    proof = {
      mode = 'Manual',
      cursor = { sticky = false },
    },
  },
  lsp = config {
    -- cmd = { 'vscoqtop', '-bt', '-vscoq-d', 'all' },
    -- trace = 'verbose',
    autostart = false,
    on_attach = function(client, bufnr)
      base_config.on_attach(client, bufnr)
      vim.keymap.set({'n', 'i'}, '<C-M-j>', '<Cmd>VsCoq stepForward<CR>', { buffer = bufnr })
      vim.keymap.set({'n', 'i'}, '<C-M-k>', '<Cmd>VsCoq stepBackward<CR>', { buffer = bufnr })
      vim.keymap.set({'n', 'i'}, '<C-M-l>', '<Cmd>VsCoq interpretToPoint<CR>', { buffer = bufnr })
    end
  },
}
-- }}}

return M

-- vim:set et sw=2 ts=8 foldmethod=marker foldlevel=0:
