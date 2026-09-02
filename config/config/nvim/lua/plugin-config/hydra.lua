-- A sticky resize mode: press <C-r> once, then h/j/k/l as many times as needed,
-- <Esc> to leave.

local helpers = require("utils.helpers")
local Hydra = helpers.safe_require("hydra")
if not Hydra then return end

local STEP = 3

-- Snacks pickers park the cursor in a float that lives inside a split, and
-- resizing the float only moves the float. Resize the owning split instead.
-- Returns nil for a free-floating window, which has no split to speak of.
local function owning_split(win)
  for _ = 1, 8 do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then
      return win
    end
    if config.relative ~= "win" or not config.win or not vim.api.nvim_win_is_valid(config.win) then
      return nil
    end
    win = config.win
  end
  return nil
end

-- Whether the window is the last one along an axis. Screen positions rather
-- than winnr(), because hydra's own hint float renumbers the windows.
local function at_last(win, horizontal)
  local pos = vim.api.nvim_win_get_position(win)
  local edge = horizontal and pos[2] + vim.api.nvim_win_get_width(win)
    or pos[1] + vim.api.nvim_win_get_height(win)

  for _, other in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if other ~= win and vim.api.nvim_win_get_config(other).relative == "" then
      local other_pos = vim.api.nvim_win_get_position(other)
      if (horizontal and other_pos[2] or other_pos[1]) >= edge then
        return false
      end
    end
  end
  return true
end

local function resize(key)
  local win = owning_split(vim.api.nvim_get_current_win())
  if not win then
    return
  end

  local horizontal = key == "h" or key == "l"
  local grow = (key == "l" or key == "j") ~= at_last(win, horizontal)
  local cmd = string.format(
    "%sresize %s%d", horizontal and "vertical " or "", grow and "+" or "-", STEP
  )
  vim.api.nvim_win_call(win, function() vim.cmd(cmd) end)
end

Hydra({
  name = "Resize splits",
  mode = "n",
  body = "<C-r>",
  config = {
    color = "red",
    invoke_on_body = true,
    hint = { type = "window", position = { "bottom" } },
  },
  heads = {
    { "h", function() resize("h") end, { desc = "left" } },
    { "j", function() resize("j") end, { desc = "down" } },
    { "k", function() resize("k") end, { desc = "up" } },
    { "l", function() resize("l") end, { desc = "right" } },
    { "=", "<C-w>=", { desc = "equalize" } },
    { "<Esc>", nil, { exit = true, desc = "done" } },
    { "q", nil, { exit = true, desc = false } },
  },
})
