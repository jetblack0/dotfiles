vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = false,
	update_in_insert = true,
	severity_sort = true,
	float = {
		focusable = true,

    -- Available border values:
    -- none: No border.
    -- single: A single line box.
    -- double: A double line box.
    -- rounded: Like "single", but with rounded corners.
    -- solid: Adds padding by a single whitespace cell.
    -- shadow: A drop shadow effect by blending with the
		-- border = "none",

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
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })


-- Set color for diagnostic signs
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg='#eb6f92'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg='#f6c177'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg='#31748f'} )
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg='#83a598'} )

-- Set background color for the popup window 
vim.api.nvim_set_hl(0, 'NormalFloat', { bg='#393633'} )

