local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Set leader key as space
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "


-- Normal Mode ----------------------------------------
-- Spell check
keymap("n", "<leader>s", ":set spell!<CR>", opts)
-- Toggle nvimtree
keymap("n", "<c-b>", ":NvimTreeToggle<CR>", opts)
-- Get rid of search highlight
keymap("n", "<esc><esc>", ":noh<CR>:echo \"\"<CR>", opts)


-- Manage window (awesome style)
-- Resize split (try submode)
keymap("n", "<a-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<a-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<a-k>", ":resize +2<CR>", opts)
keymap("n", "<a-j>", ":resize -2<CR>", opts)
-- Change the position of splits (can not map to ctrl shift?)
keymap("n", "<c-a-l>", "<C-w><S-l>", opts)
keymap("n", "<c-a-h>", "<C-w><S-h>", opts)
keymap("n", "<c-a-k>", "<C-w><S-k>", opts)
keymap("n", "<c-a-j>", "<C-w><S-j>", opts)
-- Switch split focus (handled by vim-tmux-navigator plugin)
-- keymap("n", "<c-j>", "<c-w>j", opts)
-- keymap("n", "<c-k>", "<c-w>k", opts)
-- keymap("n", "<c-h>", "<c-w>h", opts)
-- keymap("n", "<c-l>", "<c-w>l", opts)
-- full screen
keymap("n", "<c-.>", "<c-w>_<c-w>|", opts)
keymap("n", "<c-,>", "<c-w>=", opts)
-- Change tag
keymap("n", "<c-n>", "gt<CR>", opts)
keymap("n", "<c-p>", "gT<CR>", opts)
-- keymap("n", "<a-.>", "gt<CR>", opts)
-- keymap("n", "<a-,>", "gT<CR>", opts)

-- toggle markdown preview
keymap("n", "<leader>m", ":MarkdownPreviewToggle<CR>", opts)
-------------------------------------------------------


-- Insert mode ----------------------------------------
keymap("i", "<c-b>", "<esc>:NvimTreeToggle<CR>", opts)
-- Switch split focus (by default vim-tmux-navigator doesn't bind in insert mode)
keymap("i", "<c-l>", "<esc>:TmuxNavigateRight<CR>", opts)
keymap("i", "<c-h>", "<esc>:TmuxNavigateLeft<CR>", opts)
keymap("i", "<c-j>", "<esc>:TmuxNavigateDown<CR>", opts)
keymap("i", "<c-k>", "<esc>:TmuxNavigateUp<CR>", opts)


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


-- Other stuff ----------------------------------------
-- For null-ls
keymap("n", "<leader>f", ":lua vim.lsp.buf.format({ async = true })<CR>", opts)
keymap("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>q", ":lua vim.diagnostic.setloclist()<CR>", opts)
keymap("n", "<leader>j", ":lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
keymap("n", "<leader>k", ":lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
keymap("n", "<leader>l", ":lua vim.diagnostic.open_float()<CR>", opts)

-- Toggle cmp
keymap("n", "<leader>z", ":lua require('cmp').setup.buffer { enabled = false }<CR>", opts)
keymap("n", "<leader>x", ":lua require('cmp').setup.buffer { enabled = true }<CR>", opts)

-- Live servers
-- TODO: add a keybinding to toggle live-server if current directory has a index.html file
