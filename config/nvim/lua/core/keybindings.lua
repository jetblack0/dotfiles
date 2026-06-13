-- Keybindings for neovim. Note that some plugin specific 
-- keybindings are configured in the plugin-config
-- directory.
-- Use Control and Alt for nvim built-in functions.
-- Reserve the leader key for plugins.

local default_map_opts = { noremap = true, silent = true }
local function opt(desc, others)
  return vim.tbl_extend("force", default_map_opts, { desc = desc }, others or {})
end
local keymap = vim.keymap.set

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
vim.g.process_dir = vim.env.PWD
keymap("n", "gh", ":execute ':cd' process_dir<CR>", default_map_opts)
--- Go to the directory of the current buffer.
keymap("n", "gH", ":cd %:p:h<CR>", default_map_opts)

-- Copy a file:line reference to the system clipboard for sharing with AI agents.
-- Normal mode: ~/path/to/file
-- Visual mode: ~/path/to/file:L4:  (single line)  or  ~/path/to/file:L4-L7:  (range)
local function yank_file_ref(with_range)
  if vim.fn.expand("%:t") == "" then
    vim.notify("Buffer has no file", vim.log.levels.WARN)
    return
  end
  local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~")
  local ref = path
  if with_range then
    local s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then s, e = e, s end
    ref = s == e and string.format("%s:L%d:", path, s)
                  or string.format("%s:L%d-L%d:", path, s, e)
  end
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
end
keymap("n", "<leader>yp", function() yank_file_ref(false) end, opt("Copy file path to clipboard"))
keymap("x", "<leader>yp", function() yank_file_ref(true)  end, opt("Copy file path + line range to clipboard"))


-- Window and tabs
------------------
-- Create and navigate between tabs.
keymap({"n", "t"}, '<C-w><c-n>', function() vim.cmd.tabnext() end, default_map_opts)
keymap({"n", "t"}, '<C-w>n', function() vim.cmd.tabnext() end, default_map_opts)
keymap({"n", "t"}, '<C-n>', function() vim.cmd.tabnext() end, default_map_opts)
keymap("n", 'L', function() vim.cmd.tabnext() end, default_map_opts)
keymap({"n", "t"}, '<C-w><c-N>', function() vim.cmd.tabprevious() end, default_map_opts)
keymap({"n", "t"}, '<C-w>N', function() vim.cmd.tabprevious() end, default_map_opts)
keymap("n", '<C-p>', function() vim.cmd.tabprevious() end, default_map_opts)
keymap("n", 'H', function() vim.cmd.tabprevious() end, default_map_opts)
keymap({"n", "t"}, "<c-w>t", function() vim.cmd.tabnew() end, default_map_opts)
keymap({"n", "t"}, "<c-w><c-t>", function() vim.cmd.tabnew() end, default_map_opts)
for i = 1, 9 do
  keymap("n", "<C-w>" .. i, i .. "gt", opt("Go to the " .. i .. "th window"))
end


-- Splits
---------
-- Focus splits.
keymap({"n", "t"}, "<c-w>l", function() vim.cmd.wincmd("l") end, default_map_opts)
keymap({"n", "t"}, "<c-w>h", function() vim.cmd.wincmd("h") end, default_map_opts)
keymap({"n", "t"}, "<c-w>j", function() vim.cmd.wincmd("j") end, default_map_opts)
keymap({"n", "t"}, "<c-w>k", function() vim.cmd.wincmd("k") end, default_map_opts)

-- Resize splits.
keymap({"n", "t"}, "<c-w><c-l>", function() vim.cmd.wincmd("l") end, default_map_opts)
keymap({"n", "t"}, "<c-w><c-h>", function() vim.cmd.wincmd("h") end, default_map_opts)
keymap({"n", "t"}, "<c-w><c-j>", function() vim.cmd.wincmd("j") end, default_map_opts)
keymap({"n", "t"}, "<c-w><c-k>", function() vim.cmd.wincmd("k") end, default_map_opts)

keymap({"n", "t"}, "<a-h>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) - 3)
end, default_map_opts)

keymap({"n", "t"}, "<a-l>", function()
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, vim.api.nvim_win_get_width(win) + 3)
end, default_map_opts)

keymap({"n", "t"}, "<a-j>", function()
 local win = vim.api.nvim_get_current_win()
 vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) - 3)
end, default_map_opts)

keymap({"n", "t"}, "<a-k>", function()
  local win = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) + 3)
end, default_map_opts)


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



keymap("n", "K", "<Nop>", { noremap = true, silent = true })
keymap("n", "<c-w>q", "<Nop>", { noremap = true, silent = true })
vim.keymap.del('n', '<c-w>d')
vim.keymap.del('n', '<c-w><c-d>')
