local aerial = require('aerial')

local function on_attach(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft ~= 'tex' then
    vim.keymap.set('n', '[[', aerial.prev, { buffer = bufnr })
    vim.keymap.set('n', ']]', aerial.next, { buffer = bufnr })
  end
  vim.keymap.set('n', '<leader>fl', '<Cmd>call aerial#fzf()<CR>', { buffer = bufnr })
  if ft ~= 'help' then
    vim.keymap.set('n', 'gO', '<Cmd>AerialToggle! right<CR>', { buffer = bufnr })
  end
end

aerial.setup {
  backends = {
    tex = {},
    c = {'lsp', 'treesitter'}, -- trailing macro stuff in function def confuses treesitter
    cpp = {'lsp', 'treesitter'},
  },
  link_tree_to_folds = false,
  post_jump_cmd = 'normal! zv',
  on_attach = on_attach,
}

-- Aerial stores the selected symbol backend in b:aerial_backend.
-- The variable can outlive a FileType change, so check it against the
-- backend list for the current filetype before reusing it.
local function backend_status(bufnr)
  local has_supported = false
  local attached = vim.b[bufnr].aerial_backend
  local attached_supported = not attached
  for _, status in ipairs(require('aerial.backends').get_status(bufnr)) do
    if status.supported then
      has_supported = true
    end
    if status.name == attached then
      attached_supported = status.supported
    end
  end
  return has_supported, attached, attached_supported
end

-- Aerial has no public "detach this buffer" API.
-- This mirrors the parts needed after a FileType change makes the old backend invalid.
local function detach_backend(bufnr, name)
  local backend = require('aerial.backends').get_backend_by_name(name)
  if backend then
    backend.detach(bufnr)
  end
  vim.api.nvim_buf_del_var(bufnr, 'aerial_backend')
  require('aerial.data').delete_buf(bufnr)
end

-- https://github.com/stevearc/aerial.nvim/issues/449
-- Aerial's on_attach is a first-backend-attach hook, not a FileType hook.
-- (btw aerial on_enter_buffer is throttled and vim.schedule()ed.)
-- Make it work like a usual FileType hook.
local ag = vim.api.nvim_create_augroup("aerial-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = ag,
  callback = function(ev)
    -- Aerial may not have completed its deferred setup during early FileType.
    aerial.sync_load()

    local has_supported, backend, backend_supported = backend_status(ev.buf)

    if backend and not backend_supported then
      -- Manual :setf to an unsupported filetype is usually one-shot.
      -- Clear enough state to avoid reusing a stale backend.
      detach_backend(ev.buf, backend)
      backend = nil
    end
    if not has_supported then
      return
    end

    if backend == "treesitter" then
      -- https://github.com/neovim/neovim/issues/33151
      vim.treesitter.get_parser():invalidate(true)
    end

    -- After :setf, refetch_symbols can attach a newly supported buffer.
    aerial.refetch_symbols(ev.buf)

    if vim.b[ev.buf].aerial_backend then
      -- :e reruns ftplugins and can overwrite my buffer-local mappings.
      on_attach(ev.buf)
      -- * treesitter fetch_symbols is synchronous but non-scheduled update_position didn't work
      -- * still not 100% reliable because lsp fetch_symbols is async
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          require('aerial.window').update_all_positions(ev.buf, 0)
        end
      end)
    end
  end,
})
