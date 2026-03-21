local helpers = require("utils.helpers")
local gitblame = helpers.safe_require("gitblame")

if not gitblame then return end

gitblame.setup({
    enabled = false,
    message_template = " <summary> • <date> • <author>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 1,
})

vim.api.nvim_set_keymap("n", "<leader>gB", ":GitBlameToggle<CR>", { noremap = true, silent = false })
vim.g["gitblame_highlight_group"] = "@comment"
