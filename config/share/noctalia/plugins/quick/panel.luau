-- Quick settings -- dropdown
-- ---------------------------------------------
-- Top: on/off tiles, styled like the control-center ones (primary when on).
-- Below: the hypr switchers, one row each, showing the current value; a
-- click moves to the next one.
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
local hovered = nil

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

-- An on/off tile. All tiles share the row equally.
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

	-- The trackpad tile only on machines that have one (state "none").
	local trackpad = readState("trackpad", "none")
	if trackpad ~= "none" then
		tiles[#tiles + 1] = tile("trackpad", trackpad == "off" and "hand-finger-off" or "hand-finger", "Trackpad",
			trackpad ~= "off", function()
				noctalia.runAsync(scripts .. "/trackpad-toggle.sh", render)
			end)
	end

	panel.render(ui.column({ gap = 10, padding = 12 }, {
		ui.row({ gap = 8 }, tiles),
		ui.separator({}),
		ui.column({ gap = 2 }, {
			switcher("animation", "movie", "Animation", readState("animation", "macos"), function()
				noctalia.runAsync(scripts .. "/animation-switcher.sh --next", render)
			end),
			switcher("layout", "layout-grid", "Layout", readState("layout", "master"), function()
				noctalia.runAsync(scripts .. "/layout-switcher.sh --next", render)
			end),
		}),
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
end
