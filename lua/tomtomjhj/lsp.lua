local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

-- NOTE: don't use lspinstall's configuration... so confusing
-- lspinstall.setup()
lsp_status.register_progress()
require('lspfuzzy').setup{}

local lspinstall_dir = vim.fn.stdpath('data')..'/lspinstall/'

require('rust-tools').setup {
  tools = {
    runnables = { use_telescope = false },
    debuggables = { use_telescope = false },
    inlay_hints = {
      parameter_hints_prefix = "← ",
      other_hints_prefix = "⇒ ",
      highlight = "TypeHint",
    },
  },
  -- lspconfig.rust_analyzer.setup
  server = {
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities,
    cmd = { lspinstall_dir..'rust/rust-analyzer' },
  }
}

lspconfig.pylsp.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
  settings = {
    pylsp = {
      plugins = {
        pylint = {
          enabled = true,
          args = {"-dR", "-dC", "-dW0511", "-dW0614", "-dW0621", "-dW0231", "-dF0401", "--generated-members=cv2.*,onnx.*,tf.*,np.*"}
        }
      }
    }
  }
}

lspconfig.clangd.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
  cmd = { lspinstall_dir.."cpp/clangd/bin/clangd", "--background-index" };
  filetypes = { "c", "cpp", "cuda" };
  flags = { debounce_text_changes = 123 };
}

lspconfig.sumneko_lua.setup (
  require'lua-dev'.setup {
    lspconfig = {
      on_attach = lsp_status.on_attach,
      capabilities = lsp_status.capabilities,
      cmd = { lspinstall_dir..'lua/sumneko-lua-language-server' }
    }
  }
)

lspconfig.vimls.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
  cmd = { lspinstall_dir..'vim/node_modules/.bin/vim-language-server', '--stdio' }
}

-- vim:set et sw=2 ts=8:
