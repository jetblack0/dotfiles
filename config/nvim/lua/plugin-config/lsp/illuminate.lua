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

vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#45475A" })
vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#45475A" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#45475A" })

-- NOTE: By default keymaps <a-n> and <a-p> are added to move between references. 

