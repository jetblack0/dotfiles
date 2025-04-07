local helpers = require("utils.helpers")
local fallback_colorscheme = "habamax"

local gruvbox = helpers.safe_require("gruvbox")
if not gruvbox then 
  vim.cmd("colorscheme " .. fallback_colorscheme)
  return 
end

gruvbox.setup({
  transparent_mode = true,
  overrides = {
    -- Override some highlights for Markdown.
    ["@markup.strong.markdown_inline"] = { fg = "#D19097", bold = true },
    ["@markup.italic.markdown_inline"] = { fg = "#D19097", italic = true },
    ["@markup.raw.block.markdown"] = { fg = "#8ec07c", italic = true },
    ["@markup.raw.markdown_inline"] = { fg = "#8ec07c", italic = true },
    -- Headings.
    ["@markup.heading.6.markdown"] = { fg = "#D1CFC0", bold = true },
    ["@markup.heading.5.markdown"] = { fg = "#a9a1e1", bold = true },
    ["@markup.heading.4.markdown"] = { fg = "#fabd2f", bold = true },
    ["@markup.heading.3.markdown"] = { fg = "#fe8019", bold = true },
    ["@markup.heading.2.markdown"] = { fg = "#b8bb26", bold = true },
    ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true },
  }
})
vim.cmd("colorscheme gruvbox")
