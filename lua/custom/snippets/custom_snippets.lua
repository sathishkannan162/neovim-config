local M = {}

local function load_snippets()
  -- local ls = require "luasnip"
  -- ls.add_snippets()
  local opts = {
    paths = "~/Library/Application Support/Code/User/snippets/typescript.json",
  }
  require("luasnip.loaders.from_vscode}").lazy_load(opts)
end

M.load_snippets = load_snippets
return M
