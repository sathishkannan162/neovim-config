local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  -- webdev stuff -- deno fmt not reading prettier local config
  -- b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettierd.with {
    filetypes = {
      "html",
      -- "markdown",
      "css",
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
      "astro",
      "json",
    },
  }, -- so prettier works only on these filetypes
  -- b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "typescript", "javascript" } }, -- so prettier works only on these filetypes
  b.formatting.eslint_d.with {
    filetypes = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "json" },
  },

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
  b.formatting.shfmt,
  b.formatting.rustfmt,
  b.formatting.black,

  -- b.diagnostics.mypy,
  b.diagnostics.ruff,
}

local on_attach = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end
end

null_ls.setup {
  debug = true,
  sources = sources,
  -- on_attach = on_attach,
}
