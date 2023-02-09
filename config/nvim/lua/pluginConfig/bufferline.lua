local neoscroll_status_ok, bufferline = pcall(require, "bufferline")
if not neoscroll_status_ok then
	return
end

bufferline.setup({
	options = {
		mode = "tabs", -- set to "tabs" to only show tabpages instead
		numbers = "none",
		close_command = nil,
		right_mouse_command = nil,
		left_mouse_command = nil,
		middle_mouse_command = nil,
		buffer_close_icon = nil,
		modified_icon = "●",
		close_icon = nil,
		left_trunc_marker = nil,
		right_trunc_marker = nil,
		diagnostics = false,

		custom_filter = function(buf_number, buf_numbers)
			-- filter out filetypes you don't want to see
			if vim.bo[buf_number].filetype == "NvimTree" then
				return false
			end
		end,

		color_icons = true, -- whether or not to add the filetype icon highlights
		separator_style =  "thin",
		always_show_bufferline = false,
		hover = {
			enabled = false,
		},
	},
})
