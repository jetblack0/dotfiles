local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local my_sources = {
	-- for lua, the fixer and linter from lsp are slow
	formatting.stylua.with({
		filetypes = { "lua" }
	}),
	diagnostics.luacheck.with({
		filetypes = { "lua" }
	}),

	-- for bash script, i don't need a lsp for it
	diagnostics.shellcheck.with({
		filetypes = { "sh" }
	}),
	formatting.shfmt.with({
		filetypes = { "sh" }
	}),
}

null_ls.setup({
	debug = false,
    sources = my_sources
})
