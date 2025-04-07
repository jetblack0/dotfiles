-- LSP server configuration and keybindings.
local helpers = require("utils.helpers")
local lspconfig = helpers.safe_require("lspconfig")
local cmp_nvim_lsp = helpers.safe_require("cmp_nvim_lsp")
local nvim_navic = helpers.safe_require("nvim-navic")


---------------------
-- LSP configurations
---------------------
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	lsp_keybind(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
  if client.server_capabilities.documentSymbolProvider then
    nvim_navic.attach(client, bufnr)
  end
end

lsp_keybind = function(client, bufnr)
	-- Keep LSP keys at the same row on the keyborad.
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "<leader>j", function() vim.diagnostic.goto_next({buffer=0}) end, bufopts)
	vim.keymap.set("n", "<leader>k", function() vim.diagnostic.goto_prev({buffer=0}) end, bufopts)
	vim.keymap.set("n", "<leader>l", function() vim.diagnostic.open_float() end, bufopts)
  -- NOTE: Formatter keys are configured through conform.lua.
	-- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({async=true}) end, bufopts)
	vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, bufopts)

	vim.keymap.set("n", "<leader>H", vim.lsp.buf.signature_help, bufopts)
  -- NOTE: DO NOT SET LEADER KEY IN INSERT MODE!
	vim.keymap.set("i", "<a-m>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>g", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, bufopts)
	-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
	-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	-- vim.keymap.set("n", "<leader>wl", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts)
end



---------------------------------
-- Server specific configurations
---------------------------------
-- Complied languages
---------------------
-- Rust
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
      diagnostics = {
        enable = true;
      }
		},
	},
	capabilities = capabilities,
  on_attach = on_attach,
})

-- Java
-- lspconfig.jdtls.setup({
-- 	on_attach = function(client, bufnr)
-- 		lsp_keybind(client, bufnr)
-- 		-- lsp_signature_setup(client, bufnr)
-- 	end,
-- 	root_dir = lspconfig.util.root_pattern("pom.xml", "build.gradle", ".git") or vim.fn.getcwd(),
-- 	capabilities = capabilities,
-- })


-- Interpreted languages
------------------------
-- lua
-- NOTE: Sluggish, do not recommend
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
	end,
  -- on_attach = on_attach,
	capabilities = capabilities,
})

-- Bash
lspconfig.bashls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})


-- Markup languages
-------------------
-- Typescript and Javascript
lspconfig.ts_ls.setup({
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

-- HTML/CSS
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

-- CSS
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

-- JSON
lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		lsp_keybind(client, bufnr)
	end,
})

-- Markdown
-- NOTE: No completion for some reason. I am looking
-- for code snippet for table, list and something
-- similar.
--[[ -- lspconfig.marksman.setup({
-- 	capabilities = capabilities,
-- 	on_attach = function(client, bufnr)
-- 		client.server_capabilities.documentFormattingProvider = false
-- 		lsp_keybind(client, bufnr)
-- 	end,
-- }) ]]
