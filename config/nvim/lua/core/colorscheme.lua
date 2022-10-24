local colorscheme = "catppuccin"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	-- message doesn't show up
	print("colorscheme" .. colorscheme .. "not found!")
	return
end
