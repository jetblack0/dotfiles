-- Glow
-----------------------------------------------
-- Bounce, plus a border gradient that rotates forever, expensive.
-- borderangle + loop, from theblackdon's animations-dynamic.nix.

local curves = {
	wind  = { { 0.05, 0.9 }, { 0.1, 1.05 } },
	winIn = { { 0.1, 1.1 },  { 0.1, 1.1 } },
	winOut = { { 0.3, -0.3 }, { 0, 1 } },
	liner = { { 1, 1 },      { 1, 1 } },
}

return {
	name   = "glow",
	curves = curves,

	animations = {
		{ leaf = "windows",     speed = 6, curve = "wind",   style = "slide" },
		{ leaf = "windowsIn",   speed = 6, curve = "winIn",  style = "slide" },
		{ leaf = "windowsOut",  speed = 5, curve = "winOut", style = "slide" },
		{ leaf = "windowsMove", speed = 5, curve = "wind",   style = "slide" },

		{ leaf = "workspaces", speed = 5, curve = "wind" },

		{ leaf = "border", speed = 1, curve = "liner" },
		{ leaf = "fade",   speed = 10, curve = "default" },

		{ leaf = "borderangle", speed = 30, curve = "liner", style = "loop" },
	},
}
