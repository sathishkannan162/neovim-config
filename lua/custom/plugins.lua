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
    cond = function()
      return not require("custom.utils").isApiDir()
    end,
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
    -- cond = function()
    --   return not require("custom.utils").isApiDir()
    -- end,
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
      -- require("auto-save").setup({
      --   execution_message = {
      --     message = function()
      --      return ''
      --     end
      --   }
      -- })
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
        close_fold_kinds_for_ft = { default = { "comments", "imports" } },
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
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = false,
          },
        },
      }
    end,
  },
  -- causes issues with enter
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
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
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
  -- {
  --   "m4xshen/hardtime.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {},
  -- },
  {
    "mfussenegger/nvim-dap",
    dependencies = {

      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
      -- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({reset=true }) end, desc = "Dap UI" },
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
    { "<leader>dT", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
    opts = function(_, opts)
      local dap = require "dap"
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
        if not dap.configurations[language] then
          dap.configurations[language] = {
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
              name = "Serverless Debug",
              program = "${workspaceFolder}/node_modules/.bin/sls",
              args = { "offline", "start", "--stage", "staging" },
              env = { NODE_ENV = "development" },
              autoAttachChildProcesses = true,
              sourceMaps = true,
              skipFiles = { "<node_internals>/**" },
              console = "integratedTerminal",
              sourceMapPathOverrides = {
                ["webpack:///../../../*"] = "${workspaceFolder}/*",
              },
            },
          }
        end
      end
      local function printKeyValues(table)
        for key, value in pairs(table) do
          print(key, value, "key value")
        end
      end
      local function printValues(array)
        for _, value in ipairs(array) do
          -- print(value)
          printKeyValues(value)
        end
      end
      -- print(dap.configurations["typescript"], "typescript")
      -- printKeyValues(dap.configurations.typescript)
      -- printValues(dap.configurations.typescript)
    end,

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
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
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
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require("mason-nvim-dap").default_setup(config)
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        "js",
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    -- opts = function()
    --
    -- end
    -- opts = {
    --   -- debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path(),
    --   debugger_path = './',
    --   adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    -- },
    config = function()
      local dbg_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
      require("dap-vscode-js").setup {
        debugger_path = dbg_path,
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      }
    end,
  },
  -- leap.nvim
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = "n", desc = "search text" },
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "kawre/leetcode.nvim",
    -- cmd="LeetCode",
    lazy = false,
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      -- "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
    },
  },
  -- {
  --   "LintaoAmons/scratch.nvim",
  --   event = "VeryLazy",
  -- },
  -- {
  --   "echasnovski/mini.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("mini.animate").setup()
  --   end,
  -- },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup {
        api_key_cmd = "pass show openai/chatgpt_nvim_api_key",
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    ft = "markdown",
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "epwalsh/pomo.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Desktop/obsidian_vaults/creative-learner/",
        },
      },
      daily_notes = {
        date_format = "%d-%m-%Y",
        alias_format = "%d-%m-%Y",
        template = nil,
      },
      disable_frontmatter = true,
      note_id_func = function(title)
        return title
      end,
      note_frontmatter_func = function(note)
        local out = { tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },
    },
  },
  {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat" },
    dependencies = {
      -- Optional, but highly recommended if you want to use the "Default" timer
      -- "rcarriga/nvim-notify",
    },
    opts = {},
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      -- vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    cond = function()
      return not require("custom.utils").isApiDir()
    end,
    opts = function()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, { name = "crates" })
      return M
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- event = "VeryLazy",
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
    keys = {
      {
        "<leader>dy",
        function()
          require("dap-python").test_method()
        end,
      },
    },
  },
  {
    "Vigemus/iron.nvim",
    ft = { "python" },
    config = function()
      local iron = require "iron.core"

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = false,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").right(50),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
      vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
      vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<space>ri", "<cmd>IronHide<cr>")
    end,
  },
  {
    "goerz/jupytext.vim",
    lazy = false,
  },
  -- firenvim, neovim in text fields
  {
    "glacambre/firenvim",

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "otavioschwanck/cool-substitute.nvim",
    keys = {
      { "gm", mode = "n", desc = "Cool Substitute mark word/ region" },
      { "S", mode = "n", desc = "Search whole file" },
    },
    config = function(_, opts)
      require("cool-substitute").setup {
        setup_keybindings = true,
        -- mappings = {
        --   start = 'gm', -- Mark word / region
        --   start_and_edit = 'gM', -- Mark word / region and also edit
        --   start_and_edit_word = 'g!M', -- Mark word / region and also edit.  Edit only full word.
        --   start_word = 'g!m', -- Mark word / region. Edit only full word
        --   apply_substitute_and_next = 'M', -- Start substitution / Go to next substitution
        --   apply_substitute_and_prev = '<C-b>', -- same as M but backwards
        --   apply_substitute_all = 'ga', -- Substitute all
        --   force_terminate_substitute = 'g!!', -- Terminate macro (if some bug happens)
        --   terminate_substitute = '<esc>', -- Terminate macro
        --   skip_substitute = 'n', -- Skip this occurrence
        --   goto_next = '<C-j>', -- Go to next occurence
        --   goto_previous = '<C-k>', -- Go to previous occurrence
        -- },
        -- reg_char = 'o', -- letter to save macro (Dont use number or uppercase here)
        -- mark_char = 't', -- mark the position at start of macro
        -- writing_substitution_color = "#ECBE7B", -- for status line
        -- applying_substitution_color = "#98be65", -- for status line
        -- edit_word_when_starting_with_substitute_key = true -- (press M to mark and edit when not executing anything anything)
      }
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          -- telescope-undo.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension "undo"
    end,
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
  -- improves performance of typescript server
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "laytan/cloak.nvim",
    ft = "sh",
    config = function(_, opts)
      require("cloak").setup {
        enabled = true,
        cloak_character = "*",
        -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
        highlight_group = "Comment",
        -- Applies the length of the replacement characters for all matched
        -- patterns, defaults to the length of the matched pattern.
        cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
        -- Whether it should try every pattern to find the best fit or stop after the first.
        try_all_patterns = true,
        -- Set to true to cloak Telescope preview buffers. (Required feature not in 0.1.x)
        cloak_telescope = true,
        -- Re-enable cloak when a matched buffer leaves the window.
        cloak_on_leave = false,
        patterns = {
          {
            -- Match any file starting with '.env'.
            -- This can be a table to match multiple file patterns.
            file_pattern = ".env*",
            -- Match an equals sign and any character after it.
            -- This can also be a table of patterns to cloak,
            -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
            cloak_pattern = "=.+",
            -- A function, table or string to generate the replacement.
            -- The actual replacement will contain the 'cloak_character'
            -- where it doesn't cover the original text.
            -- If left empty the legacy behavior of keeping the first character is retained.
            replace = nil,
          },
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    keys = { { "<leader>op", mode = "n", desc = "Outline open" } },
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    ft = { "typescriptreact", "typescript", "javascriptreact", "javascript", "html", "css" },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-jest" {
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "echasnovski/mini.icons" },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require("oil").setup()
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup {
        keymaps = {
          accept_suggestion = "<C-k>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
        disable_keymaps = false,
      }
    end,
  },
  {
    "FeiyouG/commander.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>f", "<CMD>Telescope commander<CR>", mode = "n" },
      { "<leader>fc", "<CMD>Telescope commander<CR>", mode = "n" },
    },
    config = function()
      require("commander").setup {
        components = {
          "DESC",
          "KEYS",
          "CAT",
        },
        sort_by = {
          "DESC",
          "KEYS",
          "CAT",
          "CMD",
        },
        integration = {
          telescope = {
            enable = true,
          },
          lazy = {
            enable = true,
            set_plugin_name_as_cat = true,
          },
        },
      }
    end,
  },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },
  -- {
  --   "luk400/vim-jukit",
  --   lazy = false,
  -- },
  -- ,

  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  -- lazy=false,
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
  --
  --   "mrjones2014/legendary.nvim",
  --   -- since legendary.nvim handles all your keymaps/commands,
  --   -- its recommended to load legendary.nvim before other plugins
  --   priority = 10000,
  --   lazy = false,
  --   -- sqlite is only needed if you want to use frecency sorting
  --   -- dependencies = { 'kkharji/sqlite.lua' }
  -- },
  -- {
  --   "JoosepAlviste/nvim-ts-context-commentstring",
  -- lazy=false,
  -- }
  -- {
  --   "metakirby5/codi.vim",
  --   lazy=false,
  -- }
  -- {
  --   "0x100101/lab.nvim",
  --   lazy = false,
  --   opts = {
  --     quick_data = {
  --       enabled = true,
  --     },
  --     code_runner = {
  --       enabled = true,
  --     },
  --   },
  -- },
  -- {
  --   "gaelph/logsitter",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   config = function()
  --     vim.api.nvim_create_augroup("LogSitter", { clear = true })
  --     vim.api.nvim_create_autocmd("FileType", {
  --       group = "Logsitter",
  --       pattern = "javascript,go,lua",
  --       callback = function()
  --         vim.keymap.set("n", "<localleader>lg", function()
  --           require("logsitter").log()
  --         end)
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --    "miikanissi/modus-themes.nvim",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd [[colorscheme modus]] -- modus_operandi, modus_vivendi
  --   end,
  -- },
  -- NOTE: Unable to use obsidian.nvim as google drive imposes permission restrictions on cli tools.

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

  {
    "neoclide/coc.nvim",
    ft = "typescript",
    branch = "release",
    cond = function()
      return require("custom.utils").isApiDir()
    end,
    config = function()
      require("custom.other.plugins.coc").loadCoc()
    end,
  },
  {
    "fannheyward/telescope-coc.nvim",
    cond = function()
      return require("custom.utils").isApiDir()
    end,
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension "coc"
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    config = function()
      require("custom.other.plugins.avante").setup()
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
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
