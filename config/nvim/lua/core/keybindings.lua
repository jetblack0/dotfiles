-- Keybindings for neovim. Note that some plugin specific 
-- keybindings are configured in the plugin-config
-- directory.
-- Principle: Use Control and Alt for nvim built-in functions.
-- Reserve the leader key for plugins.

local default_map_opts = { noremap = true, silent = false }
local keymap = vim.api.nvim_set_keymap

-- Use space key as the leader key. 
keymap("", "<Space>", "<Nop>", default_map_opts)
vim.g.mapleader = " "

----------------------------------
-- Normal Mode -------------------
----------------------------------

-- System
---------
-- Use capital U as redo 
keymap("n", "U", ":redo<CR>", default_map_opts)
-- Open spell check.
keymap("n", "<leader>s", ":set spell!<CR>", default_map_opts)
-- Press escape twice to get rid of search highlight.
keymap("n", "<leader><leader>", ":noh<CR>:echo \"\"<CR>", default_map_opts)
-- Records the working directory of nvim, and return home. vim doesn't
-- override its working directory in its process table. Quite useful for
-- Telescope.
vim.g.process_dir = vim.env.PWD
keymap("n", "gh", ":execute ':cd' process_dir<CR>", default_map_opts)
-- Go to the directory of the current buffer.
keymap("n", "gH", ":cd %:p:h<CR>", default_map_opts)
-- Open Netrw in my wiki directory in a new tab for quickly access  
-- my notes.

-- Window and tabs
------------------
-- Create and navigate between tabs.
keymap("n", "<c-w>n", "gt<CR>", default_map_opts)
keymap("n", "<c-w>N", "gT<CR>", default_map_opts)
keymap("n", "<c-w>t", ":tabnew<CR>", default_map_opts)


-- Splits
---------
-- Resize splits.
keymap("n", "<a-h>", ":vertical resize -3<CR>", default_map_opts)
keymap("n", "<a-l>", ":vertical resize +3<CR>", default_map_opts)
keymap("n", "<a-j>", ":resize -3<CR>", default_map_opts)
keymap("n", "<a-k>", ":resize +3<CR>", default_map_opts)

-- Split full screen.
keymap("n", "<a-.>", "<c-w>_<c-w>|", default_map_opts)
keymap("n", "<a-/>", "<c-w>=", default_map_opts)


-- Netrw
--------
keymap("n", "<c-b>", ":Lexplore<CR>", default_map_opts)
vim.cmd[[
augroup NetrwMappings
  autocmd!
  autocmd FileType netrw nmap <buffer> o <Enter>
  autocmd FileType netrw nmap <buffer> <C-v> v <Enter>
  autocmd FileType netrw nmap <buffer> <C-t> t <Enter>
  autocmd FileType netrw nmap <buffer> a C%:let g:netrw_chgwin=-1<Enter>
augroup END
]]


-- Folding
----------
-- NOTE: maybe map them to something else someday.
-- zf{motion}	Create a fold over a range
-- zd	Delete the fold at cursor
-- zE	Delete all folds in the buffer
-- zo	Open the fold under the cursor
-- zc	Close the fold under the cursor
-- za	Toggle the fold under the cursor
-- zR	Open all folds
-- zM	Close all folds



----------------------------------
-- Virtual Mode ------------------
----------------------------------

-- Keep in virual mode when indenting lines
keymap("v", "<", "<gv", default_map_opts)
keymap("v", ">", ">gv", default_map_opts)
-- Move text up and down
keymap("v", "<a-j>", ":m '>+1<CR>gv=gv", default_map_opts)
keymap("v", "<a-k>", ":m '<-2<CR>gv=gv", default_map_opts)
-- Replace text when yank but don't copy these text
keymap("v", "p", "\"_dP", default_map_opts)



----------------------------------
-- Virtual Block Mode ------------
----------------------------------

-- Move text up and down
keymap("x", "<a-j>", ":move '>+1<CR>gv-gv", default_map_opts)
keymap("x", "<a-k>", ":move '<-2<CR>gv-gv", default_map_opts)
