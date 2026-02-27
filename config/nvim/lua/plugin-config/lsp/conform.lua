local helpers = require("utils.helpers")
local conform = helpers.safe_require("conform")
if not conform then return end

conform.setup({
  formatters_by_ft = {
    -- Each filetype can have multiple formatters, which will be
    -- executed sequentially.
    lua = { "stylua" },
    sh = { "shfmt" },
    ruby = { "rubyfmt" },
    python = {
      -- 'ruff_fix',
      'ruff_format',
    },
    -- groovy = { "npm-groovy-lint" },
  },
})

-- Keybindings.
local opts = { noremap = true, silent = false }
vim.keymap.set("n", "<leader>F", function() conform.format({ lsp_fallback = true }) end, opts)
