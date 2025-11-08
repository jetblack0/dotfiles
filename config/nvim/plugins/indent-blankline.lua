local helpers = require("utils.helpers")
local ibl = helpers.safe_require("ibl")
if not ibl then return end

ibl.setup {
	indent = { char = "╎" },
	scope = {
    enabled = true,
    show_start = false
  },
}
