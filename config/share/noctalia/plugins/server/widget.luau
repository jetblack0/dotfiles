-- Server mode -- bar icon
-- ---------------------------------------------
-- Visible only while the mode is on. Polls the state file, and publishes it
-- for the tile. A click turns the mode off.

local state = require("./state.luau")

noctalia.setUpdateInterval(1000)

function update()
	local on = state.read()
	noctalia.state.set("on", on)
	barWidget.setVisible(on)
	if on then
		barWidget.setGlyph("server")
		barWidget.setTooltip("Server mode: stays up with the lid closed. Click to turn off")
	end
end

function onClick()
	noctalia.runAsync(state.script .. " off", function()
		update()
	end)
end
