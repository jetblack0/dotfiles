local helpers = require("utils.helpers")
local hlslens = helpers.safe_require("hlslens")

if not hlslens then return end

hlslens.setup()

local star_opts = { noremap = true, silent = false }
vim.keymap.set("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]],
  vim.tbl_extend("force", star_opts, { desc = "Search word under cursor forward" }))
vim.keymap.set("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]],
  vim.tbl_extend("force", star_opts, { desc = "Search word under cursor backward" }))

local function search_selection(motion)
  local anchor, cursor = vim.fn.getpos("v"), vim.fn.getpos(".")
  local lines = vim.fn.getregion(anchor, cursor, { type = vim.fn.mode() })
  local text = table.concat(lines, "\n")
  if text == "" then return end

  local pattern = "\\V" .. vim.fn.escape(text, "\\"):gsub("\n", "\\n")
  vim.fn.setreg("/", pattern)
  vim.fn.histadd("search", pattern)

  -- Search from the top of the selection, so `#` finds the previous match
  -- instead of walking back into the one just selected.
  local start = (anchor[2] < cursor[2] or (anchor[2] == cursor[2] and anchor[3] <= cursor[3]))
    and anchor or cursor
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  vim.api.nvim_win_set_cursor(0, { start[2], start[3] - 1 })
  vim.cmd("normal! " .. motion)
  hlslens.start()
end

vim.keymap.set("x", "*", function() search_selection("n") end,
  vim.tbl_extend("force", star_opts, { desc = "Search selection forward" }))
vim.keymap.set("x", "#", function() search_selection("N") end,
  vim.tbl_extend("force", star_opts, { desc = "Search selection backward" }))
