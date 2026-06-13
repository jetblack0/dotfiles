local helpers = require("utils.helpers")
local smart_splits = helpers.safe_require("smart-splits")

smart_splits.setup({
  disable_multiplexer_nav_when_zoomed = false,
  -- nil = auto-detect (resolves to 'tmux' inside tmux); false = disabled.
  -- Set SMART_SPLITS_DISABLE=1 to opt out (e.g. on ssh sessions).
  multiplexer_integration = os.getenv("SMART_SPLITS_DISABLE") == "1" and false or nil,
})

-- vim.keymap.set({ 'n', 't' }, '<a-1>', smart_splits.resize_left)
-- vim.keymap.set({ 'n', 't' }, '<a-2>', smart_splits.resize_down)
-- vim.keymap.set({ 'n', 't' }, '<a-3>', smart_splits.resize_up)
-- vim.keymap.set({ 'n', 't' }, '<a-4>', smart_splits.resize_right)
-- moving between splits
vim.keymap.set({ 'n', 't' }, '<C-h>', smart_splits.move_cursor_left)
vim.keymap.set({ 'n', 't' }, '<C-j>', smart_splits.move_cursor_down)
vim.keymap.set({ 'n', 't' }, '<C-k>', smart_splits.move_cursor_up)
vim.keymap.set({ 'n', 't' }, '<C-l>', smart_splits.move_cursor_right)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><a-h>', smart_splits.swap_buf_left)
vim.keymap.set('n', '<leader><a-j>', smart_splits.swap_buf_down)
vim.keymap.set('n', '<leader><a-k>', smart_splits.swap_buf_up)
vim.keymap.set('n', '<leader><a-l>', smart_splits.swap_buf_right)

vim.keymap.set("x", "<a-j>", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "<a-k>", ":move '<-2<CR>gv-gv")
vim.keymap.set("v", "<a-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<a-k>", ":m '<-2<CR>gv=gv")
