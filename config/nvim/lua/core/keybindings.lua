local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Set leader key as space
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "


-- Normal Mode ----------------------------------------
-- Spell check
keymap("n", "<F6>", ":set spell!<CR>", opts)
-- Toggle nvimtree
keymap("n", "<c-b>", ":NvimTreeToggle<CR>", opts)
-- Get rid of search highlight
keymap("n", "<esc><esc>", ":noh<CR>:echo \"\"<CR>", opts)
-- Toggle colorizer
keymap("n", "<leader>c", ":ColorizerToggle<CR>", opts)
-- Toggle and lualine
keymap("n", "<c-g>", ":lua require('lualine').hide()<CR> | :Goyo<CR> | :Gitsigns toggle_signs<CR>", opts)


-- Manage window (tmux style)
-- Resize split (try submode)
keymap("n", "<c-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<c-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<c-Up>", ":resize +2<CR>", opts)
keymap("n", "<c-Down>", ":resize -2<CR>", opts)
-- Change the position of splits (can not map to ctrl shift?)
keymap("n", "<c-a-l>", "<C-w><S-l>", opts)
keymap("n", "<c-a-h>", "<C-w><S-h>", opts)
keymap("n", "<c-a-k>", "<C-w><S-k>", opts)
keymap("n", "<c-a-j>", "<C-w><S-j>", opts)
-- Switch split
keymap("n", "<c-j>", "<c-w>w", opts)
keymap("n", "<c-k>", "<c-w><c-w>", opts)
-- full screen
keymap("n", "<c-.>", "<c-w>_<c-w>|", opts)
keymap("n", "<c-,>", "<c-w>=", opts)
-- Change tag
keymap("n", "<a-.>", "gt<CR>", opts)
keymap("n", "<a-,>", "gT<CR>", opts)

-- toggle markdown preview
keymap("n", "<leader>m", ":MarkdownPreviewToggle<CR>", opts)
-------------------------------------------------------


-- Virtual Mode ----------------------------------------
-- Keep in virual mode when indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- Move text up and down
keymap("v", "<a-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<a-k>", ":m '<-2<CR>gv=gv", opts)
-- Replace text when yank but don't copy these text
keymap("v", "p", "\"_dP", opts)
--------------------------------------------------------


-- Virtual Block ----------------------------------------
-- Move text up and down
keymap("x", "<a-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<a-k>", ":move '<-2<CR>gv-gv", opts)
--------------------------------------------------------


-- Command Mode ----------------------------------------
--------------------------------------------------------
