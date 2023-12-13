local M = {}

M.setup = function()
  vim.cmd [[
augroup filetype_settings
    autocmd!
    autocmd BufNewFile,BufRead *.sh set filetype=sh
augroup END
]]
end

return M
