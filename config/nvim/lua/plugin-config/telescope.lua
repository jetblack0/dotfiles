local telescope_status_ok, telescope = pcall(require, "telescope")
if not telescope_status_ok then
	return
end

telescope.setup{
	defaults = {
		mappings = {
			i = {
				["<c-h>"] = "which_key",
				["<a-j>"] = "move_selection_next",
				["<a-k>"] = "move_selection_previous",
				["<Tab>"] = "toggle_selection",
				["<a-Tab>"] = "toggle_selection",
				["<c-c>"] = "close",
				["<c-o>"] = "select_default",
			},
			n = {
				["<c-h>"] = "which_key",
				["<a-j>"] = "move_selection_next",
				["<a-k>"] = "move_selection_previous",
				["<Tab>"] = "toggle_selection",
				["<a-Tab>"] = "toggle_selection",
				["<c-c>"] = "close",
				["<c-o>"] = "select_default",
			},
		}
	},
}


local builtin = require('telescope.builtin')
vim.keymap.set("n", "<c-e>", function()
	builtin.builtin()
end, { desc = "Telescope function menu" })

vim.keymap.set("n", "<c-r>", function()
	builtin.find_files({
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.8,              -- this means 80% of the terminal
      height = 0.9,
      preview_cutoff = 26,      -- minimum height before preview is hidden
      vertical = {
        preview_height = 0.4,
      },
    }
  })
end, { desc = "Telescope fuzzy file finder" })

vim.keymap.set("n", "<c-s>", function()
	builtin.live_grep({
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.8,
      height = 0.8,
      preview_cutoff = 100,
      horizontal = {
        preview_width = 0.55,
      },
    }
  })
end, { desc = "Telescope live grep" })
