local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "tailwindcss", "eslint", "astro", "bashls"  }
-- grammarly language server gives too much errors when writing notes.

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- can cause conflict with rust tools.
-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "rust" },
--   root_dir = util.root_pattern "Cargo.toml",
--   settings = {
--     ["rust_analyzer"] = {
--       cargo = {
--         all_features = true,
--       },
--     },
--   },
-- }

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true
-- }
-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
-- for _, ls in ipairs(language_servers) do
--     require('lspconfig')[ls].setup({
--         capabilities = capabilities
--         -- you can add other fields for setting up lsp server in this table
--     })
-- end
-- require('ufo').setup()

--
-- lspconfig.pyright.setup { blabla}
--
lspconfig.tailwindcss.setup {}
lspconfig.astro.setup {}
lspconfig.bashls.setup { filetypes = { "sh" } }
