-- Basic
-----------------------------------------------
-- Curve values credit: sansroot -- https://github.com/sansroot/hypr-dots

local curves = {
	winIn     = { { 0.1, 1.0 }, { 0.1, 1.0 } },
	winOut    = { { 0.1, 1.0 }, { 0.1, 1.0 } },
	smoothOut = { { 0.5, 0 },   { 0.99, 0.99 } },
	layerOut  = { { 0.23, 1 },  { 0.32, 1 } },
}

return {
	name   = "basic",
	curves = curves,

	animations = {
		{ leaf = "windowsIn",     speed = 7,  curve = "winIn",     style = "slide" },
		{ leaf = "windowsOut",    speed = 3,  curve = "smoothOut", style = "slide" },
		{ leaf = "windowsMove",   speed = 7,  curve = "winIn",     style = "slide" },
		{ leaf = "workspacesIn",  speed = 8,  curve = "winIn",     style = "slide" },
		{ leaf = "workspacesOut", speed = 8,  curve = "winOut",    style = "slide" },
		{ leaf = "layersIn",      speed = 10, curve = "winIn",     style = "slide" },
		{ leaf = "layersOut",     speed = 3,  curve = "layerOut",  style = "popin 50%" },
	},
}
