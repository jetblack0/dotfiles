local indent_blankline_ok, ibl = pcall(require, "ibl")
if not indent_blankline_ok then
	return
end

ibl.setup {
	indent = { char = "╎" },
	scope = { enabled = false },
}
