local cmp_status_ok, illuminate = pcall(require, "illuminate")
if not cmp_status_ok then
	return
end

illuminate.configure({
    providers = {
        'lsp',
        'treesitter',
    },
    delay = 300,
    filetypes_denylist = {
        "dirvish",
        "fugitive",
		"NvimTree",
		"packer",
    },
    under_cursor = false,
})

vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#45475A"})
vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#45475A"})
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#45475A"})
