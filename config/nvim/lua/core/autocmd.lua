-- Highlight a selection on yank
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=250}]]

-- Disables automatic commenting on newline:
vim.cmd[[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]]

-- Save and load view automatically
vim.cmd[[
augroup remember_folds
	autocmd!
	autocmd BufWinLeave *.* mkview
	autocmd BufWinEnter *.* silent! loadview
augroup END]]

-- Two space for html and yuck file
vim.cmd[[autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType yuck setlocal expandtab shiftwidth=2 tabstop=2]]

-- Treat ejs as html
vim.cmd[[au BufNewFile,BufRead *.ejs set filetype=html]]

-- Open nvim-tree if is a direcotry, and cd into that
local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
