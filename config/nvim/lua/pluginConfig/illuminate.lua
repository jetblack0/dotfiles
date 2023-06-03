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

vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#F5C2E7" })
vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#F5C2E7" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#F5C2E7" })
