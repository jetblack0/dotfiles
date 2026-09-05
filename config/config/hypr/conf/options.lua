local theme = require("conf.theme")

hl.config({
	general = {
		gaps_in     = theme.layout.gaps_in,
		gaps_out    = theme.layout.gaps_out,
		border_size = theme.layout.border_size,
		col = {
			active_border   = theme.ui.border_active,
			inactive_border = theme.ui.border_inactive,
		},
		layout = "master",
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
		-- What shows through before a window paints; unset it and the
		-- compositor's own blue-grey is the one colour no theme controls.
		background_color = theme.ui.background,
	},

	master = {
		new_status = "slave",
	},

	-- XWayland surfaces render at 1x and get upscaled into blur on a
	-- fractionally scaled monitor (e.g., gpg pinentry). Zero-scaling 
  -- keeps them sharp; they draw small instead (fixed by Xft.dpi).
	xwayland = {
		force_zero_scaling = true,
	},

	-- All four group states, not just the active one: a slot left unfilled
	-- falls back to Hyprland's default colours, not to the theme.
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

-- A theme that failed to load must not fail quietly: the fallback looks almost
-- right, which is how you end up debugging the wrong thing. seterror puts it on
-- screen until the next successful reload.
--
-- The banner colour is the one literal in the config that is deliberately not
-- from the theme. Reporting that the theme system broke, in a colour taken from
-- the theme system, is circular -- so this stays a plain value.
if theme._error ~= nil then
	hl.on("hyprland.start", function()
		hl.exec_cmd(string.format(
			"hyprctl seterror 'rgba(eb6f92ff)' 'theme: %s'",
			theme._error:gsub("'", "")
		))
	end)
end
