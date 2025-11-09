local helpers = require("utils.helpers")
local mason = helpers.safe_require("mason")
local mason_lspconfig = helpers.safe_require("mason-lspconfig")

if not mason then return end
if not mason_lspconfig then return end

-- Define LSPs that Mason will automatically install.
local must_have_servers = {
  -- Devs
	"rust_analyzer",
	"lua_ls", "bashls", "basedpyright",
	"ts_ls", "html", "cssls", "jsonls",

  -- Ops
	"ansiblels", "terraformls", "dockerls",
  "docker_compose_language_service", "yamlls",
  "groovyls", "nginx_language_server"
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

vim.api.nvim_set_keymap("n", "<leader>3", ":Mason<CR>", { noremap = true, silent = false })
