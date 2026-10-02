-- Input devices
-----------------------------------------------
-- Per-host settings for single input devices, on top of the global
-- `input` options. The playbook (or nix) writes them to
-- $XDG_STATE_HOME/hypr/devices.lua, which returns a table like:
--
--     return {
--         ["tpps/2-ibm-trackpoint"] = { sensitivity = -0.4 },
--         ["logitech-g-pro--1"] = { accel_profile = "flat" },
--     }
--
-- Keys are device names as `hyprctl devices` prints them.

local function state_path()
	local dir = os.getenv("XDG_STATE_HOME")
	if dir == nil or dir == "" then
		local home = os.getenv("HOME")
		if home == nil or home == "" then
			return nil
		end
		dir = home .. "/.local/state"
	end
	return dir .. "/hypr/devices.lua"
end

local function generated()
	local path = state_path()
	if path == nil then
		return nil
	end

	local fh = io.open(path, "r")
	if fh == nil then
		return nil
	end
	fh:close()

	local ok, list = pcall(dofile, path)
	if not ok then
		return nil, string.format("%s did not load: %s", path, tostring(list):match("^[^\n]*"))
	end
	if type(list) ~= "table" then
		return nil, string.format("%s did not return a table", path)
	end
	return list
end

local function apply(name, options)
	local rule = { name = name }
	for key, value in pairs(options) do
		rule[key] = value
	end
	hl.device(rule)
end

local settings, err = generated()

if settings ~= nil then
	for name, options in pairs(settings) do
		if type(options) ~= "table" then
			err = string.format("devices.lua: %s is not a table of options", name)
		else
			apply(name, options)
		end
	end
end

if err ~= nil then
	hl.on("hyprland.start", function()
		hl.exec_cmd(string.format("hyprctl seterror 'rgba(eb6f92ff)' 'devices: %s'", err:gsub("'", "")))
	end)
end
