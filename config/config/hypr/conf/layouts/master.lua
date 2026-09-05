-- Master layout
-----------------------------------------------
return {
	name = "master",
	options = { master = { new_status = "slave" } },

	binds = function(ctx)
		hl.bind(ctx.mod .. " + H", hl.dsp.focus({ direction = "l" }), ctx.d("focus left", ctx.nograb))
		hl.bind(ctx.mod .. " + L", hl.dsp.focus({ direction = "r" }), ctx.d("focus right", ctx.nograb))
		hl.bind(ctx.mod .. " + J", hl.dsp.window.cycle_next({ next = true }), ctx.d("focus the next window", ctx.nograb))
		hl.bind(ctx.mod .. " + K", hl.dsp.window.cycle_next({ next = false }), ctx.d("focus the previous window", ctx.nograb))
		hl.bind(ctx.mod .. " + SHIFT + J", hl.dsp.window.swap({ next = true }), ctx.d("swap with the next window", ctx.nograb))
		hl.bind(ctx.mod .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }), ctx.d("swap with the previous window", ctx.nograb))
	end,
}
