local helpers = require("utils.helpers")
local wk = helpers.safe_require("which-key")

if not wk then return end

wk.setup({
  icons = {
    mappings = false,
  },
  preset = 'helix',
})

