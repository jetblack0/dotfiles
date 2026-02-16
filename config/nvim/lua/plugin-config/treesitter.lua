local helpers = require("utils.helpers")

local treesitter = helpers.safe_require("nvim-treesitter")
if not treesitter then return end

local ensure_installed = {
  "html", "css", "javascript", "typescript", "tsx",
  "json", "yaml",
  "markdown", "markdown_inline",
  "c", "rust", "java", "nasm",
  "go", "gotmpl",
  "bash", "lua",
  "helm", "groovy", "terraform",
  "python", "requirements", "htmldjango", "jinja", "jinja_inline"
}

treesitter.setup({
  install_dir = vim.fn.stdpath('data') .. '/treesitter'
})

local installed = treesitter.get_installed()
local to_install = vim
  .iter(ensure_installed)
  :filter(function(parser) return not vim.tbl_contains(installed, parser) end)
  :totable()

if #to_install > 0 then treesitter.install(to_install) end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("EnableTreesitterHighlighting", { clear = true }),
  desc = "Try to enable tree-sitter syntax highlighting",
  pattern = "*",
  callback = function()
    pcall(function() vim.treesitter.start() end)
  end,
})
