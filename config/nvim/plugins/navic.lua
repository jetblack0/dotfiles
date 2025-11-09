local helpers = require("utils.helpers")
local navic = helpers.safe_require("nvim-navic")

if not navic then return end

navic.setup({
  lazy = true,
  opts = {
    highlight = true,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
})

