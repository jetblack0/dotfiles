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

-- Two space for some file types
vim.cmd[[autocmd FileType java setlocal expandtab shiftwidth=4 tabstop=4]]
vim.cmd[[autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType yuck setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType markdown setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType javascriptreact setlocal expandtab shiftwidth=2 tabstop=2]]

-- Treat ejs as html
vim.cmd[[au BufNewFile,BufRead *.ejs set filetype=html]]

-- Open nvim-tree if is a direcotry, and cd into that
local function open_nvim_tree(data)

  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  vim.cmd.cd(data.file)

  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Hide nvimtree cursor since we have better cursor line to use
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local def = vim.api.nvim_get_hl_by_name('Cursor', true)
    vim.api.nvim_set_hl(0, 'Cursor', vim.tbl_extend('force', def, { blend = 100 }))
    vim.opt.guicursor:append('a:Cursor/lCursor')
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'WinClosed' }, {
  pattern = 'NvimTree*',
  callback = function()
    local def = vim.api.nvim_get_hl_by_name('Cursor', true)
    vim.api.nvim_set_hl(0, 'Cursor', vim.tbl_extend('force', def, { blend = 0 }))
    vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
  end,
})

-- Change fcitx5 input method to english when press escape
vim.cmd[[let fcitx5state=system("fcitx5-remote")]]
vim.cmd[[autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c]]
vim.cmd[[autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif]]
