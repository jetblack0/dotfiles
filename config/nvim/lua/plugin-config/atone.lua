local helpers = require("utils.helpers")

local atone = helpers.safe_require("atone")
if not atone then return end

atone.setup({
  layout = {
    direction = "right",
    width = 0.25,
  },
  diff_cur_node = {
    enabled = true,
    split_percent = 0.5,
  },
  ui = {
    border = "single",
    compact = false,
  },
  keymaps = {
    tree = {
      quit = { "q" },
      next_node = "j",
      pre_node = "k",
      jump_to_G = "G",
      jump_to_gg = "gg",
      undo_to = "<CR>",
      help = { "?", "g?" },
    },
    auto_diff = {
      quit = { "<C-c>", "q" },
      help = { "?", "g?" },
    },
    help = {
      quit_help = { "<C-c>", "q" },
    },
  },
})
