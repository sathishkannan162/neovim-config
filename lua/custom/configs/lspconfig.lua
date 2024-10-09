local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

-- if you just want default config for the servers then put them in a table
-- local servers = { "html", "cssls", "tsserver", "clangd", "eslint", "astro", "bashls", "pyright", "marksman", "gopls" }
local servers = { "html", "cssls", "clangd", "eslint", "astro", "bashls", "pyright", "marksman", "gopls"  }
-- grammarly language server gives too much errors when writing notes.

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- tyescript-tools.nvim

require("typescript-tools").setup {
  on_attach = on_attach,
  capabilities = capabilities,
  separate_diagnostic_server = true,
  -- "change"|"insert_leave" determine when the client asks the server about diagnostic
  publish_diagnostic_on = "insert_leave",
}

lspconfig.docker_compose_language_service.setup {
  filetypes= {"yaml", "yaml.docker-compose"}
}

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
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
}
lspconfig.astro.setup {}
lspconfig.bashls.setup { filetypes = { "sh" } }
