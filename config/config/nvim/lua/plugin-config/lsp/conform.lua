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
    nix = { "alejandra" },
    -- Uses OpenTofu's `tofu fmt` (canonical HCL, same output as
    -- `terraform fmt`). Doesn't rely on terraform-ls, which can't format
    -- without the `terraform` binary installed.
    terraform = { "tofu_fmt" },
    ["terraform-vars"] = { "tofu_fmt" },
  },
})

-- Keybindings.
vim.keymap.set("", "<leader>F", function() conform.format({ async = true, lsp_format = "fallback" }) end, {
  desc = "Conform format",
  noremap = true,
  silent = false
})
