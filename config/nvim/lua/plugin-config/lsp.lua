-- luacheck: globals vim

------------------------------------------ keybindings when attach to a server -----------------------------------------
local lsp_keybind = function(client, bufnr)
	-- NOTE: null-ls doesn't use these binding
	-- Mappings
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>H", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
end
------------------------------------------ keybindings when attach to a server -----------------------------------------

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	lsp_keybind(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
end

-------------------------- config for nvim-signature plugin (only attach to some servers) ------------------------------
-- local signature_config = {
-- 	doc_lines = 0,
-- 	floating_window = true,
-- 	floating_window_above_cur_line = false,
-- 	handler_opts = {
-- 		border = "rounded",
-- 	},
-- 	close_timeout = 400,
-- 	hint_enable = false,
-- 	transparency = 100,
-- }
--
-- local function lsp_signature_setup(client, bufnr)
-- 	local status_lsp_signature_ok, lsp_signature = pcall(require, "lsp_signature")
-- 	if not status_lsp_signature_ok then
-- 		return
-- 	end
-- 	lsp_signature.on_attach(signature_config, bufnr)
-- end
-------------------------- config for nvim-signature plugin (only attach to some servers) ------------------------------




----------------------------------------------- mason to manage servers ------------------------------------------------
-- NOTE: formatter and linter need to install manually
local must_have_servers = {
	"rust_analyzer",
	"lua_ls",
	"tsserver",
	"html",
	"cssls",
	"jsonls",
	"bashls"
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
        },
    },
}

require("mason").setup(mason_config)
require("mason-lspconfig").setup({
	ensure_installed = must_have_servers,
	automatic_installation = true,
})
----------------------------------------------- mason to manage servers ------------------------------------------------


----------------------------------------------- config for each servers ------------------------------------------------
local status_lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not status_lspconfig_ok then
	return
end

-- rust_analyzer for rust
lspconfig.rust_analyzer.setup({
	root_dir = lspconfig.util.root_pattern("Cargo.toml"),
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = false,
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
		},
	},
	-- on_attach = on_attach,
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		lsp_keybind(client, bufnr)
		-- lsp_signature_setup(client, bufnr)
	end,
})

-- sumneko_lua for lua
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				-- version = "Lua 5.4.4",
				version = "LuaJIT",
				path = {
					"?/init.lua",
					"?.lua",
				},
			},
			workspace = {
				library = {
					"/usr/share/nvim/runtime/lua",
					"/usr/share/nvim/runtime/lua/lsp",
					-- "/usr/share/awesome/lib",
				},
			},
			completion = {
				enable = true,
			},
			diagnostics = {
				enable = false,
				globals = { "vim", "awesome", "client", "root" },
			},
			telemetry = {
				enable = false,
			},
		},
	},

	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
		-- lsp_signature_setup(client, bufnr)
	end,
	capabilities = capabilities,
})

-- jdtls for Java
-- lspconfig.jdtls.setup({
-- 	on_attach = function(client, bufnr)
-- 		lsp_keybind(client, bufnr)
-- 		-- lsp_signature_setup(client, bufnr)
-- 	end,
-- 	root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git") or vim.fn.getcwd(),
-- 	capabilities = capabilities,
-- })

-- web development (just some simple html, css and js)
-- tsserver for javascript
lspconfig.tsserver.setup({
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	init_options = {
		hostInfo = "neovim",
	},
	root_dir = function()
		return vim.loop.cwd()
	end,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
	end,
	capabilities = capabilities,
})

-- vscode-langservers-extracted for html and css
lspconfig.html.setup({
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	single_file_support = true,
	capabilities = capabilities,
	-- on_attach = on_attach,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
	end,
})

lspconfig.cssls.setup({
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	settings = {
		css = {
			validate = true,
		},
		less = {
			validate = true,
		},
		scss = {
			validate = true,
		},
	},
	single_file_support = true,
	capabilities = capabilities,
	-- on_attach = on_attach,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
	end,
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
	end,
})

lspconfig.bashls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

----------------------------------------------- config for each servers ------------------------------------------------


-------------------------------------------------- nvim lsp UI config --------------------------------------------------
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = false,
	update_in_insert = true,
	severity_sort = true,
	float = {
		focusable = true,
		border = "rounded",
		-- source = "always", -- show where the message come from
		style = "minimal",
		prefix = "",
		-- header = "", -- show the header in the diagnostics window
	},
})

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- border shape for some window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
-------------------------------------------------- nvim lsp UI config --------------------------------------------------

return M
