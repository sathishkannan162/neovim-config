-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_command [[
  autocmd FileType typescriptreact setlocal commentstring={/*\ %s\ */}
]]
vim.api.nvim_command [[
  autocmd FileType javascriptreact setlocal commentstring={/*\ %s\ */}
]]

-- vim.o.foldmethod=nvim_treesitter#foldexpr();

-- astro typescript enabled
vim.g.astro_typescript = "enable"
vim.g.astro_stylus = "enable"

-- vim visual multi

-- vim.keymap.set("n", "<leader>mj", "<Plug>(VM-Add-Cursor-Up)")
-- vim.keymap.set("n", "<leader>mk", "<Plug>(VM-Add-Cursor-Down)")
-- vim.keymap.set("n", "<C-m>", "<Plug>(VM-Find-Under)")
-- vim.keymap.set("x", "<C-m>", "<Plug>(VM-Find-Subword-Under)")

-- Execute a command when exiting Neovim
vim.api.nvim_exec([[
  augroup ExitNeovimAutocmd
    autocmd!
    autocmd VimLeave * lua print("Goodbye! This command runs on Neovim exit.")
  augroup END
]], false)
