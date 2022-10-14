-- Based on https://github.com/quangnguyen30192/cmp-nvim-tags
local cmp = require('cmp')

local source = {}

local basic_entries = { name = true, filename = true, cmd = true, kind = true, static = true, }

local function buildDocumentation(word)
  local document = {}

  local tags = vim.fn.taglist('\\C^' .. word .. '$')
  local doc = ''
  for _, tag in ipairs(tags) do
    doc =  '[' .. tag.kind .. '] ' .. tag.filename .. (tag.static == 1 and ' (static)' or '')
    if #tag.cmd >= 5 then
      -- TODO: show the context?
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
  return [[\k\+]]
end

function source:get_debug_name()
  return 'tags'
end

function source:complete(request, callback)
  local items = {}
  vim.defer_fn(function()
    local input = string.sub(request.context.cursor_before_line, request.offset)
    local _, tags = pcall(function()
      return vim.fn.getcompletion(input, "tag")
    end)

    if type(tags) ~= 'table' then
      return {}
    end
    tags = tags or {}
    for _, value in pairs(tags) do
      local item = {
        word =  value,
        label =  value,
        kind = cmp.lsp.CompletionItemKind.Tag,
      }
      items[#items+1] = item
    end

    callback({
      items = items,
      isIncomplete = true
    })
  end, 100)
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
