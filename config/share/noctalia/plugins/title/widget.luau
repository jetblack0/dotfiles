-- Window class -- bar widget
-- ---------------------------------------------
-- Shows the focused window's class (the program, e.g. kitty), cut off at a
-- share of the bar. The title is often just "zsh", so it moved to the
-- tooltip. Plugins can't read the compositor, so both are polled from
-- hyprctl. The widget hides itself when no window is focused.

-- The bar this widget sits on. Plugins can't ask which bar they are in,
-- and this repo only has one.
local BAR = "bar.main"

-- Space on each side of the class inside its background, and its corner
-- radius.
local PAD = 8

noctalia.setUpdateInterval(500)

local class = ""
local title = ""
local width = 0

-- The widest the class may be, in the widget's own units.
-- The left half of the bar runs from its edge to the middle, where the
-- clock is. The bar scale multiplies every size inside the widget, so the
-- result is divided by it to come out in screen (logical) pixels.
local function maxWidth()
	local screen = nil
	for _, output in ipairs(noctalia.outputs()) do
		if output.name == barWidget.outputName() then
			screen = output.width
		end
	end
	if screen == nil then
		return 200
	end
	local margin = noctalia.getSetting(BAR .. ".margin_ends") or 0
	local scale = noctalia.getSetting(BAR .. ".scale") or 1
	local half = (screen - 2 * margin) / 2
	return math.floor(half * noctalia.getConfig("share") / 100 / scale)
end

local function draw()
	barWidget.setVisible(class ~= "")
	if class == "" then
		return
	end
	barWidget.setTooltip(title)
	-- A quiet pill behind the class. surface_variant comes from the
	-- wallpaper palette and sits just above the bar's own colour.
	-- The padding counts against the width, so the pill as a whole keeps
	-- to its share.
	barWidget.render(ui.row({ align = "center", fill = "surface_variant", radius = PAD, paddingH = PAD, paddingV = 2 }, {
		ui.label({ text = class, maxWidth = width - 2 * PAD, maxLines = 1 }),
	}))
end

function update()
	-- barWidget only answers in update(), not in the runAsync callback,
	-- so the width is worked out here.
	local newWidth = maxWidth()
	noctalia.runAsync({ "hyprctl", "activewindow", "-j" }, function(result)
		local window = nil
		if result.exitCode == 0 then
			window = noctalia.json.decode(result.stdout)
		end
		-- With no window focused, hyprctl prints {}.
		local newTitle = (window and window.title) or ""
		-- A few windows set no class; show their title instead.
		local newClass = (window and window.class) or ""
		if newClass == "" then
			newClass = newTitle
		end
		-- Only redraw when something changed.
		if newClass ~= class or newTitle ~= title or newWidth ~= width then
			class = newClass
			title = newTitle
			width = newWidth
			draw()
		end
	end)
end
