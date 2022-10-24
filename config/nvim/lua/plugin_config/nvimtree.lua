vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  -- auto_close = true,
  hijack_cursor = true,
  sort_by = "modification_time",
  view = {
    adaptive_size = false,
	width = 15,
	side = "left",
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    highlight_opened_files = "icon",
  },
  filters = {
    dotfiles = false,
  },
})
