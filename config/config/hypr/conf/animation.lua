-- Active animation set
-----------------------------------------------
-- Mirrors conf/theme.lua: the chosen name lives in
-- $XDG_STATE_HOME/hypr/animation, so switching is a state write plus a reload
-- rather than a config edit. scripts/animation-switcher.sh writes it.
--
-- Unlike theme.lua this module is NOT pure -- it applies the set. That is fine
-- because hyprland.lua requires it exactly once, but it does mean this file
-- must never be required from anywhere else: hyprland's require() is not
-- cached, so a second require would apply every curve and leaf a second time.
--
-- A set that fails to load falls back to the default and returns _error for a
-- caller to surface, same contract as the theme.

local animations = require("conf.animations")

local DEFAULT = "macos"

local function state_path()
	local dir = os.getenv("XDG_STATE_HOME")
	if dir == nil or dir == "" then
		local home = os.getenv("HOME")
		if home == nil or home == "" then
			return nil
		end
		dir = home .. "/.local/state"
	end
	return dir .. "/hypr/animation"
end

local function read_name()
	local path = state_path()
	if path == nil then
		return nil
	end

	local fh = io.open(path, "r")
	if fh == nil then
		return nil
	end

	local line = fh:read("*l")
	fh:close()

	if line == nil then
		return nil
	end

	local name = line:match("^%s*(.-)%s*$")
	if name == "" then
		return nil
	end
	return name
end


-- Resolve
-----------------------------------------------
local set, err = animations.load(read_name() or DEFAULT)
if set == nil then
	local fallback, fallback_err = animations.load(DEFAULT)
	if fallback == nil then
		error(string.format("no usable animation set: %s (default also failed: %s)", err, fallback_err))
	end
	set = fallback

	-- Surfaced here rather than handed to a caller the way theme.lua does it:
	-- this module already has side effects and is already required exactly
	-- once, so there is nothing to gain by routing the error somewhere else.
	-- Banner colour is deliberately a literal -- see the note in options.lua.
	hl.on("hyprland.start", function()
		hl.exec_cmd(string.format(
			"hyprctl seterror 'rgba(eb6f92ff)' 'animation: %s'",
			err:gsub("'", "")
		))
	end)
end


-- Apply
-----------------------------------------------
-- An empty set means off: disabling the subsystem is both cheaper and more
-- honest than setting every leaf to enabled = false one at a time.
if #set.animations == 0 then
	hl.config({ animations = { enabled = false } })
	return { name = set.name, _error = err }
end

hl.config({ animations = { enabled = true } })

-- Sorted so a reload declares curves in the same order every time; hyprland
-- does not care, but a stable order makes `hyprctl repl` output comparable.
local curve_names = {}
for name in pairs(set.curves) do
	curve_names[#curve_names + 1] = name
end
table.sort(curve_names)

for _, name in ipairs(curve_names) do
	hl.curve(name, { type = "bezier", points = set.curves[name] })
end

for _, anim in ipairs(set.animations) do
	hl.animation({
		leaf    = anim.leaf,
		enabled = anim.enabled ~= false,
		speed   = anim.speed,
		bezier  = anim.curve,
		style   = anim.style,
	})
end

return { name = set.name, _error = err }
