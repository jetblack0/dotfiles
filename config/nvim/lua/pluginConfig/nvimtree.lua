local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup({
	-- Keeps the cursor on the first letter of the filename when moving in the tree.
	hijack_cursor = true,

	disable_netrw = false,
	-- Will automatically open the tree when running setup if startup buffer is a directory, is empty or is unnamed. nvim-tree window will be focused.
	open_on_setup = true,
	sort_by = "name",
	-- This can be used to remove the default mappings in the tree.
	remove_keymaps = false,

	-- UI rendering setup
	renderer = {
		indent_width = 2,

		-- Enable file highlight for git attributes using `NvimTreeGit*` highlight groups. This can be used with or without the icons.
		highlight_git = true,

		-- Configuration options for tree indent markers.
		indent_markers = {
			-- Display indent markers when folders are open
			enable = true,
			inline_arrows = false,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
		-- Configuration options for icons.
		icons = {
			webdev_colors = true,
			git_placement = "after",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				git = false,
				modified = false,
			},
			glyphs = {
				default = "",
				symlink = "",
				bookmark = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "", --  
					open = "ﱮ", -- ﱮ 
					empty = "",
					empty_open = "", -- 
					symlink = "",
					symlink_open = "",
				},
				-- These git symbols are kinda confused here
				git = {
					unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "➜",
					untracked = "",
					deleted = "",
					ignored = "",
				},
			},
		},
		-- Whether to show the destination of the symlink.
		symlink_destination = true,
	},
})
