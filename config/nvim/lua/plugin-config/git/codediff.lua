local helpers = require("utils.helpers")
local codediff = helpers.safe_require("codediff")

if not codediff then return end

codediff.setup({
  keymaps = {
    view = {
      quit = "q",
      toggle_explorer = "<c-b>",
      next_hunk = "<leader>gn",
      prev_hunk = "<leader>gN",
      show_help = "<leader>g?",
    },
    explorer = {
      select = "o",
      toggle_staged = "s",
      toggle_changes = "c",
      toggle_view_mode = "i",
      restore = "X",
    },
    history = {
      select = "o",
      toggle_view_mode = "i",
    },
    conflict = {
      next_conflict = "<leader>gn",
      prev_conflict = "<leader>gN",
      accept_incoming = "<leader>ct",
      accept_current = "<leader>co",
      accept_both = "<S-CR>",
      discard = "<ESC>",
      discard_all = "<S-ESC>",
    }
  },
})

local default_map_opts = { noremap = true, silent = false }
local function opt(desc, others)
  return vim.tbl_extend("force", default_map_opts, { desc = desc }, others or {})
end
local keymap = vim.keymap.set

keymap("n", "<leader>gd", ":CodeDiff<CR>", opt("Codediff on HEAD"))

local default_map_opts = { noremap = true, silent = false }
local function opt(desc, others)
  return vim.tbl_extend("force", default_map_opts, { desc = desc }, others or {})
end
local keymap = vim.keymap.set

keymap("n", "<leader>gd", ":CodeDiff<CR>", opt("Codediff on HEAD"))
