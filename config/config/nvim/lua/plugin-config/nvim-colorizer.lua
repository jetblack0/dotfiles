local helpers = require("utils.helpers")
local colorizer = helpers.safe_require("colorizer")

colorizer.setup({
	filetypes = { "*", css = { css = true, names = true }, html = { css = true, names = true } },
	user_default_options = {
		RGB = true,
		RRGGBB = true,
		names = false,
		RRGGBBAA = true,
		AARRGGBB = true,
		rgb_fn = false,
		hsl_fn = false,
		css = false,
		css_fn = false,

		-- Available modes: foreground, background, virtualtext
		mode = "background",

    -- Enable tailwind colors, Available methods are: false, true,
    -- "normal", "lsp", "both"
		tailwind = false,

		-- parsers can contain values used in |user_default_options|
		sass = { enable = false, parsers = { css } }, -- Enable sass colors
		virtualtext = "■",
	},
	-- all the sub-options of filetypes apply to buftypes
	buftypes = {},
})
