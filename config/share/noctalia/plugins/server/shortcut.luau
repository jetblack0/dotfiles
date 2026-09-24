-- Server mode -- control-center tile
-- ---------------------------------------------
-- Caffeine stops dimming AND sleep, server mode stops only sleep and the lid.
-- Re-renders from the widget's published state, so it stays right when the
-- mode changes elsewhere.

local state = require("./state.luau")

local function render(on)
	shortcut.setLabel("Server Mode")
	shortcut.setIcon("server", "server-off")
	shortcut.setActive(on)
end

render(state.read())

noctalia.state.watch("on", function(on)
	render(on == true)
end)

function onClick()
	noctalia.runAsync(state.script .. " toggle", function()
		local on = state.read()
		noctalia.state.set("on", on)
		render(on)
	end)
end
