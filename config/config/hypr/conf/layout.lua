-- Active layout
-----------------------------------------------

local DEFAULT = "master"

local function state_path()
	local dir = os.getenv("XDG_STATE_HOME")
	if dir == nil or dir == "" then
		local home = os.getenv("HOME")
		if home == nil or home == "" then
			return nil
		end
		dir = home .. "/.local/state"
	end
	return dir .. "/hypr/layout"
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

local function load(name)
	if type(name) ~= "string" or name:match("^[%w._-]+$") == nil then
		return nil, string.format("invalid layout name %q", tostring(name))
	end
	local ok, layout = pcall(require, "conf.layouts." .. name)
	if not ok then
		return nil, string.format("layout %q failed to load: %s", name, tostring(layout):match("^[^\n]*"))
	end
	if type(layout) ~= "table" or type(layout.name) ~= "string" or type(layout.options) ~= "table" then
		return nil, string.format("layout %q is malformed", name)
	end
	if layout.binds ~= nil and type(layout.binds) ~= "function" then
		return nil, string.format("layout %q: binds must be a function", name)
	end
	return layout
end

local layout, err = load(read_name() or DEFAULT)
if layout ~= nil then
	return layout
end

local fallback, fallback_err = load(DEFAULT)
if fallback == nil then
	error(string.format("no usable layout: %s (default also failed: %s)", err, fallback_err))
end
fallback._error = err
return fallback
