local M = {
  "mfussenegger/nvim-dap",

  dependencies = {

    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
      },
      opts = {},
      config = function(_, opts)
        -- setup dap config by VsCode launch.json file
        -- require("dap.ext.vscode").load_launchjs()
        local dap = require "dap"
        local dapui = require "dapui"
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open {}
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close {}
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close {}
        end
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },

    -- which key integration
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        defaults = {
          ["<leader>d"] = { name = "+debug" },
        },
      },
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

  config = function()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    local icons = {
      dap = {
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
      },
    }

    for name, sign in pairs(icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}

return M

-- {
--   "nvim-telescope/telescope-dap.nvim",
--   lazy = false,
--   config = function()
--     require("telescope").load_extension "dap"
--   end,
-- },
-- {
--   "rcarriga/nvim-dap-ui",
--   lazy = false,
--   dependencies = {
--     "mfussenegger/nvim-dap",
--     "microsoft/vscode-js-debug",
--     "theHamsta/nvim-dap-virtual-text",
--     "nvim-telescope/telescope-dap.nvim",
--   },
--   config = function()
--     local function configure()
--       -- local dap_install = require "dap-install"
--       -- dap_install.setup {
--       --   installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
--       -- }
--
--       local dap_breakpoint = {
--         breakpoint = {
--           text = "",
--           texthl = "LspDiagnosticsSignError",
--           linehl = "",
--           numhl = "",
--         },
--         rejected = {
--           text = "",
--           texthl = "LspDiagnosticsSignHint",
--           linehl = "",
--           numhl = "",
--         },
--         stopped = {
--           text = "",
--           texthl = "LspDiagnosticsSignInformation",
--           linehl = "DiagnosticUnderlineInfo",
--           numhl = "LspDiagnosticsSignInformation",
--         },
--       }
--
--       vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
--       vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
--       vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
--     end
--
--     local function configure_exts()
--       require("nvim-dap-virtual-text").setup {
--         commented = true,
--       }
--
--       local dap, dapui = require "dap", require "dapui"
--       dapui.setup {
--         expand_lines = true,
--         icons = { expanded = "", collapsed = "", circular = "" },
--         mappings = {
--           -- Use a table to apply multiple mappings
--           expand = { "<CR>", "<2-LeftMouse>" },
--           open = "o",
--           remove = "d",
--           edit = "e",
--           repl = "r",
--           toggle = "t",
--         },
--         layouts = {
--           {
--             elements = {
--               { id = "scopes", size = 0.33 },
--               { id = "breakpoints", size = 0.17 },
--               { id = "stacks", size = 0.25 },
--               { id = "watches", size = 0.25 },
--             },
--             size = 0.33,
--             position = "right",
--           },
--           {
--             elements = {
--               { id = "repl", size = 0.45 },
--               { id = "console", size = 0.55 },
--             },
--             size = 0.27,
--             position = "bottom",
--           },
--         },
--         floating = {
--           max_height = 0.9,
--           max_width = 0.5, -- Floats will be treated as percentage of your screen.
--           border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
--           mappings = {
--             close = { "q", "<Esc>" },
--           },
--         },
--       } -- use default
--       dap.listeners.after.event_initialized["dapui_config"] = function()
--         dapui.open()
--       end
--       dap.listeners.before.event_terminated["dapui_config"] = function()
--         dapui.close()
--       end
--       dap.listeners.before.event_exited["dapui_config"] = function()
--         dapui.close()
--       end
--     end
--
--     local function configure_debuggers()
--       -- require("config.dap.lua").setup()
--       -- require("config.dap.python").setup()
--       -- require("config.dap.rust").setup()
--       -- require("config.dap.go").setup()
--       -- require("config.dap.csharp").setup()
--       -- require("config.dap.kotlin").setup()
--       -- require("config.dap.javascript").setup()
--       -- require("config.dap.typescript").setup()
--     end
--
--     local function setup()
--       configure() -- Configuration
--       configure_exts() -- Extensions
--       configure_debuggers() -- Debugger
--       -- require("config.dap.keymaps").setup() -- Keymaps
--     end
--
--     configure_debuggers()
--     setup()
--   end,
-- },
-- {
--   "folke/neodev.nvim",
--   lazy = false,
--   config = function()
--     require("neodev").setup {
--       library = {
--         plugins = {
--           "nvim-dap-ui",
--         },
--         types = "true",
--       },
--     }
--   end,
-- },
-- {
--   "theHamsta/nvim-dap-virtual-text",
--   config = function()
--     require("nvim-dap-virtual-text").setup {
--       commented = true,
--     }
--   end,
-- },
-- {
--   "microsoft/vscode-js-debug",
--   lazy = false,
--   dependencies = {
--     "mxsdev/nvim-dap-vscode-js",
--   },
--   config = function()
--     local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"
--     local function setup()
--       require("dap-vscode-js").setup {
--         node_path = "node",
--         debugger_path = DEBUGGER_PATH,
--         -- debugger_cmd = { "js-debug-adapter" },
--         adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
--       }
--
--       for _, language in ipairs { "typescript", "javascript" } do
--         require("dap").configurations[language] = {
--           {
--             type = "pwa-node",
--             request = "launch",
--             name = "Launch file",
--             program = "${file}",
--             cwd = "${workspaceFolder}",
--           },
--           {
--             type = "pwa-node",
--             request = "attach",
--             name = "Attach",
--             processId = require("dap.utils").pick_process,
--             cwd = "${workspaceFolder}",
--           },
--           {
--             type = "pwa-node",
--             request = "launch",
--             name = "Debug Jest Tests",
--             -- trace = true, -- include debugger info
--             runtimeExecutable = "node",
--             runtimeArgs = {
--               "./node_modules/jest/bin/jest.js",
--               "--runInBand",
--             },
--             rootPath = "${workspaceFolder}",
--             cwd = "${workspaceFolder}",
--             console = "integratedTerminal",
--             internalConsoleOptions = "neverOpen",
--           },
--           -- {
--           --   type = "pwa-node",
--           --   request = "launch",
--           --   name = "Severless debug",
--           --   program = "${workspaceFolder}/node_modules/.bin/sls",
--           --   args = { "offline", "start", "--stage", "staging" },
--           --   env = { NODE_ENV = "development" },
--           --   autoAttachChildProcesses = true,
--           --   sourceMaps = true,
--           --   skipFiles = { "<node_internals>/**" },
--           --   console = "integratedTerminal",
--           --   sourceMrpPathOverrides = {
--           --     ["webpack:///../../../*"] = "${workspaceFolder}/*",
--           --   },
--           -- },
--         }
--       end
--
--       for _, language in ipairs { "typescriptreact", "javascriptreact" } do
--         require("dap").configurations[language] = {
--           {
--             type = "pwa-chrome",
--             name = "Attach - Remote Debugging",
--             request = "attach",
--             program = "${file}",
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--             protocol = "inspector",
--             port = 3000,
--             webRoot = "${workspaceFolder}",
--           },
--           {
--             type = "pwa-chrome",
--             name = "Next.js: debug client-side",
--             request = "launch",
--             url = "http://localhost:3010",
--           },
--           {
--             name = "test next",
--             type = "pwa-chrome",
--             runtimeExecutable = "node",
--             request = "attach",
--             protocol = "inspector",
--             port = 3000,
--             webRoot = "${workspaceFolder}",
--             -- request = "launch",
--             runtimeArgs = {
--               "./node_modules/.bin/next",
--               "dev",
--             },
--             cwd = "${workspaceFolder}",
--             console = "integratedTerminal",
--             internalConsoleOptions = "neverOpen",
--           },
--           {
--             name = "Next.js: debug full stack",
--             type = "node-terminal",
--             request = "launch",
--             command = "npm run dev",
--             runtimeExecutable = "node",
--             sourceMaps = true,
--             rootPath = "${workspaceFolder}",
--             cwd = "${workspaceFolder}",
--             console = "integratedTerminal",
--             port = 3000,
--             serverReadyAction = {
--               pattern = "started server on .+, url: (https?://.+)",
--               uriFormat = "%s",
--               action = "debugWithChrome",
--             },
--           },
--
--           {
--             name = "Next.js: debug server-side",
--             sourceMaps = true,
--             type = "node-terminal",
--             protocol = "inspector",
--             request = "launch",
--             command = "npm run dev",
--             webRoot = "${workspaceFolder}",
--           },
--           {
--             type = "pwa-chrome",
--             name = "Launch Chrome",
--             request = "launch",
--             url = "http://localhost:3000",
--           },
--         }
--       end
--     end
--     setup()
--     require("dap.ext.vscode").load_launchjs(nil, { ["pwa-node"] = { "typescript" } })
--   end,
-- },
--
