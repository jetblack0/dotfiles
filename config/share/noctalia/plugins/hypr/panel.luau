-- Hyprland toggles -- dropdown
-- ---------------------------------------------
-- A row per hypr switcher. Each runs the matching hypr/scripts/* via
-- runAsync and re-renders once it finishes. State is read from
-- $XDG_STATE_HOME/hypr/<kind>.
-- Lua config resolves on reload. Add a switcher by adding a row.

local home = noctalia.getenv("HOME") or ""
local stateDir = noctalia.getenv("XDG_STATE_HOME")
if stateDir == nil or stateDir == "" then
	stateDir = home .. "/.local/state"
end
local scripts = home .. "/.config/hypr/scripts"

local function readState(name, default)
	local v = noctalia.readFile(stateDir .. "/hypr/" .. name)
	if v == nil then
		return default
	end
	v = v:gsub("%s+$", "")
	if v == "" then
		return default
	end
	return v
end

function render()
	local rows = {
		ui.label({ text = "Hyprland", fontWeight = "bold" }),
		ui.button({
			glyph = "movie",
			text = "Animation · " .. readState("animation", "macos"),
			onClick = "cycleAnimation",
		}),
		ui.button({
			glyph = "layout-grid",
			text = "Layout · " .. readState("layout", "master"),
			onClick = "cycleLayout",
		}),
	}

	-- trackpad row only on machines that have one (state "none" = no pad)
	local trackpad = readState("trackpad", "none")
	if trackpad ~= "none" then
		rows[#rows + 1] = ui.button({
			glyph = trackpad == "off" and "hand-finger-off" or "hand-finger",
			text = "Trackpad · " .. trackpad,
			onClick = "toggleTrackpad",
		})
	end

	panel.render(ui.column({ gap = 6, padding = 10 }, rows))
end

function onOpen()
	render()
end

function cycleAnimation()
	noctalia.runAsync(scripts .. "/animation-switcher.sh --next", function()
		render()
	end)
end

function cycleLayout()
	noctalia.runAsync(scripts .. "/layout-switcher.sh --next", function()
		render()
	end)
end

function toggleTrackpad()
	noctalia.runAsync(scripts .. "/trackpad-toggle.sh", function()
		render()
	end)
end
