local M = {}

--- function for textobj-user
function M.fenced_codeblock(outer)
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return 0 end
  if node:type() == 'block_continuation' then
    node = assert(node:parent())
  end
  if node:type() == 'fenced_code_block' then
    -- * text
    --   ```
    --   handles the case where the cursor is at the left of this line
    --   ```
    for child, _ in node:iter_children() do
      if child:type() == 'code_fence_content' then
        node = child
        break
      end
    end
  end
  if node:type() ~= 'code_fence_content' then return 0 end
  local srow, _, erow, _ = node:range()
  return {'V', {0, srow + 1 - (outer and 1 or 0), 1, 0}, {0, erow + 1 - (outer and 0 or 1), 1, 0}}
end

---@return {text: string, line: integer}[]
function M.headings(bufnr)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
    vim.bo[bufnr].buflisted = true
  end
  local parser = vim.treesitter.get_parser(bufnr, 'markdown')
  if not parser then return {} end
  -- NOTE: Using aeiral's query for convenience, but this can be done with highlights query as well
  local query = require("aerial.backends.treesitter.helpers").get_query('markdown')
  if not query then return {} end
  local tree = parser:parse()[1]
  if not tree then return {} end

  local headings = {}

  for _, match, _ in
    query:iter_matches(tree:root(), bufnr, nil, nil, { all = true })
  do
    for id, nodes in pairs(match) do
      local name = query.captures[id]
      if name == 'name' then
        local node = nodes[1]
        local row, _ = node:start()
        local text = vim.treesitter.get_node_text(node, bufnr)
        table.insert(headings, { text = text, line = row + 1 })
      end
    end
  end

  return headings
end

return M
