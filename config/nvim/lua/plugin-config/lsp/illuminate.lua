local helpers = require("utils.helpers")
local illuminate = helpers.safe_require("illuminate")
if not illuminate then return end

illuminate.configure({
    providers = {
      'lsp',
      'treesitter',
    },
    delay = 300,
    filetypes_denylist = {
      "dirvish",
      "fugitive",
      "NvimTree",
      "packer",
      "Netrw",
    },
    under_cursor = false,
})
