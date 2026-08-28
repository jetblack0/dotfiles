-- Material
-----------------------------------------------
-- Google's Material Design 3 motion, as tuned by end-4's illogical-impulse
-- dots -- https://github.com/end-4/dots-hyprland

local curves = {
	md3_standard = { { 0.2, 0 },   { 0, 1 } },
	md3_decel    = { { 0.05, 0.7 }, { 0.1, 1 } },
	md3_accel    = { { 0.3, 0 },   { 0.8, 0.15 } },
	menu_decel   = { { 0.1, 1 },   { 0, 1 } },
	menu_accel   = { { 0.38, 0.04 }, { 1, 0.07 } },
}

return {
	name   = "material",
	curves = curves,

	animations = {
		-- windows.
		{ leaf = "windows",     speed = 3, curve = "md3_decel", style = "popin 60%" },
		{ leaf = "windowsIn",   speed = 3, curve = "md3_decel", style = "popin 60%" },
		{ leaf = "windowsOut",  speed = 3, curve = "md3_accel", style = "popin 60%" },
		{ leaf = "windowsMove", speed = 3, curve = "md3_standard", style = "slide" },

		-- workspaces.
		{ leaf = "workspaces",       speed = 7, curve = "menu_decel", style = "slidefadevert 20%" },
		{ leaf = "specialWorkspace", speed = 7, curve = "menu_decel", style = "slidefadevert 20%" },

		-- layers.
		{ leaf = "layersIn",      speed = 3,   curve = "menu_decel", style = "slide" },
		{ leaf = "layersOut",     speed = 1.6, curve = "menu_accel" },
		{ leaf = "fadeLayersIn",  speed = 2,   curve = "menu_decel" },
		{ leaf = "fadeLayersOut", speed = 4.5, curve = "menu_accel" },

		{ leaf = "fade",   speed = 3,  curve = "md3_decel" },
		{ leaf = "border", speed = 10, curve = "default" },

		{ leaf = "borderangle", enabled = false },
	},
}
