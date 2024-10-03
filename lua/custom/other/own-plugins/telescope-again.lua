local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local M = {}

local function send_to_telescope_again(prompt_bufnr)
  print("prompt_bufnr", prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  print("picker", picker)
  local results = {}

  -- Collect the current filtered entries from Telescope
  picker:find(function(entry)
    if entry ~= nil then
      table.insert(results, entry.value)
    end
  end)

  -- print all the entries in results clearly
  print(vim.inspect(results));

  -- Close the current Telescope instance
  actions.close(prompt_bufnr)

  -- Start a new Telescope picker with the filtered entries
  pickers
    .new({}, {
      prompt_title = "Refiltered Results",
      finder = finders.new_table {
        results = results,
      },
      sorter = conf.generic_sorter {},
    })
    :find()
end

M.send_to_telescope_again = send_to_telescope_again

return M
