-- System
---------
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


-- System-specific
------------------
-- Change fcitx5 input to english when press escape.
-- vim.cmd[[let fcitx5state=system("fcitx5-remote")]]
-- vim.cmd[[autocmd InsertLeave * :silent let fcitx5state=system("fcitx5-remote")[0] | silent !fcitx5-remote -c]]
-- vim.cmd[[autocmd InsertEnter * :silent if fcitx5state == 2 | call system("fcitx5-remote -o") | endif]]


-- Programming languages
------------------------
-- Change indentation width based on their file types.
vim.cmd[[autocmd FileType html,text,yuck,json,javascript,javascriptreact,lua,xml setlocal expandtab shiftwidth=2 tabstop=2]]
vim.cmd[[autocmd FileType markdown,java setlocal expandtab shiftwidth=4 tabstop=4]]

-- Treat ejs as html
vim.cmd[[au BufNewFile,BufRead *.ejs set filetype=html]]

-- Detect go template files.
vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})
