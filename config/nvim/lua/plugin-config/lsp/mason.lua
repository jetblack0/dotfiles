local helpers = require("utils.helpers")
local mason = helpers.safe_require("mason")
local mason_lspconfig = helpers.safe_require("mason-lspconfig")

if not mason then return end
if not mason_lspconfig then return end

-- Define LSPs that Mason will automatically install.
local must_have_servers = {
	"rust_analyzer",
	"lua_ls", "bashls",
	"ts_ls", "html", "cssls", "jsonls",
	"ansiblels", "terraformls"
  -- "groovyls"
}

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
	ensure_installed = must_have_servers,
	automatic_installation = true,
})
