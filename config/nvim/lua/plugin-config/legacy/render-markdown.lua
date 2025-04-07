local helpers = require("utils.helpers")
local render_markdown = helpers.safe_require("render-markdown")
if not render_markdown then return end

render_markdown.setup({
  render_modes = { 'n', 'c', 't' }
})
