local helpers = require("utils.helpers")
local nvim_lint = helpers.safe_require("lint")

if not nvim_lint then return end

nvim_lint.linters_by_ft = {
  lua = { "luacheck" },
  sh = { "shellcheck" },
  -- yaml = { "yamllint" },
  -- markdown = { "write_good" },
}

vim.cmd[[autocmd FileType markdown,yaml nmap <leader>j :lua vim.diagnostic.goto_next({buffer=0})<CR>]]
vim.cmd[[autocmd FileType markdown,yaml nmap <leader>k :lua vim.diagnostic.goto_prev({buffer=0})<CR>]]
vim.cmd[[autocmd FileType markdown,yaml nmap <leader>l :lua vim.diagnostic.open_float()<CR>]]

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    nvim_lint.try_lint()
  end,
})
