local M = {}

M.setup = function()
  require("avante").setup {

    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    -- provider = "claude", -- Recommend using Claude
    provider = "claude", -- Recommend using Claude
    auto_suggestions_provider = "azure", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20240620",
      temperature = 0,
      max_tokens = 4096,
    },
    azure = {
      endpoint = "https://gpt-4o-staging.openai.azure.com",
      deployment = "chatbox-GPT-4o-team",
      api_version = "2023-03-15-preview",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      ["local"] = false,
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    mappings = {
      --- @class AvanteConflictMappings
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
      },
    },
    hints = { enabled = true },
    windows = {
      ---@type "right" | "left" | "top" | "bottom"
      position = "right", -- the position of the sidebar
      wrap = true, -- similar to vim.o.wrap
      width = 30, -- default % based on available width
      sidebar_header = {
        align = "center", -- left, center, right for title
        rounded = true,
      },
    },
    highlights = {
      ---@type AvanteConflictHighlights
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    --- @class AvanteConflictUserConfig
    diff = {
      autojump = true,
      ---@type string | fun(): any
      list_opener = "copen",
    },
  }
end

return M