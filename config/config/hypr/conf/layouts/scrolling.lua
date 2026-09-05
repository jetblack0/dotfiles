-- Scrolling layout
-----------------------------------------------

local widths = { 0.5, 0.667, 1.0 }

return {
	name = "scrolling",
	options = {
		scrolling = {
			column_width = 1.0,
			fullscreen_on_one_column = true,
			explicit_column_widths = table.concat(widths, ", "),
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

		hl.bind(ctx.mod .. " + SHIFT + R", function()
			hl.dispatch(hl.dsp.layout("colresize +conf"))

			local win = hl.get_active_window()
			local mon = hl.get_active_monitor()
			if win == nil or mon == nil or not mon.scale or mon.scale == 0 then
				return
			end

			local frac = win.size.x / (mon.width / mon.scale)
			local best, dist = widths[1], math.huge
			for _, w in ipairs(widths) do
				local d = math.abs(w - frac)
				if d < dist then
					best, dist = w, d
				end
			end

			hl.exec_cmd(string.format(
				"$HOME/.config/hypr/scripts/notify-tag.sh width show -t 1200 Width %d%%",
				math.floor(best * 100 + 0.5)
			))
		end, ctx.nograb)
	end,
}
