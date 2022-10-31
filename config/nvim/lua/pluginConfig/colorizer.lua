local colorizer_status_ok, colorizer = pcall(require, "colorizer")
if not colorizer_status_ok then
	return
end

-- I didn't require this file, just use keybindings to use it
colorizer.setup({})
