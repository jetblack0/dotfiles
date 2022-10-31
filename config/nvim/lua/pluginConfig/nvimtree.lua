local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

nvim_tree.setup({
	-- Completely disable netrw
	disable_netrw = true,
	-- Hijack netrw windows (overridden if |disable_netrw| is `true`)
	hijack_netrw = false,
	-- Will automatically open the tree when running setup if startup buffer is a directory, is empty or is unnamed. nvim-tree window will be focused.
	open_on_setup = true,
	-- Will automatically open the tree when running setup if startup buffer is a file.
	open_on_setup_file = false,
	-- Will ignore the buffer, when deciding to open the tree on setup.
	ignore_buffer_on_setup = false,
	-- List of filetypes or buffer names that will prevent `open_on_tab` to open.
	ignore_buf_on_tab_change = {},
	-- Reloads the explorer every time a buffer is written to.
	auto_reload_on_write = true,
	-- Creating a file when the cursor is on a closed folder will set the path to be inside the closed folder, otherwise the parent folder.
	create_in_closed_folder = false,
	-- Keeps the cursor on the first letter of the filename when moving in the tree.
	hijack_cursor = false,
	-- Opens in place of the unnamed buffer if it's empty.
	hijack_unnamed_buffer_when_opening = false,
	open_on_tab = false,
	-- Changes how files within the same directory are sorted.
	sort_by = "modification_time",
	-- Preferred root directories. Only relevant when `update_focused_file.update_root` is `true`
	root_dirs = {},
	-- Prefer startup root directory when updating root directory of the tree. Only relevant when `update_focused_file.update_root` is `true`
	prefer_startup_root = false,
	-- Changes the tree root directory on `DirChanged` and refreshes the tree. (root of tree will change when type cd in vim)
	sync_root_with_cwd = false,
	-- Automatically reloads the tree on `BufEnter` nvim-tree.
	reload_on_bufenter = true,
	-- Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree. (the root of tree will keep same on the current buffer)
	respect_buf_cwd = false,
	-- Function ran when creating the nvim-tree buffer.
	on_attach = "disable",
	-- This can be used to remove the default mappings in the tree.
	remove_keymaps = false,
	select_prompts = false,
	view = {
		-- Resize the window on each draw based on the longest line.
		adaptive_size = true,
		centralize_selection = false,
		-- Width of the window, can be a `%` string, a number representing columns or a function.
		width = 30,
		-- Hide the path of the current working directory on top of the tree.
		hide_root_folder = false,
		side = "left",
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		-- Show diagnostic sign column. Value can be `"yes"`, `"auto"`, `"no"`.
		signcolumn = "yes",
		mappings = {
			custom_only = false,
			list = {
				-- TODO: keybindings to jump to the root?

				-- default keybindings for cd is <c-]>, it still exists, remap for something useful
				{ key = "<c-[>", action = "cd" },
			},
		},
		-- Configuration options for floating window
		float = {
			enable = false,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},

	-- UI rendering setup
	renderer = {
		-- Appends a trailing slash to folder names.
		add_trailing = false,
		-- Compact folders that only contain a single folder into one node in the file tree.
		group_empty = false,
		-- Enable file highlight for git attributes using `NvimTreeGit*` highlight groups. This can be used with or without the icons.
		highlight_git = false,
		full_name = false,
		-- Highlight icons and/or names for opened files. Value can be `"none"`, `"icon"`, `"name"` or `"all"`.
		highlight_opened_files = "all",
		root_folder_modifier = ":~",
		-- Number of spaces for an each tree nesting level. Minimum 1.
		indent_width = 2,

		-- Configuration options for tree indent markers.
		indent_markers = {
			-- Display indent markers when folders are open
			enable = false,
			inline_arrows = true,
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
			git_placement = "before",
			padding = " ",
			symlink_arrow = " ➛ ",
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
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
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		-- Whether to show the destination of the symlink.
		symlink_destination = true,
	},
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	update_focused_file = {
		enable = false,
		update_root = false,
		ignore_list = {},
	},
	-- List of filetypes that will prevent `open_on_setup` to open.
	ignore_ft_on_setup = {},
	system_open = {
		cmd = "",
		args = {},
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
		debounce_delay = 50,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filters = {
		dotfiles = false,
		custom = {},
		exclude = {},
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
	},
	git = {
		enable = true,
		ignore = true,
		show_on_dirs = true,
		timeout = 400,
	},
	actions = {
		use_system_clipboard = true,
		-- vim |current-directory| behaviour.
		change_dir = {
			-- Change the working directory when changing directories in the tree.
			enable = false,
			-- Turn on sync_root_with_cwd and enable option above to sync cwd between nvim tree and nvim
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = true,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
	trash = {
		cmd = "gio trash",
		require_confirm = true,
	},
	live_filter = {
		prefix = "[FILTER]: ",
		always_show_folders = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			dev = false,
			diagnostics = false,
			git = false,
			profile = false,
			watcher = false,
		},
	},
})
