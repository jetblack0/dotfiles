local helpers = require("utils.helpers")
local nvim_tmux_navigation = helpers.safe_require("nvim-tmux-navigation")

vim.keymap.set('n', "<C-h>", nvim_tmux_navigation.NvimTmuxNavigateLeft)
vim.keymap.set('n', "<C-j>", nvim_tmux_navigation.NvimTmuxNavigateDown)
vim.keymap.set('n', "<C-k>", nvim_tmux_navigation.NvimTmuxNavigateUp)
vim.keymap.set('n', "<C-l>", nvim_tmux_navigation.NvimTmuxNavigateRight)
vim.keymap.set('n', "<C-\\>", nvim_tmux_navigation.NvimTmuxNavigateLastActive)
vim.keymap.set('n', "<C-Space>", nvim_tmux_navigation.NvimTmuxNavigateNext)
