local helpers = require("utils.helpers")
local nvim_lint = helpers.safe_require("lint")

if not nvim_lint then return end

nvim_lint.linters_by_ft = {
  nix = { "statix" },
  -- lua = { "luacheck" },
  groovy = { "npm-groovy-lint" },
  -- sh = { "shellcheck" },
  -- yaml = { "yamllint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    nvim_lint.try_lint()
  end,
})
