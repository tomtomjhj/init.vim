-- Based on https://github.com/quangnguyen30192/cmp-nvim-tags
local cmp = require('cmp')

local source = {}

local basic_entries = { name = true, filename = true, cmd = true, kind = true, static = true, }

local function buildDocumentation(word)
  local document = {}

  -- Even if tagfunc is set, getcompletion(.., 'tag') does NOT use tagfunc and
  -- gets tags from the tags file. But taglist() uses the tagfunc.
  -- When vim.lsp.tagfunc() is used, it will call `workspace/symbol` method,
  -- which may generate noisy errors if it's not supported by the server.
  -- So unset tagfunc temporarily.
  -- Another option: require empty tagfunc in is_available().
  local tagfunc = nil
  if vim.bo.tagfunc ~= "" then
    vim.bo.tagfunc = ""
    tagfunc = vim.bo.tagfunc
  end
  -- The pattern should be exactly '^word$' to enable exact binary search. NO '\C'.
  local tags = vim.fn.taglist('^' .. word .. '$', vim.api.nvim_buf_get_name(0))
  if tagfunc then vim.bo.tagfunc = tagfunc end

  for _, tag in ipairs(tags) do
    local doc =  '[' .. tag.kind .. '] ' .. tag.filename .. (tag.static == 1 and ' (static)' or '')
    if #tag.cmd >= 5 then
      doc = doc .. '\n  ' .. tag.cmd:sub(3, -3)
    end
    local etc = {}
    for k, v in pairs(tag) do
      if not basic_entries[k] then
        etc[#etc+1] = k .. ': ' .. v
      end
    end
    if #etc > 0 then
      doc = doc .. '\n  (' .. table.concat(etc, ', ') .. ')'
    end
    table.insert(document, doc)
  end

  return table.concat(document, '\n')
end

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_keyword_pattern = function()
  return [[\K\k*]]
end

function source:get_debug_name()
  return 'tags'
end

function source:complete(request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset)
  if #input < 2 then
    -- without this, cmp doesn't trigger completion in this session(?)
    return callback({ items = {}, isIncomplete = true })
  end

  -- Catch E433. Note that #tagfiles() > 0 can't detect it (e.g. in fugitive:// buffer).
  local ok, tags = pcall(vim.fn.getcompletion, input, "tag")
  if not ok then
    -- no need to trigger in this session since it will fail anyway
    return
  end

  local items = {}
  for _, tag in pairs(tags) do
    items[#items+1] = { word = tag, label = tag, kind = cmp.lsp.CompletionItemKind.Tag, }
  end

  -- isIncomplete is not necessary if #tags < TAG_MANY,
  -- but that makes it difficult to recover from typo (<BS> doesn't trigger completion).
  callback({ items = items, isIncomplete = true })
end

function source:resolve(completion_item, callback)
  completion_item.documentation = {
    kind = cmp.lsp.MarkupKind.PlainText,
    value = buildDocumentation(completion_item.word)
  }

  callback(completion_item)
end

function source:is_available()
  return true
end

return source
