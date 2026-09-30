-- Quick settings -- dropdown
-- ---------------------------------------------
-- The panel is drawn when it opens and after each click.

-- The server plugin owns server mode's state file and script.
local server = require("../server/state.luau")

local home = noctalia.getenv("HOME") or ""
local stateDir = noctalia.getenv("XDG_STATE_HOME")
if stateDir == nil or stateDir == "" then
	stateDir = home .. "/.local/state"
end
local scripts = home .. "/.config/hypr/scripts"

local caffeine = false
local dnd = false
local recording = false
local hdmi = nil
local hovered = nil

local recorder = { "noctalia", "msg", "plugin", "noctalia/screen_recorder:service", "all" }

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

-- Asks logind for its inhibitor locks, then calls done().
local function readCaffeine(done)
	noctalia.runAsync({
		"busctl", "--json=short", "call",
		"org.freedesktop.login1", "/org/freedesktop/login1",
		"org.freedesktop.login1.Manager", "ListInhibitors",
	}, function(result)
		local found = false
		local reply = result.exitCode == 0 and noctalia.json.decode(result.stdout) or nil
		-- Each lock is { what, who, why, mode, uid, pid }.
		for _, lock in ipairs((reply and reply.data and reply.data[1]) or {}) do
			if lock[1] == "idle" and lock[2] == "noctalia" and lock[3] == "Caffeine" then
				found = true
			end
		end
		caffeine = found
		done()
	end)
end

-- Asks noctalia whether Do Not Disturb is on ("on" / "off"), then calls
-- done().
local function readDnd(done)
	noctalia.runAsync({ "noctalia", "msg", "notification-dnd-status" }, function(result)
		dnd = result.exitCode == 0 and result.stdout:match("^%s*on") ~= nil
		done()
	end)
end

-- Looks for a sound card that can play over HDMI, then calls done().
local function readHdmi(done)
	noctalia.runAsync({ "pactl", "-f", "json", "list", "cards" }, function(result)
		local found = nil
		local cards = result.exitCode == 0 and noctalia.json.decode(result.stdout) or nil
		for _, card in ipairs(cards or {}) do
			local active = card.active_profile or ""
			local onName, onScore, offName, offPrio = nil, -1, nil, -1
			for name, info in pairs(card.profiles or {}) do
				if info.available then
					if name:match("^output:hdmi%-stereo") then
						-- Prefer the variant that keeps the laptop's microphone.
						local score = info.priority + (name:find("+input:", 1, true) and 100000 or 0)
						if score > onScore then
							onName, onScore = name, score
						end
					elseif name ~= "off" and name:sub(1, 5) ~= "input" and info.priority > offPrio then
						offName, offPrio = name, info.priority
					end
				end
			end
			if card.profiles and card.profiles["output:analog-stereo+input:analog-stereo"] then
				offName = "output:analog-stereo+input:analog-stereo"
			end
			local isOn = active:match("^output:hdmi") ~= nil
			if (onName or isOn) and offName then
				found = { card = card.name, on = isOn, onProfile = onName or active, offProfile = offName }
				break
			end
		end
		hdmi = found
		done()
	end)
end

-- Looks for a running gpu-screen-recorder, then calls done(). The recorder
-- plugin keeps its state to itself, so this asks the process list instead.
local function readRecording(done)
	noctalia.runAsync({ "pgrep", "-f", "gpu-screen-recorder" }, function(result)
		recording = result.exitCode == 0
		done()
	end)
end

-- Sends one command to the recorder, then closes the dropdown, so it is not
-- in the recording and does not cover the region picker.
local function record(action, source)
	return function()
		local cmd = table.clone(recorder)
		table.insert(cmd, action)
		if source then
			table.insert(cmd, source)
		end
		noctalia.runAsync(cmd)
		panel.close()
	end
end

-- An on/off tile. Every button is half the row wide (see buttonRows).
local function tile(key, glyph, label, on, onClick)
	return ui.button({
		key = key,
		glyph = glyph,
		text = label,
		variant = on and "primary" or "default",
		controlSize = "lg",
		flexGrow = 1,
		onClick = onClick,
	})
end

