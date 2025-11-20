local conform = require('conform')
local uv = vim.uv

---@return string?
local function read_file(path)
  local fd = uv.fs_open(path, 'r', 448) -- 0700
  if not fd then
    return nil
  end
  local stat = assert(uv.fs_fstat(fd))
  local content = assert(uv.fs_read(fd, stat.size))
  uv.fs_close(fd)
  return content
end

conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = function(bufnr)
      local root = vim.fs.root(bufnr, {
        '.pre-commit-config.yaml',
        'pyproject.toml',
        'setup.py',
        '.editorconfig',
      })
      local pre_commit = root and read_file(vim.fs.joinpath(root, '.pre-commit-config.yaml'))
      if not pre_commit then
        return { 'ruff_format' }
      end
      if pre_commit:find('id:%s*ruff%-format') then
        return { 'ruff_format' }
      end
      local fmt = {}
      if pre_commit:find('id:%s*isort') then
        table.insert(fmt, 'isort')
      end
      if pre_commit:find('id:%s*black') then
        table.insert(fmt, 'black')
      end
      if pre_commit:find('id:%s*yapf') then
        table.insert(fmt, 'yapf')
      end
      return #fmt > 0 and fmt or { 'ruff_format' }
    end,
    tablegen = { 'clang-format' },
  },

  default_format_opts = {
    timeout_ms = 2000,
    lsp_format = 'fallback',
  },
}

vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  conform.format { range = range }
end, { range = true })
