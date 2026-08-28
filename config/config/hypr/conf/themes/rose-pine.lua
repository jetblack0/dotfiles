-- Rose Pine (main)
-----------------------------------------------
-- https://rosepinetheme.com -- https://github.com/rose-pine/hyprland

local palette = {
	base           = "rgba(191724ff)",
	surface        = "rgba(1f1d2eff)",
	overlay        = "rgba(26233aff)",
	muted          = "rgba(6e6a86ff)",
	subtle         = "rgba(908caaff)",
	text           = "rgba(e0def4ff)",
	love           = "rgba(eb6f92ff)",
	gold           = "rgba(f6c177ff)",
	rose           = "rgba(ebbcbaff)",
	pine           = "rgba(31748fff)",
	foam           = "rgba(9ccfd8ff)",
	iris           = "rgba(c4a7e7ff)",
	highlight_low  = "rgba(21202eff)",
	highlight_med  = "rgba(403d52ff)",
	highlight_high = "rgba(524f67ff)",
}

-- Near-invisible for most of the edge, colour at one corner.
local function sheen(accent)
	return { colors = { palette.highlight_high, accent }, angle = 45 }
end

return {
	name    = "rose-pine",
	palette = palette,

	ui = {
		-- windows.
		border_active   = sheen(palette.rose),
		border_inactive = palette.overlay,
		background      = palette.base,

		-- groups.
		group_border_active          = sheen(palette.foam),
		group_border_inactive        = palette.overlay,
		group_border_locked_active   = sheen(palette.gold),
		group_border_locked_inactive = palette.highlight_med,

		-- the group tab bar.
		groupbar_active          = palette.highlight_high,
		groupbar_inactive        = palette.surface,
		groupbar_locked_active   = palette.highlight_med,
		groupbar_locked_inactive = palette.overlay,
		groupbar_text            = palette.text,   -- 5.96:1 on highlight_high
		groupbar_text_inactive   = palette.subtle, -- 5.12:1 on surface; muted is 3.20:1
	},

	layout = {
		border_size = 4,
		rounding    = 10,
		gaps_in     = 5,
		gaps_out    = 15,
	},
}
