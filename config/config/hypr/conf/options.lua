local theme = require("conf.theme")
local layout = require("conf.layout")

hl.config({
	general = {
		gaps_in     = theme.layout.gaps_in,
		gaps_out    = theme.layout.gaps_out,
		border_size = theme.layout.border_size,
		col = {
			active_border   = theme.ui.border_active,
			inactive_border = theme.ui.border_inactive,
		},
		layout = layout.name,
	},

	decoration = {
		rounding = theme.layout.rounding,
		shadow = { enabled = false },
		blur = {
			enabled = true,
			size    = 4,
			passes  = 1,
		},
	},

	input = {
		kb_layout     = "us",
		kb_options    = "caps:escape",
		accel_profile = "adaptive",
		follow_mouse  = 1,
		sensitivity   = 0,
		touchpad = {
			natural_scroll = true,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		vrr = 2,
		disable_autoreload = false,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms  = true,
		background_color = theme.ui.background,
	},


	-- XWayland surfaces render at 1x and get upscaled into blur on a
	-- fractionally scaled monitor (e.g., gpg pinentry). Zero-scaling 
  -- keeps them sharp; they draw small instead (fixed by Xft.dpi).
	xwayland = {
		force_zero_scaling = true,
	},

	group = {
		col = {
			border_active          = theme.ui.group_border_active,
			border_inactive        = theme.ui.group_border_inactive,
			border_locked_active   = theme.ui.group_border_locked_active,
			border_locked_inactive = theme.ui.group_border_locked_inactive,
		},
		groupbar = {
			font_family = "CodeNewRoman Nerd Font Propo",
			font_size   = 10,
			height      = 16,
			gradients   = true,
			text_color          = theme.ui.groupbar_text,
			text_color_inactive = theme.ui.groupbar_text_inactive,
			col = {
				active          = theme.ui.groupbar_active,
				inactive        = theme.ui.groupbar_inactive,
				locked_active   = theme.ui.groupbar_locked_active,
				locked_inactive = theme.ui.groupbar_locked_inactive,
			},
		},
	},
})

-- layout-specific options
if next(layout.options) ~= nil then
	hl.config(layout.options)
end

if theme._error ~= nil then
	hl.on("hyprland.start", function()
		hl.exec_cmd(string.format(
			"hyprctl seterror 'rgba(eb6f92ff)' 'theme: %s'",
			theme._error:gsub("'", "")
		))
	end)
end
