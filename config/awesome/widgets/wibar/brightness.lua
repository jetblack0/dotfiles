local wibox = require("wibox")
local beautiful = require("beautiful")

-- Return table which contains the widget itself, and functions to change the text
local M = {}

local function get_percentage(brightness_cur, brightness_max)
	local brightness_min = 100
	return math.modf(brightness_cur / (brightness_max - brightness_min) * 100)
end

local function get_wibar_icon(percentage)
	if percentage > 90 then
		return beautiful.brightness.icon_100
	elseif percentage > 80 then
		return beautiful.brightness.icon_90
	elseif percentage > 70 then
		return beautiful.brightness.icon_80
	elseif percentage > 60 then
		return beautiful.brightness.icon_70
	elseif percentage > 50 then
		return beautiful.brightness.icon_60
	elseif percentage > 40 then
		return beautiful.brightness.icon_50
	elseif percentage > 30 then
		return beautiful.brightness.icon_40
	elseif percentage > 20 then
		return beautiful.brightness.icon_30
	elseif percentage > 10 then
		return beautiful.brightness.icon_20
	else
		return beautiful.brightness.icon_10
	end
end

-- Just read these files once when starting awesomewm
local brightness_cur = assert(io.open("/sys/class/backlight/intel_backlight/brightness", "r")):read("n")
local brightness_max = assert(io.open("/sys/class/backlight/intel_backlight/max_brightness", "r")):read("n")
local initial_percentage = get_percentage(brightness_cur, brightness_max)

local brightness_widget = wibox.widget{
	image = get_wibar_icon(initial_percentage),
	resize = true,
	widget = wibox.widget.imagebox()
}

-- I change my brightness only though keyboard shortcuts, so it makes sense to only update this widget when i press these keys
function M.update_icon(operator, step)
	if operator == "+" then
		initial_percentage = initial_percentage + step
		brightness_widget:set_image(get_wibar_icon(initial_percentage))
	elseif operator == "-" then
		initial_percentage = initial_percentage - step
		brightness_widget:set_image(get_wibar_icon(initial_percentage))
	end
end

M.brightness_widget_container = wibox.container.background(brightness_widget)
M.brightness_widget_container.bgimage = beautiful.brightness.background_image

return M
