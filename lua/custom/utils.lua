local M = {}

M.isApiDir = function()
  print(vim.fn.getcwd());
  return vim.fn.getcwd() == "/Users/sathish/exemplary/api"
end

return M
