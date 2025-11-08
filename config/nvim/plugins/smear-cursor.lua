local helpers = require("utils.helpers")
local smear_cursor = helpers.safe_require("smear_cursor")

if not smear_cursor then return end 

smear_cursor.setup {
  enabled = false,
  smear_between_buffers = true,
  smear_between_neighbor_lines = true,
  scroll_buffer_space = true,
  legacy_computing_symbols_support = false,
  smear_insert_mode = true,
}
