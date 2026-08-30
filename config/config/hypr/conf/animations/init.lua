-- Animation contract
-----------------------------------------------
-- Shape of a set:
--
--   curves     = { name = { {x1, y1}, {x2, y2} } }
--   animations = { { leaf =, speed =, curve =, style = }, ... }
--
-- speed is in deciseconds: speed = 3 is 300ms.

local M = {}

local BUILTIN_CURVES = {
	default = true,
	linear  = true,
}


-- Validation
-----------------------------------------------
local function validate_curve(name, points)
	if type(points) ~= "table" or #points ~= 2 then
		return false, string.format("curve %s must be two control points", name)
	end
	for i, point in ipairs(points) do
		if type(point) ~= "table" or type(point[1]) ~= "number" or type(point[2]) ~= "number" then
			return false, string.format("curve %s point %d must be { x, y }", name, i)
		end
	end
	return true
end

function M.validate(set)
	if type(set) ~= "table" then
		return false, "animation set is not a table"
	end

	local name = set.name or "?"

	if type(set.curves) ~= "table" then
		return false, string.format("%s: curves must be a table", name)
	end
	if type(set.animations) ~= "table" then
		return false, string.format("%s: animations must be a table", name)
	end

	for curve, points in pairs(set.curves) do
		local ok, err = validate_curve(curve, points)
		if not ok then
			return false, string.format("%s: %s", name, err)
		end
	end

	for i, anim in ipairs(set.animations) do
		if type(anim) ~= "table" or type(anim.leaf) ~= "string" then
			return false, string.format("%s: animations[%d] needs a leaf", name, i)
		end

		if anim.enabled ~= false then
			if type(anim.speed) ~= "number" or anim.speed <= 0 then
				return false, string.format("%s: %s needs a positive speed", name, anim.leaf)
			end
			if type(anim.curve) ~= "string" then
				return false, string.format("%s: %s needs a curve", name, anim.leaf)
			end
			if set.curves[anim.curve] == nil and not BUILTIN_CURVES[anim.curve] then
				return false, string.format("%s: %s references undefined curve %q", name, anim.leaf, anim.curve)
			end
		end
	end

	return true
end


-- Loading
-----------------------------------------------
local function is_name(name)
	return type(name) == "string" and name ~= "" and name:match("^[%w._-]+$") ~= nil
end

function M.load(name)
	if not is_name(name) then
		return nil, string.format("invalid animation name %q", tostring(name))
	end

	local ok, set = pcall(require, "conf.animations." .. name)
	if not ok then
		local reason = tostring(set):match("^[^\n]*") or "unknown error"
		return nil, string.format("animation %q failed to load: %s", name, reason)
	end

	local valid, err = M.validate(set)
	if not valid then
		return nil, err
	end

	return set
end

function M.list()
	local dir = debug.getinfo(1, "S").source:match("^@(.*)/[^/]*$")
	if dir == nil then
		return {}
	end

	local names = {}
	local ok, pipe = pcall(io.popen, string.format("ls -1 %q", dir))
	if not ok or pipe == nil then
		return names
	end

	for entry in pipe:lines() do
		local entry_name = entry:match("^(.+)%.lua$")
		if entry_name ~= nil and entry_name ~= "init" then
			names[#names + 1] = entry_name
		end
	end
	pipe:close()

	table.sort(names)
	return names
end

return M
