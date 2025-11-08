local helpers = require("utils.helpers")
local snacks = helpers.safe_require("snacks")
if not snacks then return end

-- Define which file types should the plguin be loaded.
local indent_line_filetypes = {
  "html", "css", "htmldjango",
  "javascript", "javascriptreact", "tsx", "typescript",
  "yaml*", "json", "jsonc", "yaml.ansible", "yml",
  "rust", "java", "c", "make", "go",
  "lua", "sh", "python", "ruby",
  "groovy", "terraform",
}

snacks.setup({
  bigfile = {
    enabled = true
  },
  indent = {
    enabled = false,
    indent = {
      char = "╎",
    },
    scope = {
      enabled = true,
      priority = 200,
      char = "╎",
      underline = false,
      only_current = false,
      hl = "SnacksIndentScope",
    },
    animate = {
      enabled = false
    }
  },
  input = {
    enabled = true
  },
  notifier = {
    enabled = true
  },
  quickfile = {
    enabled = true
  },

  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  picker = { enabled = false },
  scope = { enabled = false },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = indent_line_filetypes,
  callback = function()
    Snacks.indent.enable()
  end,
})

vim.g.snacks_scope = false
vim.keymap.set("n", "<leader>o", function()
  vim.g.snacks_scope = not vim.g.snacks_scope
  if vim.g.snacks_scope then
    vim.notify("indent scope enabled", vim.log.levels.INFO)
  else
    vim.notify("indent scope disabled", vim.log.levels.WARN)
  end
end, { desc = "Toggle my snack indent scope" })
