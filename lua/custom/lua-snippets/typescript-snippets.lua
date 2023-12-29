local M = {}

local function copy(args)
  return args[1]
end
local ls = require "luasnip"
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

M.typescript = {
  s("clo", {
    t 'console.log("',
    i(1, "first"),
    t '",',
    f(copy, 1),
    t ");",
    i(0),
  }),
  s("clj", {
    t 'console.log("',
    i(1, "test"),
    t '",',
    t "JSON.parse(JSON.stringify(",
    f(copy, 1),
    t "))",
    t ");",
    i(0),
  }),
  s("clkj", {
    -- Simple static text.
    t "//Parameters: ",
    -- function, first parameter is the function, second the Placeholders
    -- whose text it gets as input.
    f(copy, 2),
    t { "", "function " },
    -- Placeholder/Insert.
    i(1),
    t "(",
    -- Placeholder with initial text.
    i(2, "int foo"),
    -- Linebreak
    t { ") {", "\t" },
    -- Last Placeholder, exit Point of the snippet.
    i(0),
    t { "", "}" },
  }),
}

return M
