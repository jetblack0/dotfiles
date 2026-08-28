-- macOS
-----------------------------------------------

local curves = {
	decel = { { 0.16, 1 }, { 0.3, 1 } },
	accel = { { 0.55, 0 }, { 1, 0.45 } },
	smooth = { { 0.65, 0 }, { 0.35, 1 } },
}

return {
	name   = "macos",
	curves = curves,

	animations = {
		-- windows.
		{ leaf = "windowsIn",  speed = 2.5, curve = "decel",  style = "popin 92%" },
		{ leaf = "windowsOut", speed = 2,   curve = "accel",  style = "popin 95%" },
		{ leaf = "windowsMove", speed = 3,  curve = "smooth", style = "slide" },

		-- workspaces. only 400ms.
		{ leaf = "workspaces",       speed = 4, curve = "smooth", style = "slide" },
		{ leaf = "specialWorkspace", speed = 3, curve = "decel",  style = "slidefadevert 20%" },

		-- layers: menus, launchers, notifications. These want to be quick.
		{ leaf = "layersIn",  speed = 2,   curve = "decel", style = "popin 95%" },
		{ leaf = "layersOut", speed = 1.5, curve = "accel", style = "popin 95%" },

		{ leaf = "fade", speed = 2, curve = "decel" },
		{ leaf = "border", speed = 2, curve = "smooth" },
		{ leaf = "borderangle", enabled = false },
	},
}
