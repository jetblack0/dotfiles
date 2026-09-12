local helpers = require("utils.helpers")
local mason = helpers.safe_require("mason")
local mason_lspconfig = helpers.safe_require("mason-lspconfig")
local mason_tool_installer = helpers.safe_require("mason-tool-installer")
local lsputils = helpers.safe_require('utils.lsp')

if not mason then return end
if not mason_lspconfig then return end

local mason_config = {
  ui = {
    border = "rounded",
    width = 0.5,
    height = 0.8,

    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },

    keymaps = {
      toggle_package_expand = "o",
      uninstall_package = "D",
      install_package = "I",
    },
  },
}

mason.setup(mason_config)
mason_lspconfig.setup({
	ensure_installed = lsputils.ensured_installed,
	automatic_installation = true,
})

if mason_tool_installer then
  mason_tool_installer.setup({ ensure_installed = lsputils.tools })
end

vim.api.nvim_set_keymap("n", "<leader>3", ":Mason<CR>", {
  desc = 'Open up Mason',
  noremap = true,
  silent = false
})
