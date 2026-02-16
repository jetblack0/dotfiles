local helpers = require("utils.helpers")
local codediff = helpers.safe_require("codediff")

if not codediff then return end

codediff.setup({
  keymaps = {
    view = {
      quit = "q",
      toggle_explorer = "<leader>b",
      next_hunk = "<leader>gn",
      prev_hunk = "<leader>gN",
      show_help = "<leader>g?",
    },
    explorer = {
      select = "<CR>",
      toggle_view_mode = "i",
      restore = "X",
    },
    history = {
      select = "<CR>",
      toggle_view_mode = "i",
    },
  },
})
