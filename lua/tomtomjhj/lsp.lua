local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

require('mason').setup()
require('mason-lspconfig').setup() -- registers some hooks for lspconfig setup
lsp_status.register_progress()
require('lspfuzzy').setup{}

vim.diagnostic.config {
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  signs = { severity = { min = vim.diagnostic.severity.WARN } },
  serverity_sort = true,
}

local ag = vim.api.nvim_create_augroup("nvim-lsp-custom", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = ag,
  pattern = '*',
  command = 'redrawstatus',
})
-- override lspconfig's LspLog
vim.api.nvim_create_autocmd("VimEnter", {
  group = ag,
  pattern = '*',
  callback = function()
    vim.api.nvim_create_user_command('LspLog',
      function(opts)
        vim.cmd.pedit {
          args = { '+setlocal nobuflisted|$', vim.lsp.get_log_path() },
          mods = opts.smods,
        }
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
    -- Disable semantic highlight for now.
    client.server_capabilities.semanticTokensProvider = nil
    lsp_status.on_attach(client, bufnr)
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

lspconfig.clangd.setup(
  vim.tbl_extend('error', base_opt, {
    filetypes = { "c", "cpp", "cuda" },
  })
)

require("neodev").setup()
lspconfig.lua_ls.setup(base_opt)

lspconfig.vimls.setup(base_opt)

lspconfig.texlab.setup(base_opt)

-- run with LspStart ltex
-- TODO: https://github.com/barreiroleo/ltex_extra.nvim
require'ltex-ls'.setup(
  vim.tbl_extend('error', base_opt, {
    autostart = false,
    settings = { ltex = {
      checkFrequency = "save",
      -- dictionary = {
      --   ["en-US"] = { ":~/.vim/spell/en.utf-8.add" }
      -- },
      -- TODO: Make dictionary work as intended. In the meantime, use the built-in spellchecker.
      disabledRules = {
        ["en-US"] = { "MORFOLOGIK_RULE_EN_US" }
      },
      latex = {
        commands = {
          ["\\todo{}"] = "ignore",
          ["\\jaehwang{}"] = "ignore",
        }
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
