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

local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp_status.capabilities)

local base_opt = {
  on_attach = function(client, bufnr)
    vim.fn['SetupLSP']()
    vim.fn['SetupLSPPost']()
    lsp_status.on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  flags = { debounce_text_changes = 123 }
}

require('rust-tools').setup {
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
  server = base_opt
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

lspconfig.sumneko_lua.setup (
  require'lua-dev'.setup { lspconfig = base_opt }
)

lspconfig.vimls.setup(base_opt)

lspconfig.texlab.setup(base_opt)

-- run with LspStart ltex
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

-- vim:set et sw=2 ts=8:
