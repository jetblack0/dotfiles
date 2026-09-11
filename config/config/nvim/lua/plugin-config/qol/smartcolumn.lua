local helpers = require("utils.helpers")
local smartcolumn = helpers.safe_require("smartcolumn")

if not smartcolumn then return end

smartcolumn.setup({
  colorcolumn = "80",
  scope = "window",
  disabled_filetypes = {
    "help", "text", "markdown", "gitcommit",
    "cheatsheet", "checkhealth", "lazy", "mason", "man", "qf",
    "snacks_dashboard", "snacks_picker_list", "snacks_picker_input", "snacks_terminal",
  },
})
