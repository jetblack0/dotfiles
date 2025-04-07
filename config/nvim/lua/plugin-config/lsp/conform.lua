local helpers = require("utils.helpers")
local conform = helpers.safe_require("conform")
if not conform then return end

conform.setup({
  formatters_by_ft = {
    -- Each filetype can have multiple formatters, which will be
    -- executed sequentially.
    lua = { "stylua" },
    sh = { "shfmt" },
  },
})

-- Keybindings.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", function() conform.format() end, opts)