-- A switcher row: glyph and name on the left, current value on the right.
local function switcher(key, glyph, label, value, onClick)
	return ui.row({
		key = key,
		gap = 10,
		align = "center",
		paddingH = 10,
		paddingV = 6,
		radius = 8,
		-- Not nil when unhovered: a dropped prop keeps its old value, so the
		-- highlight would stick.
		fill = hovered == key and "surface_variant" or "surface_variant/0",
		onHover = "onRowHover",
		onClick = onClick,
	}, {
		ui.glyph({ name = glyph, size = 16, color = "on_surface_variant" }),
		ui.label({ text = label, flexGrow = 1 }),
		ui.label({ text = value, color = "on_surface_variant" }),
		ui.glyph({ name = "chevron-right", size = 14, color = "on_surface_variant" }),
	})
end

-- The recording buttons: two ways to start, or one stop button while
-- recording.
local function recordButtons()
	if recording then
		return {
			ui.button({
				key = "record-stop",
				controlSize = "lg",
				glyph = "player-stop",
				text = "Stop",
				variant = "primary",
				flexGrow = 1,
				onClick = record("stop"),
			}),
		}
	end
	return {
		ui.button({
			key = "record-screen",
			controlSize = "lg",
			glyph = "video",
			text = "Screen",
			flexGrow = 1,
			onClick = record("start", "focused"),
		}),
		ui.button({
			key = "record-region",
			controlSize = "lg",
			glyph = "video",
			text = "Region",
			flexGrow = 1,
			onClick = record("start", "portal"),
		}),
	}
end

-- Lays buttons out two to a row. A lone last button gets an empty spacer
-- next to it, so it keeps the same width as the others. The spacer needs a
-- see-through fill: a box is drawn solid by default.
local function buttonRows(buttons)
	local rows = {}
	for i = 1, #buttons, 2 do
		local second = buttons[i + 1] or ui.box({ key = "spacer", flexGrow = 1, fill = "surface_variant/0" })
		rows[#rows + 1] = ui.row({ gap = 8 }, { buttons[i], second })
	end
	return ui.column({ gap = 8 }, rows)
end

function render()
	local serverOn = server.read()
	local tiles = {
		tile("server", serverOn and "server" or "server-off", "Server", serverOn, function()
			noctalia.runAsync(server.script .. " toggle", render)
		end),
		tile("caffeine", caffeine and "caffeine-on" or "caffeine-off", "Caffeine", caffeine, function()
			noctalia.runAsync({ "noctalia", "msg", "caffeine-toggle" }, function()
				readCaffeine(render)
			end)
		end),
	}

	for _, button in ipairs(recordButtons()) do
		tiles[#tiles + 1] = button
	end

	-- Do not disturb: no notification pop-ups, e.g. while recording.
	tiles[#tiles + 1] = tile("dnd", dnd and "bell-off" or "bell", "DND", dnd, function()
		noctalia.runAsync({ "noctalia", "msg", "notification-dnd-toggle" }, function()
			readDnd(render)
		end)
	end)

	-- The trackpad tile only on machines that have one (state "none").
	local trackpad = readState("trackpad", "none")
	if trackpad ~= "none" then
		tiles[#tiles + 1] = tile("trackpad", trackpad == "off" and "hand-finger-off" or "hand-finger", "Trackpad",
			trackpad ~= "off", function()
				noctalia.runAsync(scripts .. "/trackpad-toggle.sh", render)
			end)
	end

	-- HDMI audio only while a TV or monitor with audio is plugged in.
	if hdmi then
		local h = hdmi
		tiles[#tiles + 1] = tile("hdmi", "device-tv", "HDMI audio", h.on, function()
			noctalia.runAsync({ "pactl", "set-card-profile", h.card, h.on and h.offProfile or h.onProfile }, function()
				readHdmi(render)
			end)
		end)
	end

	panel.render(ui.column({ gap = 10, padding = 12 }, {
		ui.column({ gap = 2 }, {
			switcher("animation", "movie", "Animation", readState("animation", "macos"), function()
				noctalia.runAsync(scripts .. "/animation-switcher.sh --next", render)
			end),
			switcher("layout", "layout-grid", "Layout", readState("layout", "master"), function()
				noctalia.runAsync(scripts .. "/layout-switcher.sh --next", render)
			end),
		}),
		ui.separator({}),
		buttonRows(tiles),
	}))
end

function onRowHover(state, key)
	hovered = state == "true" and key or nil
	render()
end

function onOpen()
	hovered = nil
	-- Draw straight away with the last caffeine value, then again once
	-- logind has answered.
	render()
	readCaffeine(render)
	readDnd(render)
	readRecording(render)
	readHdmi(render)
end
