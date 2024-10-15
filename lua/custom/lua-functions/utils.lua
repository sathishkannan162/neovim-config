local function generate_random_id()
  -- Define the characters used in the ID (0-9, a-z)
  local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  local id_length = 9
  local random_id = ""

  -- Generate the random ID
  for i = 1, id_length do
    -- Get a random index from 1 to the length of the character set
    local random_index = math.random(1, #chars)
    -- Add the random character to the ID
    random_id = random_id .. chars:sub(random_index, random_index)
  end

  return random_id
end
local M = {}

M.replace_selection_with_random_id = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  local random_str= generate_random_id()


  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 0, end_pos[2] - 1, end_pos[3], { random_str })
end
return M
