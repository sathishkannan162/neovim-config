local overrides = require "custom.configs.overrides"

-- nvim-ufo custom closed fold text function handler

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
    -- enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    -- enabled = false,
    -- dependencies = {
    --   "JoosepAlviste/nvim-ts-context-commentstring",
    -- },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- My plugins
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    -- event = "InsertEnter",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = "G",
  },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   version = "*",
  --   lazy = false,
  --   config = function()
  --     require("toggleterm").setup {
  --       open_mapping = [[<A-h>]],
  --       direction = "horizontal",
  --     }
  --   end,
  -- },
  {
    "NvChad/nvterm",
    -- enabled = false,
  },
  {
    "ggandor/leap.nvim",
    keys = { { "s", mode = "n", desc = "search whole file" }, { "S", mode = "n", desc = "Search whole file" } },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },
  {
    "kylechui/nvim-surround",
    keys = { { "ys", mode = "n", desc = "Surround initiator" } },
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    -- keys = { { "z", mode = "n", des = "Enable fold nvim-ufo" } },
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "<C-t>", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
        fold_virt_text_handler = handler,
        close_fold_kinds = { "comments", "imports" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      }
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "typescriptreact", "javascriptreact", "html", "css" },
    -- optionally, override the default options:
    config = function()
      require("tailwindcss-colorizer-cmp").setup {
        color_square_width = 2,
      }
    end,
  },
  {
    "preservim/nerdcommenter",
    keys = { { "<leader>c<leader>", mode = "n" } },
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end,
  },
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    -- keys = {
    --   { mode = "n", "<leader>mj" },
    --   { mode = "n", "<leader>mk" },
    -- },
    lazy = false,
    branch = "master",
  },
  {
    "gorbit99/codewindow.nvim",
    keys = {
      { mode = "n", "<leader>m" },
    },
    config = function()
      local codewindow = require "codewindow"
      codewindow.setup()
      codewindow.apply_default_keybinds()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "ThePrimeagen/harpoon",
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      { mode = "n", "<leader>co" },
      { mode = "v", "<leader>co" },
    },
    config = function()
      vim.keymap.set({ "v", "n" }, "<leader>co", require("actions-preview").code_actions, { remap = true })
    end,
  },
  {
    "wuelnerdotexe/vim-astro",
    ft = "astro",
    dependencies = { "wavded/vim-stylus" },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    lazy = false,
    config = function()
      require("telescope").load_extension "dap"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/vscode-js-debug",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local function configure()
        -- local dap_install = require "dap-install"
        -- dap_install.setup {
        --   installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
        -- }

        local dap_breakpoint = {
          breakpoint = {
            text = "",
            texthl = "LspDiagnosticsSignError",
            linehl = "",
            numhl = "",
          },
          rejected = {
            text = "",
            texthl = "LspDiagnosticsSignHint",
            linehl = "",
            numhl = "",
          },
          stopped = {
            text = "",
            texthl = "LspDiagnosticsSignInformation",
            linehl = "DiagnosticUnderlineInfo",
            numhl = "LspDiagnosticsSignInformation",
          },
        }

        vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
        vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
        vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
      end

      local function configure_exts()
        require("nvim-dap-virtual-text").setup {
          commented = true,
        }

        local dap, dapui = require "dap", require "dapui"
        dapui.setup {
          expand_lines = true,
          icons = { expanded = "", collapsed = "", circular = "" },
          mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 0.33,
              position = "right",
            },
            {
              elements = {
                { id = "repl", size = 0.45 },
                { id = "console", size = 0.55 },
              },
              size = 0.27,
              position = "bottom",
            },
          },
          floating = {
            max_height = 0.9,
            max_width = 0.5, -- Floats will be treated as percentage of your screen.
            border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
        } -- use default
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      end

      local function configure_debuggers()
        -- require("config.dap.lua").setup()
        -- require("config.dap.python").setup()
        -- require("config.dap.rust").setup()
        -- require("config.dap.go").setup()
        -- require("config.dap.csharp").setup()
        -- require("config.dap.kotlin").setup()
        -- require("config.dap.javascript").setup()
        -- require("config.dap.typescript").setup()
      end

      local function setup()
        configure() -- Configuration
        configure_exts() -- Extensions
        configure_debuggers() -- Debugger
        -- require("config.dap.keymaps").setup() -- Keymaps
      end

      configure_debuggers()
      setup()
    end,
  },
  {
    "folke/neodev.nvim",
    lazy = false,
    config = function()
      require("neodev").setup {
        library = {
          plugins = {
            "nvim-dap-ui",
          },
          types = "true",
        },
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup {
        commented = true,
      }
    end,
  },
  {
    "microsoft/vscode-js-debug",
    lazy = false,
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"
      local function setup()
        require("dap-vscode-js").setup {
          node_path = "node",
          debugger_path = DEBUGGER_PATH,
          -- debugger_cmd = { "js-debug-adapter" },
          adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
        }

        for _, language in ipairs { "typescript", "javascript" } do
          require("dap").configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
            -- {
            --   type = "pwa-node",
            --   request = "launch",
            --   name = "Severless debug",
            --   program = "${workspaceFolder}/node_modules/.bin/sls",
            --   args = { "offline", "start", "--stage", "staging" },
            --   env = { NODE_ENV = "development" },
            --   autoAttachChildProcesses = true,
            --   sourceMaps = true,
            --   skipFiles = { "<node_internals>/**" },
            --   console = "integratedTerminal",
            --   sourceMrpPathOverrides = {
            --     ["webpack:///../../../*"] = "${workspaceFolder}/*",
            --   },
            -- },
          }
        end

        for _, language in ipairs { "typescriptreact", "javascriptreact" } do
          require("dap").configurations[language] = {
            {
              type = "pwa-chrome",
              name = "Attach - Remote Debugging",
              request = "attach",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              port = 3000,
              webRoot = "${workspaceFolder}",
            },
            {
              type = "pwa-chrome",
              name = "Next.js: debug client-side",
              request = "launch",
              url = "http://localhost:3010",
            },
            {
              name = "test next",
              type = "pwa-chrome",
              runtimeExecutable = "node",
              request = "attach",
              protocol = "inspector",
              port = 3000,
              webRoot = "${workspaceFolder}",
              -- request = "launch",
              runtimeArgs = {
                "./node_modules/.bin/next",
                "dev",
              },
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
            {
              name = "Next.js: debug full stack",
              type = "node-terminal",
              request = "launch",
              command = "npm run dev",
              runtimeExecutable = "node",
              sourceMaps = true,
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              port = 3000,
              serverReadyAction = {
                pattern = "started server on .+, url: (https?://.+)",
                uriFormat = "%s",
                action = "debugWithChrome",
              },
            },

            {
              name = "Next.js: debug server-side",
              sourceMaps = true,
              type = "node-terminal",
              protocol = "inspector",
              request = "launch",
              command = "npm run dev",
              webRoot = "${workspaceFolder}",
            },
            {
              type = "pwa-chrome",
              name = "Launch Chrome",
              request = "launch",
              url = "http://localhost:3000",
            },
          }
        end
      end
      setup()
      require("dap.ext.vscode").load_launchjs(nil, { ["pwa-node"] = { "typescript" } })
    end,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    lazy = false,
    config = function()
      require("persistent-breakpoints").setup {
        load_breakpoints_event = { "BufReadPost" },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
  -- {
  --   "antonk52/bad-practices.nvim",
  --   lazy = false,
  --   config = function()
  --     require("bad_practices").setup {
  --       most_splits = 3, -- how many splits are considered a good practice(default: 3)
  --       most_tabs = 3, -- how many tabs are considered a good practice(default: 3)
  --       max_hjkl = 10, -- how many times you can spam hjkl keys in a row(default: 10)
  --     }
  --   end,
  -- },

  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   -- lazy=false,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --   },
  --   config = function()
  --     require("noice").setup {
  --       lsp = {
  --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --           ["vim.lsp.util.stylize_markdown"] = true,
  --           ["cmp.entry.get_documentation"] = true,
  --         },
  --       },
  --       -- you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = true, -- use a classic bottom cmdline for search
  --         command_palette = true, -- position the cmdline and popupmenu together
  --         long_message_to_split = true, -- long messages will be sent to a split
  --         inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --         lsp_doc_border = false, -- add a border to hover docs and signature help
  --       },
  --     }
  --   end,
  -- },

  -- {
  --   "neoclide/coc.nvim",
  --   lazy = false,
  --   branch = "release",
  -- },

  --
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
