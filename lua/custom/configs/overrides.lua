local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "python",
    "go",
    "rust"
  },
  autotag = {
    enable = true,
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    "js-debug-adapter",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "tailwindcss-language-server",
    "eslint-lsp",
    "eslint_d",
    "node-debug2-adapter",
    "astro-language-server ",
    -- "deno" -- not reading local prettier config,
    "prettier",
    "prettierd",

    -- rust
    "rust-analyzer",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- text
    -- "grammarly-languageserver",

    -- python
    "pyright", -- lsp
    "black", -- formatter
    "mypy", -- static type checking linters
    "ruff", -- static typeschecking linters
    "debugpy", -- debugger

    -- markdown
    "marksman",

    -- go 
    "gopls",
    "delve" -- debgger
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
