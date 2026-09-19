-- Dwindle layout
-----------------------------------------------
return {
	name = "dwindle",
	options = {},

	binds = function(ctx)
		hl.bind(ctx.mod .. " + H", hl.dsp.focus({ direction = "l" }), ctx.d("focus left", ctx.nograb))
		hl.bind(ctx.mod .. " + L", hl.dsp.focus({ direction = "r" }), ctx.d("focus right", ctx.nograb))
		hl.bind(ctx.mod .. " + J", hl.dsp.focus({ direction = "d" }), ctx.d("focus down", ctx.nograb))
		hl.bind(ctx.mod .. " + K", hl.dsp.focus({ direction = "u" }), ctx.d("focus up", ctx.nograb))
		hl.bind(ctx.mod .. " + SHIFT + J", hl.dsp.window.swap({ next = true }), ctx.d("swap with the next window", ctx.nograb))
		hl.bind(ctx.mod .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }), ctx.d("swap with the previous window", ctx.nograb))
	end,
}
