local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

nvim_tree.setup({
	-- Keeps the cursor on the first letter of the filename when moving in the tree.
	hijack_cursor = true,

	disable_netrw = true,
	sort_by = "name",

	-- UI rendering setup
	renderer = {
		indent_width = 2,
		highlight_opened_files = "all",

		-- Enable file highlight for git attributes using `NvimTreeGit*` highlight groups. This can be used with or without the icons.
		highlight_git = false,

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
				modified = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				bookmark = "",
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
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
		-- Whether to show the destination of the symlink.
		symlink_destination = false,
	},
	update_focused_file = {
		enable = true,
		-- Update the root directory of the tree if the file is not under current root directory.
		update_root = true,
	},
	-- Indicate which file have unsaved modification. (not worky?)
	modified = {
		enable = true,
		-- Show modified indication on directory whose children are modified.
		show_on_dirs = true,
	},
	actions = {
		change_dir = {
			-- Change the working directory when changing directories in the tree.
			enable = true,
			global = true,
		},
		open_file = {
			quit_on_open = true,
		}
	},
})
