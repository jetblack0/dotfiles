local helpers = require("utils.helpers")
local nvimtree = helpers.safe_require("nvim-tree")
local nvimtree_api = helpers.safe_require("nvim-tree.api")

local keymap = vim.keymap.set

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = false, nowait = true }
  end

  nvimtree_api.config.mappings.default_on_attach(bufnr)
  keymap("n", "u", nvimtree_api.tree.change_root_to_parent, opts "Up")
  keymap("n", "w", function() nvimtree_api.tree.collapse_all({keep_buffers = true}) end, opts "Collapse keep buffer")
  keymap("n", "?", nvimtree_api.tree.toggle_help, opts "Help")
end

nvimtree.setup({
  on_attach = on_attach,
	hijack_cursor = true,
	disable_netrw = true,
	sort_by = "name",

	update_focused_file = {
		enable = false,
		update_root = false,
	},
	view = {
		preserve_window_proportions = true,
		cursorline = true,
	},
  filters = {
    dotfiles = true,
  },
	modified = {
		enable = true,
		show_on_dirs = true,
	},
	actions = {
    use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
		},
		open_file = {
			quit_on_open = true,
		}
	},
  git = {
    enable = true,
    ignore = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    timeout = 5000,
  },

	renderer = {
		symlink_destination = false,
		indent_width = 2,
		highlight_opened_files = "all",
		highlight_git = false,

		indent_markers = {
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
		icons = {
			webdev_colors = true,
			git_placement = "after",
			padding = " ",
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				git = true,
				modified = true,
			},
			glyphs = {
        default = "",
				symlink = "",
				bookmark = "",
        modified = "",
				-- folder = {
				-- 	arrow_closed = "",
				-- 	arrow_open = "",
				-- 	default = "",
				-- 	open = "ﱮ",
				-- 	empty = "",
				-- 	empty_open = "",
				-- 	symlink = "",
				-- 	symlink_open = "",
				-- },
				git = {
          unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "",
					untracked = "",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
})

local opts = { noremap = true, silent = true }
keymap("n", "<c-b>", ":NvimTreeToggle<CR>", opts)
keymap("i", "<c-b>", "<esc>:NvimTreeToggle<CR>", opts)
keymap("n", "F", function() nvimtree_api.tree.toggle({find_file = true, focus = false}) end, opts)

-- Open nvim-tree if is a direcotry, and cd into that
local function open_nvim_tree(data)
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  vim.cmd.cd(data.file)
  nvimtree_api.tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.cmd([[
  " :hi     NvimTreeNormal              guifg=#d5c4a1
  " :hi     NvimTreeOpenedFile          guifg=#ebdbb2
  :hi     NvimTreeFolderName          guifg=#83a598 cterm=bold gui=bold
  :hi     NvimTreeOpenedFolderName    guifg=#83a598 cterm=bold gui=bold
  :hi     NvimTreeEmptyFolderName     guifg=#83a598 cterm=bold gui=bold
  :hi     NvimTreeRootFolder          guifg=#d19097

]])
