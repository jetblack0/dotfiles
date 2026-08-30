-- Trackpad indicator
-- ---------------------------------------------
-- Renders $XDG_STATE_HOME/hypr/trackpad, written by trackpad-toggle.sh:
--   on   -> hand-finger glyph
--   off  -> hand-finger-off glyph
--   none -> no touchpad on this machine, widget hidden

local home = noctalia.getenv("HOME") or ""
local stateDir = noctalia.getenv("XDG_STATE_HOME") or (home .. "/.local/state")
local statePath = stateDir .. "/hypr/trackpad"

noctalia.setUpdateInterval(1000)

function update()
	local state = noctalia.readFile(statePath)
	if state == nil then
		barWidget.setVisible(false)
		return
	end
	state = state:gsub("%s+$", "")

	if state == "none" then
		barWidget.setVisible(false)
		return
	end

	barWidget.setVisible(true)
	if state == "off" then
		barWidget.setGlyph("hand-finger-off")
		barWidget.setTooltip("Trackpad off — click to enable")
	else
		barWidget.setGlyph("hand-finger")
		barWidget.setTooltip("Trackpad on — click to disable")
	end
end
