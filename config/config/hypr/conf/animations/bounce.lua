-- Bounce
-----------------------------------------------
-- Adapted from theblackdon's animations-def.nix / animations-moving.nix.

local curves = {
	wind   = { { -1.05, 0.9 }, { 0.1, 1.05 } },
	winIn  = { { -1.1, 1.1 },  { 0.1, 1.1 } },
	winOut = { { -1.3, -0.3 }, { 0, 1 } },
	liner  = { { 0, 1 },       { 1, 1 } },
}

return {
	name   = "bounce",
	curves = curves,

	animations = {
		{ leaf = "windows",     speed = 6, curve = "wind",   style = "slide" },
		{ leaf = "windowsIn",   speed = 6, curve = "winIn",  style = "slide" },
		{ leaf = "windowsOut",  speed = 5, curve = "winOut", style = "slide" },
		{ leaf = "windowsMove", speed = 5, curve = "wind",   style = "slide" },

		{ leaf = "workspaces", speed = 5, curve = "wind" },

		{ leaf = "border", speed = 1,  curve = "liner" },
		{ leaf = "fade",   speed = 10, curve = "default" },

		{ leaf = "borderangle", enabled = false },
	},
}
