local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local lsp_installer_servers = require'nvim-lsp-installer.servers'
-- TODO: Lazy load this entire file on the first FileType that uses lsp?
-- Note that the server is launched in FileType.
-- https://github.com/neovim/nvim-lspconfig/issues/970
-- https://github.com/williamboman/nvim-lsp-installer/issues/244
-- https://github.com/neovim/neovim/issues/12688#issuecomment-665115778

lsp_status.register_progress()
require('lspfuzzy').setup{}

local function base_opt(server_name)
  local _, server = lsp_installer_servers.get_server(server_name)
  return {
    on_attach = function(client, bufnr)
      vim.fn['SetupLSP']()
      vim.fn['SetupLSPPost']()
      lsp_status.on_attach(client, bufnr)
    end,
    capabilities = lsp_status.capabilities,
    cmd = server:get_default_options().cmd,
    flags = { debounce_text_changes = 123 }
  }
end

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
  server = base_opt('rust_analyzer')
}

lspconfig.pylsp.setup(
  vim.tbl_extend('error', base_opt('pylsp'), {
    settings = { pylsp = {
      plugins = {
        pylint = {
          enabled = true,
          args = {"-dR", "-dC", "-dW0511", "-dW0614", "-dW0621", "-dW0231", "-dF0401", "--generated-members=cv2.*,onnx.*,tf.*,np.*"}
        }
      }
    }}
  })
)

lspconfig.clangd.setup(
  vim.tbl_extend('error', base_opt('clangd'), {
    filetypes = { "c", "cpp", "cuda" },
  })
)

lspconfig.sumneko_lua.setup (
  require'lua-dev'.setup { lspconfig = base_opt('sumneko_lua') }
)

lspconfig.vimls.setup(base_opt('vimls'))

lspconfig.texlab.setup(base_opt('texlab'))

-- run with LspStart ltex
lspconfig.ltex.setup(
  vim.tbl_extend('error', base_opt('ltex'), {
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

lspconfig.bashls.setup(base_opt('bashls'))

-- vim:set et sw=2 ts=8:
