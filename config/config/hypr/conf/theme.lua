-- Active theme
-----------------------------------------------
-- The chosen name lives outside the repo, in $XDG_STATE_HOME/hypr/theme, so
-- switching is a state write plus a reload rather than a config edit.

local themes = require("conf.themes")

local DEFAULT = "rose-pine"

local function state_path()
	local dir = os.getenv("XDG_STATE_HOME")
	if dir == nil or dir == "" then
		local home = os.getenv("HOME")
		if home == nil or home == "" then
			return nil
		end
		dir = home .. "/.local/state"
	end
	return dir .. "/hypr/theme"
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

local theme, err = themes.load(read_name() or DEFAULT)
if theme ~= nil then
	return theme
end

local fallback, fallback_err = themes.load(DEFAULT)
if fallback == nil then
	error(string.format("no usable theme: %s (default also failed: %s)", err, fallback_err))
end

fallback._error = err
return fallback
