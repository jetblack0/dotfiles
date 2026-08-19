local helpers = require("utils.helpers")
local yazi = helpers.safe_require("yazi")

if not yazi then return end

yazi.setup({
  open_for_directories = false,
  keymaps = {
    show_help = "~",
  },
})
