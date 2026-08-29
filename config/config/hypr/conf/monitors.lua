-- Monitors
-----------------------------------------------
local defaults = {
	{ output = "", mode = "preferred", position = "auto", scale = 1 },
}

local function state_path()
	local dir = os.getenv("XDG_STATE_HOME")
	if dir == nil or dir == "" then
		local home = os.getenv("HOME")
		if home == nil or home == "" then
			return nil
		end
		dir = home .. "/.local/state"
	end
	return dir .. "/hypr/monitors.lua"
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
	if type(list) ~= "table" or #list == 0 then
		return nil, string.format("%s did not return a non-empty list", path)
	end
	return list
end

local displays, err = generated()
if displays == nil then
	displays = defaults
end

for _, display in ipairs(displays) do
	hl.monitor(display)
end

if err ~= nil then
	hl.on("hyprland.start", function()
		hl.exec_cmd(string.format("hyprctl seterror 'rgba(eb6f92ff)' 'monitors: %s'", err:gsub("'", "")))
	end)
end
