local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')

-- nil, false and **0** are falsy
function TT(x) return x and x ~= 0 end

lsp_status.register_progress()
require('lspfuzzy').setup{}

local lspinstall_dir = vim.fn.stdpath('cache')..'/lspconfig/'

lspconfig.rust_analyzer.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
}

local system_name = TT(vim.fn.has('unix')) and 'Linux' or TT(vim.fn.has('win32')) and 'Windows' or 'macOS'
local sumneko_root_path = lspinstall_dir..'sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/'..system_name..'/lua-language-server'

require'lspconfig'.sumneko_lua.setup (
  require'lua-dev'.setup {
    lspconfig = {
      cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"}
    }
  }
)

require'lspconfig'.vimls.setup{}

local messages = require('lsp-status/messaging').messages

-- extracted from lsp-status/statusline.lua
local function status()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local buf_messages = messages()
  local status_parts = {}
  local msgs = {}

  for _, msg in ipairs(buf_messages) do
    local name = msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end

  local base_status = vim.trim(table.concat(status_parts, ' ') .. ' ' .. table.concat(msgs, ' '))

  if base_status ~= '' then
    return base_status
  end

  return ''
end

local M = {
  status = status
}

return M
