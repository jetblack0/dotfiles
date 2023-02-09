-- luacheck: globals vim

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<a-l>", vim.diagnostic.open_float, bufopts)
	vim.keymap.set("n", "<a-k>", vim.diagnostic.goto_prev, bufopts)
	vim.keymap.set("n", "<a-j>", vim.diagnostic.goto_next, bufopts)
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, bufopts)

	vim.keymap.set("n", "<a-h>", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	-- <c-i> and <c-o> to get back
	vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end


local signature_setup = {
	-- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
	-- set to 0 if you DO NOT want any API comments be shown
	-- This setting only take effect in insert mode, it does not affect signature help in normal mode
	doc_lines = 0,

	-- show hint in a floating window, set to false for virtual text only mode
	floating_window = true,

	-- try to place the floating above the current line when possible
	-- Note: will set to true when fully tested, set to false will use whichever side has more space
	-- this setting will be helpful if you do not want the PUM and floating win overlap
	floating_window_above_cur_line = false,

	handler_opts = {
		border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
	},

	close_timeout = 400, -- close floating window after ms when laster parameter is entered

	-- virtual hint enable
	hint_enable = false,

	-- disabled by default, allow floating win transparent value 1~100
	transparency = 100,
}

local function lsp_signature_on_attach(client, bufnr)
	require "lsp_signature".on_attach(signature_setup, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- each servers
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
		on_attach(client, bufnr)
		lsp_signature_on_attach(client, bufnr)
	end,
})

-- sumneko_lua for lua
lspconfig.sumneko_lua.setup({
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
		on_attach(client, bufnr)
		lsp_signature_on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

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
		on_attach(client, bufnr)
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
		on_attach(client, bufnr)
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
		on_attach(client, bufnr)
	end,
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configuration for general lsp diagnostic
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		focusable = false,
		border = "rounded",
		-- source = "always", -- show where the message come from
		style = "minimal",
		prefix = "",
		-- header = "", -- show the header in the diagnostics window
	},
})

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.diagnostic.disable()

-- border shape for some window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
