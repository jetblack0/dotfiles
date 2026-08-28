-- Theme contract
-----------------------------------------------

local M = {}

M.UI_SLOTS = {
	-- windows
	"border_active",
	"border_inactive",
	"background",

	-- grouped windows
	"group_border_active",
	"group_border_inactive",
	"group_border_locked_active",
	"group_border_locked_inactive",

	-- the group tab bar
	"groupbar_active",
	"groupbar_inactive",
	"groupbar_locked_active",
	"groupbar_locked_inactive",
	"groupbar_text",
	"groupbar_text_inactive",
}

M.LAYOUT_SLOTS = {
	"border_size",
	"rounding",
	"gaps_in",
	"gaps_out",
}


-- Validation
-----------------------------------------------
-- Returns ok, err.
function M.validate(theme)
	if type(theme) ~= "table" then
		return false, "theme is not a table"
	end

	local name = theme.name or "?"

	for _, section in ipairs({ "palette", "ui", "layout" }) do
		if type(theme[section]) ~= "table" then
			return false, string.format("%s: %s must be a table", name, section)
		end
	end

	for _, slot in ipairs(M.UI_SLOTS) do
		if theme.ui[slot] == nil then
			return false, string.format("%s: ui.%s is required", name, slot)
		end
	end

	for _, slot in ipairs(M.LAYOUT_SLOTS) do
		if type(theme.layout[slot]) ~= "number" then
			return false, string.format("%s: layout.%s must be a number", name, slot)
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
		return nil, string.format("invalid theme name %q", tostring(name))
	end

	local ok, theme = pcall(require, "conf.themes." .. name)
	if not ok then
		local reason = tostring(theme):match("^[^\n]*") or "unknown error"
		return nil, string.format("theme %q failed to load: %s", name, reason)
	end

	local valid, err = M.validate(theme)
	if not valid then
		return nil, err
	end

	return theme
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
		local name = entry:match("^(.+)%.lua$")
		if name ~= nil and name ~= "init" then
			names[#names + 1] = name
		end
	end
	pipe:close()

	table.sort(names)
	return names
end

return M
