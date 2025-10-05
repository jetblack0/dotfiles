local helpers = require("utils.helpers")
local lualine = helpers.safe_require("lualine")
local web_devicons = helpers.safe_require("nvim-web-devicons")
local nvim_navic = helpers.safe_require("nvim-navic")

if not lualine then return end

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir

-- Color table for highlights
-- stylua: ignore
local colors = {
	bg = '#3C3836',
	fg = '#D1CFC0',
	yellow = '#FABD2F',
	cyan = '#689D6A',
	darkblue = '#081633',
	green = '#98971A',
	orange = '#D79921',
	violet = '#a9a1e1',
	magenta = '#D3869B',
	blue = '#83a598',
	red = '#cc241d',
	pink = '#D19097',

	red_diff = '#eb6f92',
	green_diff = '#31748f',
	orange_diff = '#f6c177',

	green_diff_light = '#40A02B',
	orange_diff_light = '#DF8E1D',
	red_diff_light = '#D20F39',
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
  is_navic_available = function ()
    return nvim_navic.is_available
  end
}

-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = nil } },
			inactive = { c = { fg = colors.fg, bg = nil } },
		},
		ignore_focus = { },
		disabled_filetypes = { "netrw" },
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = { fg = colors.pink }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	-- mode component
	function()
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
		return web_devicons.get_icon(filename, extension, { default = true })
	end,
	padding = { right = 1, left = 1 },
  color = { fg = colors.pink }
	--[[ color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.pink,
			i = colors.violet,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.orange,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end, ]]
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.pink, gui = "bold" },
})

ins_left({
	-- filesize component
	"filesize",
	cond = conditions.buffer_not_empty,
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

--[[ ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  -- icon = ' LSP:',
  color = { fg = colors.fg },
} ]]

-- Add components to right sections
ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = "󰃤 ", info = "󰋽 ", hint = " " },
	-- color = { fg = colors.darkblue, gui = "bold"},
  diagnostics_color = {
    error = 'DiagnosticSignError',
    warn  = 'DiagnosticSignWarn',
    info  = 'DiagnosticSignInfo',
    hint  = 'DiagnosticSignHint',
  },
	colored = true,
	update_in_insert = false,
	always_visible = false,
})

-- NOTE: I only see UTF-8 encoding, not very useful. 
-- ins_right({
-- 	"o:encoding",
-- 	fmt = string.upper,
-- 	cond = conditions.hide_in_width,
-- 	color = { fg = colors.fg },
-- })

ins_right({
  function ()
    return nvim_navic.get_location()
  end,
  cond = is_navic_available,
	color = { fg = colors.blue, gui = "bold" },
})

-- ins_right({
-- 	"fileformat",
-- 	fmt = string.upper,
-- 	icons_enabled = false,
-- 	color = { fg = colors.fg },
-- })

ins_right({
	"branch",
	icon = "",
	color = { fg = colors.fg },
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = " ", removed = " " },
	diff_color = {
		added = { fg = colors.green_diff },
		modified = { fg = colors.orange_diff },
		removed = { fg = colors.red_diff },
	},

	cond = conditions.hide_in_width,
})

ins_right({
	function()
		return "▊"
	end,
	color = { fg = colors.pink },
	padding = { left = 1 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
