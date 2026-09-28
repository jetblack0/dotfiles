-- Window title -- details panel
-- ---------------------------------------------
-- Opens from the bar title. Shows the focused window as hyprctl reports it,
-- one row per field. A click on a row copies its value. The panel is a
-- snapshot taken when it opens; it doesn't follow focus while open.

-- The rows, in order: the hyprctl field and its label. Empty values
-- are left out.
local FIELDS = {
	{ "title", "Title" },
	{ "initialTitle", "Initial title" },
	{ "class", "Class" },
	{ "initialClass", "Initial class" },
	{ "xdgTag", "XDG tag" },
	{ "tags", "Tags" },
	{ "workspace", "Workspace" },
	{ "floating", "Floating" },
	{ "fullscreen", "Fullscreen" },
	{ "xwayland", "XWayland" },
	{ "contentType", "Content type" },
	{ "size", "Size" },
	{ "at", "Position" },
	{ "pid", "PID" },
	{ "address", "Address" },
}

-- hyprctl's fullscreen numbers.
local FULLSCREEN = { [0] = "no", [1] = "maximized", [2] = "fullscreen", [3] = "maximized + fullscreen" }

local window = nil
local hovered = nil
local copied = nil

-- One field as the text shown and copied.
local function format(key, value)
	if value == nil then
		return ""
	elseif key == "workspace" then
		return value.name or tostring(value.id)
	elseif key == "size" then
		return value[1] .. "x" .. value[2]
	elseif key == "at" then
		return value[1] .. "," .. value[2]
	elseif key == "tags" then
		return table.concat(value, ", ")
	elseif key == "fullscreen" then
		return FULLSCREEN[value] or tostring(value)
	elseif type(value) == "boolean" then
		return value and "yes" or "no"
	end
	return tostring(value)
end

local function row(key, label, value)
	return ui.row({
		key = key,
		gap = 10,
		align = "center",
		paddingH = 8,
		paddingV = 4,
		radius = 6,
		-- Not nil when unhovered: a dropped prop keeps its old value, so
		-- the highlight would stick.
		fill = hovered == key and "surface_variant" or "surface_variant/0",
		onHover = "onRowHover",
		onClick = function()
			noctalia.copyToClipboard(value, "text/plain")
			copied = key
			render()
		end,
	}, {
		-- A label's own width is ignored; a row with minWidth lines the
		-- values up in one column.
		ui.row({ minWidth = 100 }, {
			ui.label({ text = label, color = "on_surface_variant" }),
		}),
		-- Only the title may need more than one line.
		ui.label({ text = value, flexGrow = 1, maxLines = key == "title" and 3 or 1 }),
		ui.glyph({ name = copied == key and "check" or "copy", size = 14, color = "on_surface_variant" }),
	})
end

function render()
	if window == nil then
		panel.render(ui.column({ padding = 12 }, {
			ui.label({ text = "No focused window", color = "on_surface_variant" }),
		}))
		return
	end
	local rows = {}
	for _, field in ipairs(FIELDS) do
		local value = format(field[1], window[field[1]])
		if value ~= "" then
			rows[#rows + 1] = row(field[1], field[2], value)
		end
	end
	panel.render(ui.column({ gap = 8, padding = 12 }, {
		ui.label({ text = "Window", fontWeight = "bold" }),
		ui.label({ text = "Click a row to copy it", color = "on_surface_variant" }),
		ui.scroll({ gap = 2, flexGrow = 1 }, rows),
	}))
end

function onRowHover(state, key)
	hovered = state == "true" and key or nil
	render()
end

function onOpen()
	window = nil
	hovered = nil
	copied = nil
	noctalia.runAsync({ "hyprctl", "activewindow", "-j" }, function(result)
		if result.exitCode == 0 then
			window = noctalia.json.decode(result.stdout)
			-- With no window focused, hyprctl prints {}.
			if window ~= nil and window.address == nil then
				window = nil
			end
		end
		render()
	end)
end
