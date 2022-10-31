local colors = {
	blue = "#8AADF4",
	cyan = "#8BD5CA",
	black = "#080808",
	white = "#CAD3F5",
	red = "#ED8796",
	violet = "#D183E8",
	grey = "#303030",
	magenta = "#F5BDE6",
	lavender = "#B7BDF8",
	green = "#A6DA95",
}

local bubbles_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.magenta },
		b = { fg = colors.black, bg = colors.lavender },
		c = { fg = colors.black, bg = nil },
	},

	insert = { a = { fg = colors.black, bg = colors.blue } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },
	command = { a = { fg = colors.black, bg = colors.green } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.black, bg = colors.black },
	},
}
require("lualine").setup({
	options = {
		globalstatus = true,
		always_divide_middle = false,
		theme = bubbles_theme,
		component_separators = "|",
		section_separators = { left = "", right = "" },
		ignore_focus = { "nerdtree" },
		extensions = {},
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "" }, right_padding = 2 },
		},
		lualine_b = {
			"filename",
			"branch",
		},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {
			{
				"diagnostics",
				-- sources = { "nvim_lsp" },
				sections = {
					"error",
					"warn",
					"info",
					"hint",
				},
				-- Can't set it as these hex color
				-- TODO: customize a little bit once i know how to do it
				--[[ diagnostics_color = {
					error = colors.red,
					warn = colors.magenta,
					info = colors.blue,
					hint = colors.violet,
				}, ]]

				--     | 
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				-- symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = false,
				update_in_insert = false,
				always_visible = false,
			},
			"filetype",
			-- "encoding",
			"progress",
		},
		lualine_z = {
			{ "location", separator = { right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})
