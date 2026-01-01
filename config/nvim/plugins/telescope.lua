local helpers = require("utils.helpers")
local telescope = helpers.safe_require("telescope")
local telescope_built_in = helpers.safe_require("telescope.builtin") 

telescope.setup{
  -- NOTE: turn off treesitter hightlighting for preview, necessary for
  -- treesitter main branch.
	defaults = {
    preview = {
      treesitter = false,
    },
		mappings = {
			i = {
				["<c-h>"] = "which_key",
				["<a-j>"] = "move_selection_next",
				["<a-k>"] = "move_selection_previous",
				["<Tab>"] = "toggle_selection",
				["<a-Tab>"] = "toggle_selection",
        ["<c-y>"] = "preview_scrolling_up",
        ["<c-e>"] = "preview_scrolling_down",
        ["<c-u>"] = "results_scrolling_up",
        ["<c-d>"] = "results_scrolling_down",
				["<c-c>"] = false,
				-- ["<leader>c"] = "close",
				["<c-o>"] = "select_default",
			},
			n = {
				["<c-h>"] = "which_key",
				["<a-j>"] = "move_selection_next",
				["<a-k>"] = "move_selection_previous",
        ["<c-y>"] = "preview_scrolling_up",
        ["<c-e>"] = "preview_scrolling_down",
        ["<c-u>"] = "results_scrolling_up",
        ["<c-d>"] = "results_scrolling_down",
				["<Tab>"] = "toggle_selection",
				["<a-Tab>"] = "toggle_selection",
        ["<Esc>"] = "close",
				["<leader>c"] = "close",
				["<c-o>"] = "select_default",
			},
		}
	},
}

-- Keybindings
vim.keymap.set("n", "<leader>q", function()
	telescope_built_in.find_files({
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.8,
      height = 0.9,
      scroll_speed = 1,
      preview_cutoff = 26,
      vertical = {
        preview_height = 0.4,
      },
    }
  })
end, { desc = "Telescope fuzzy file finder" })

vim.keymap.set("n", "<leader>w", function()
	telescope_built_in.live_grep({
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.8,
      height = 0.8,
      scroll_speed = 1,
      preview_cutoff = 100,
      horizontal = {
        preview_width = 0.55,
      },
    }
  })
end, { desc = "Telescope live grep" })

vim.keymap.set("n", "<leader>e", function()
	telescope_built_in.builtin()
end, { desc = "Telescope function menu" })

vim.keymap.set("n", "<leader>r", function()
	telescope_built_in.command_history()
end, { desc = "Telescope command history" })

vim.keymap.set("n", "<leader>b", function()
	telescope_built_in.buffers()
end, { desc = "Telescope buffer selection menu" })


-- plugins
-- telescope.load_extension("ui-select")
