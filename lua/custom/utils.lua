local M = {}

M.isApiDir = function()
  return vim.fn.getcwd() == "/Users/sathish/exemplary/api"
end

return M
