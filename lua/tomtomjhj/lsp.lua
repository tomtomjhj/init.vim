local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
-- TODO: Lazy load this entire file on the first FileType that uses lsp?
-- Note that the server is launched in FileType.
-- https://github.com/neovim/nvim-lspconfig/issues/970
-- https://github.com/williamboman/nvim-lsp-installer/issues/244
-- https://github.com/gpanders/dotfiles/commit/01464e949574dcb9752e8dc92f39a7cee91446b7

require('nvim-lsp-installer').setup{} -- registers some hooks for lspconfig setup
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
lspconfig.ltex.setup(
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
    }}
  })
)

lspconfig.bashls.setup(base_opt)

-- vim:set et sw=2 ts=8:
