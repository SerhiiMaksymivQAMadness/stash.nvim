local Stack = require('stash.stack')

local stack

local M = {}

function M.setup(user_config)
  user_config = user_config or {}

  stack = Stack.Stack()

  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      if stack:size() < 50 then
        if buf_name ~= '' and not string.find(buf_name, "NvimTree") then
          stack:remove(buf_name)
          stack:push(buf_name)
        end
      else
        print('Stack size reached its limit: ' .. stack:size())
      end
    end,
  })
end

function M.back()
  stack:pop()
  local top = stack:peak()
  if top then
    vim.cmd.edit(top)
  else
    vim.cmd.edit(vim.api.nvim_buf_get_name(0))
  end
end

return M

