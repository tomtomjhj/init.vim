local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

-- nil, false and **0** are falsy
function TT(x) return x and x ~= 0 end

lsp_status.register_progress()
require('lspfuzzy').setup{}

local HOME = vim.fn.expand("~")
local lspinstall_dir = vim.fn.stdpath('cache')..'/lspconfig/'

lspconfig.rust_analyzer.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
}

-- lspconfig.pyright.setup{}
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
  cmd = {HOME.."/.config/coc/extensions/coc-clangd-data/install/12.0.0/clangd_12.0.0/bin/clangd", "--background-index" };
  filetypes = { "c", "cpp", "cuda" };
}

local system_name = TT(vim.fn.has('unix')) and 'Linux' or TT(vim.fn.has('win32')) and 'Windows' or 'macOS'
local sumneko_root_path = lspinstall_dir..'sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/'..system_name..'/lua-language-server'

require'lspconfig'.sumneko_lua.setup (
  require'lua-dev'.setup {
    lspconfig = {
      on_attach = lsp_status.on_attach,
      capabilities = lsp_status.capabilities,
      cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}
    }
  }
)

lspconfig.vimls.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
}
