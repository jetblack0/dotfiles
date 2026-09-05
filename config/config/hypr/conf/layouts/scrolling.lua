-- Scrolling layout
-----------------------------------------------
return {
	name = "scrolling",
	options = {
		scrolling = {
			column_width = 1.0,
			fullscreen_on_one_column = true,
			explicit_column_widths = "0.5, 0.667, 1.0",
		},
	},

	binds = function(ctx)
		-- H/L walk the columns; J/K walk a column's vertical stack
		hl.bind(ctx.mod .. " + H", hl.dsp.focus({ direction = "l" }), ctx.nograb)
		hl.bind(ctx.mod .. " + L", hl.dsp.focus({ direction = "r" }), ctx.nograb)
		hl.bind(ctx.mod .. " + J", hl.dsp.focus({ direction = "d" }), ctx.nograb)
		hl.bind(ctx.mod .. " + K", hl.dsp.focus({ direction = "u" }), ctx.nograb)
		hl.bind(ctx.mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), ctx.nograb)
		hl.bind(ctx.mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), ctx.nograb)

		-- reorder the focused column left/right in the tape
		hl.bind(ctx.mod .. " + comma",  hl.dsp.layout("swapcol l"), ctx.nograb)
		hl.bind(ctx.mod .. " + period", hl.dsp.layout("swapcol r"), ctx.nograb)

		-- niri consume/expel
		hl.bind(ctx.mod .. " + SHIFT + comma",  hl.dsp.layout("consume_or_expel prev"), ctx.nograb)
		hl.bind(ctx.mod .. " + SHIFT + period", hl.dsp.layout("consume_or_expel next"), ctx.nograb)

		hl.bind(ctx.mod .. " + SHIFT + R", hl.dsp.layout("colresize +conf"), ctx.nograb)
	end,
}
