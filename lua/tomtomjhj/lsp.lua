local lspconfig = require('lspconfig')

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
end
-- }}}

-- progress {{{

local progress_message_clear_timer = assert(vim.loop.new_timer())

local function update_progress_message()
  local msg = vim.lsp.util.get_progress_messages()[1]
  if not msg then return '' end
  local title = string.format('[%s] %s', msg.name, msg.title)
  local details = {}
  if msg.message then
    details[#details+1] = msg.message
  end
  if msg.done then
    details[#details+1] = 'Done'
    -- NOTE: this doesn't cancel already scheduled callback, but this isn't critical
    progress_message_clear_timer:stop()
    progress_message_clear_timer:start(
      2345,
      0,
      vim.schedule_wrap(function()
        vim.g.lsp_progress = nil
        vim.cmd.redrawstatus { bang = true }
      end)
    )
  end
  if #details == 0 then
    vim.g.lsp_progress = title
  else
    vim.g.lsp_progress = title .. ': ' .. table.concat(details, '. ')
  end
  vim.cmd.redrawstatus { bang = true }
end

local function register_progress_message(ag)
  vim.api.nvim_create_autocmd("User", {
    group = ag,
    pattern = 'LspProgressUpdate',
    callback = update_progress_message
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = ag,
    callback = function() progress_message_clear_timer:close() end,
  })
end
-- }}}

require('mason').setup()
require('mason-lspconfig').setup() -- registers some hooks for lspconfig setup

local aerial = require('aerial')
-- NOTE: aerial overrides documentSymbol handler
aerial.setup {
  backends = {
    tex = {},
  },
  link_tree_to_folds = false,
  on_attach = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft ~= 'tex' and ft ~= 'markdown' then
      vim.keymap.set('n', '[[', function()
        vim.cmd [[normal! m']]
        aerial.prev(vim.v.count1)
      end, { buffer = bufnr })
      vim.keymap.set('n', ']]', function()
        vim.cmd [[normal! m']]
        aerial.next(vim.v.count1)
      end, { buffer = bufnr })
    end
    vim.keymap.set('n', '<leader>ol', '<Cmd>AerialToggle! right<CR>')
  end
}
-- TODO: markdown: support setext heading

vim.diagnostic.config {
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  serverity_sort = true,
}

local ag = vim.api.nvim_create_augroup("nvim-lsp-custom", { clear = true })

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
        vim.cmd([[pedit +setlocal\ nobuflisted|$ ]] .. vim.lsp.get_log_path() )
      end,
      { force = true, }
    )
  end
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local base_opt = {
  on_attach = function(client, bufnr)
    vim.fn['SetupLSP']()
    vim.fn['SetupLSPPost']()
    register_breadcrumb(ag, client, bufnr)
    -- Disable semantic highlight for now.
    client.server_capabilities.semanticTokensProvider = nil
  end,
  capabilities = capabilities,
}

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

local rust_tools = require('rust-tools')
rust_tools.setup {
  tools = {
    runnables = { use_telescope = false },
    debuggables = { use_telescope = false },
    inlay_hints = {
      parameter_hints_prefix = "← ",
      other_hints_prefix = "⇒ ",
      highlight = "LspCodeLens",
    },
  },
  -- lspconfig.rust_analyzer.setup
  server = vim.tbl_extend('force', base_opt, {
    on_attach = function(client, bufnr)
      base_opt.on_attach(client, bufnr)
      vim.keymap.set("n", "<M-.>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<leader>ac", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
    end,
  }),
}

lspconfig.pylsp.setup(
  vim.tbl_extend('error', base_opt, {
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
)

require("clangd_extensions").setup {
  server = base_opt,
  extensions = {},
}

require("neodev").setup()
lspconfig.lua_ls.setup(base_opt)

lspconfig.vimls.setup(base_opt)

lspconfig.texlab.setup(base_opt)

-- NOTE: Codeaction-ed rules are recorded in .ltex_ls_cache.json.
-- See also https://github.com/barreiroleo/ltex_extra.nvim.
require'ltex-ls'.setup(
  vim.tbl_extend('error', base_opt, {
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
)

lspconfig.bashls.setup(base_opt)

lspconfig.marksman.setup(
  vim.tbl_extend('error', base_opt, {
    autostart = false,
  })
)

require'coq-lsp'.setup {
  lsp = vim.tbl_extend('error', base_opt, {
    autostart = false,
    init_options = {
      max_errors = 50,
      show_notices_as_diagnostics = true,
      debug = true,
    },
    -- trace = 'verbose',
  }),
}
-- }}}

-- vim:set et sw=2 ts=8 foldmethod=marker foldlevel=0:
