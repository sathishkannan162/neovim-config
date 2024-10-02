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

-- autocmd
require("./custom/autocmds").setup()

-- markdown mdx file setup
vim.api.nvim_exec(
  [[
  autocmd BufRead,BufNewFile *.mdx set filetype=markdown.mdx
]],
  false
)

-- vscode snippets path
-- vim.g.vscode_snippets_path = "~/Library/Application Support/Code/User/snippets/typescript.json"
vim.g.vscode_snippets_path = "~/Library/Application Support/Code/User/snippets"

-- local opts = {
--   paths = "~/Library/Application Support/Code/User/snippets/typescript.json",
-- }
-- require("luasnip.loaders.from_vscode}").lazy_load(opts)

-- set conceal level to 2 to support markdown rendering for bullet points and checkboxes, with obsidian.nvim plugin.
vim.o.conceallevel=2


-- autosession
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
