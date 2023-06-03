local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local my_sources = {

	-- NOTE: All of them suck
	formatting.prettierd,
	-- formatting.eslint_d,
	-- code_actions.eslint_d,
	-- diagnostics.eslint_d,

	-- for lua, fixer and linter from lsp are slow
	formatting.stylua.with({
		filetypes = { "lua" },
	}),
	diagnostics.luacheck.with({
		filetypes = { "lua" },
	}),

	-- for bash script
	formatting.shfmt.with({
		filetypes = { "sh" },
	}),
}

null_ls.setup({
	debug = false,
	sources = my_sources,
})
