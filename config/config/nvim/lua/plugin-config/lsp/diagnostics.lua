-- A sticky diagnostics mode: press <C-q> once, then j/k to walk the buffer's
-- diagnostics, <Esc> to leave.

local helpers = require("utils.helpers")
local Hydra = helpers.safe_require("hydra")
if not Hydra then return end

local ERROR = vim.diagnostic.severity.ERROR

-- Jumping stays quiet.
local function jump(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, severity = severity, wrap = true })
  end
end

local function toggle(key)
  return function()
    vim.diagnostic.config({ [key] = not vim.diagnostic.config()[key] })
  end
end

Hydra({
  name = "Diagnostics",
  mode = "n",
  body = "<C-q>",
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = { type = "window", position = { "bottom" } },
  },
  heads = {
    { "j", jump(1), { desc = "next" } },
    { "k", jump(-1), { desc = "prev" } },
    { "J", jump(1, ERROR), { desc = "next error" } },
    { "K", jump(-1, ERROR), { desc = "prev error" } },
    { "f", vim.diagnostic.open_float, { desc = "float" } },
    { "v", toggle("virtual_text"), { desc = "virtual text" } },
    { "V", toggle("virtual_lines"), { desc = "virtual lines" } },
    { "l", function() vim.diagnostic.setloclist() end, { desc = "loclist" } },
    { "<Esc>", nil, { exit = true, desc = "done" } },
    { "q", nil, { exit = true, desc = false } },
  },
})
