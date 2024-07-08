---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["mj"] = { "<cmd> LspRestart <CR>", "Restart server" },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
  c = {
    ["jk"] = { "<ESC>", "Exit command mode to normal mode" },
  },
}

M.nvimtree = {
  n = {
    ["<c-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
}

-- more keybinds!
M.telescope = {
  n = {
    ["<leader>fr"] = { "<cmd> lua require('telescope.builtin').lsp_references() <CR>", "lsp references" },
    ["gd"] = { "<cmd> lua require('telescope.builtin').lsp_definitions() <CR>", "lsp references" },
    ["gt"] = { "<cmd> lua require('telescope.builtin').lsp_type_definitions() <CR>", "lsp references" },
    ["go"] = { "<cmd> lua require('telescope.builtin').lsp_document_symbols() <CR>", "lsp references" },
  },
}

M.harpoon = {
  n = {
    ["<leader>na"] = { "<cmd> lua require('harpoon.mark').add_file() <CR>", "harpoon add file" },
    ["<leader>ns"] = { "<cmd> lua require('harpoon.ui').toggle_quick_menu() <CR>", "harpoon quick menu" },
    ["<leader>nt"] = { "<cmd> Telescope harpoon marks <CR>", "harpoon quick menu" },
  },
}

M.trouble = {
  n = {
    -- ["mt"] = { "<cmd> lua require('trouble').toggle() <CR>", "telescope toggle" },
    ["mt"] = {
      "<cmd>Trouble diagnostics toggle<cr>",
      "Diagnostics (Trouble)",
    },
    ["mb"] = {
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      "Buffer diagnostics (Trouble)",
    },
    ["md"] = {
      "<cmd> lua require('trouble').toggle 'document_diagnostics' <CR>",
      "telescope document diagnostics",
    },
    ["mq"] = {
      "<cmd> lua require('trouble').toggle 'quickfix' <CR>",
      "telescope quickfix",
    },
    ["ml"] = {
      "<cmd> lua require('trouble').toggle 'loclist' <CR>",
      "telescope loclist",
    },
    ["mr"] = {
      "<cmd> lua require('trouble').toggle 'lsp_references' <CR>",
      "telescope references",
    },
  },
}

M["vim-visual-multi"] = {
  n = {
    ["<leader>mk"] = { "<Plug>(VM-Add-Cursor-Up)" },
    ["<leader>mj"] = { "<Plug>(VM-Add-Cursor-Down)" },
    ["<C-m>"] = { "<Plug>(VM-Find-Under)" },
  },
  x = {
    ["<C-m>"] = { "<Plug>(VM-Find-Subword-Under)", "Multi Find Subword Under" },
  },
}

M.leap = {
  n = {
    ["gs"] = { "<Plug>(leap-from-window)", "Search in other window" },
  },
}

M.quickfix = {
  n = {
    ["<leader>tn"] = { "<cmd>cnext<cr>" },
    ["<leader>tm"] = { "<cmd>cprevious<cr>" },
  },
}

-- M.dap = {
--   n = {
--     ["<leader>dt"] = { "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>" },
--     ["<leader>dl"] = { "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>" },
--     ["<leader>dx"] = { "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>" },
--     -- ["<leader>dt"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
--     ["<leader>db"] = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
--     ["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--     ["<leader>dC"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
--     ["<leader>dd"] = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
--     ["<leader>dg"] = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
--     ["<leader>di"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
--     ["<leader>do"] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
--     ["<leader>du"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
--     ["<leader>dp"] = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
--     ["<leader>dr"] = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
--     ["<leader>ds"] = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
--     ["<leader>dq"] = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
--     ["<leader>dU"] = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
--   },
--   v = {
--     ["<leader>de"] = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
--   },
-- }
-- M.actions_preview = {
--   n = {
--     ["<leader>co"] = { "<cmd> lua require('actions-preview').code_actions <CR>", "telescope code actions" },
--   },
--   -- v = {
--   --   ["<leader>co"] = { "<cmd> lua require('actions-preview').code_actions <CR>", "harpoon quick menu" },
--   -- },
-- }

M.neotest = {
  n = {
    ["<leader>to"] = { "<cmd>lua require('neotest').run.run()<cr>", "Run nearest run." },
    ["<leader>ti"] = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run current file." },
    ["<leader>te"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug nearest test" },
    ["<leader>ts"] = { "<cmd>lua require('neotest').run.stop()<cr>", "Test Stop" },
    ["<leader>ta"] = { "<cmd>lua require('neotest').run.attach()<cr>", "Test attach" },
  },
}

return M
