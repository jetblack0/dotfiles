-- Dwindle layout
-----------------------------------------------
return {
	name = "dwindle",
	options = {},

	binds = function(ctx)
		hl.bind(ctx.mod .. " + H", hl.dsp.focus({ direction = "l" }), ctx.nograb)
		hl.bind(ctx.mod .. " + L", hl.dsp.focus({ direction = "r" }), ctx.nograb)
		hl.bind(ctx.mod .. " + J", hl.dsp.focus({ direction = "d" }), ctx.nograb)
		hl.bind(ctx.mod .. " + K", hl.dsp.focus({ direction = "u" }), ctx.nograb)
		hl.bind(ctx.mod .. " + SHIFT + J", hl.dsp.window.swap({ next = true }), ctx.nograb)
		hl.bind(ctx.mod .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }), ctx.nograb)
	end,
}
