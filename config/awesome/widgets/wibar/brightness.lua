local wibox = require("wibox")

-- Return table which contains the widget itself, and functions to change the text
local M = {}

local function getPercentage(brightnessCur, brightnessMax)
	local brightnessMin = 100
	return math.modf(brightnessCur / (brightnessMax - brightnessMin) * 100)
end

-- I don't wanna show percentage for aesthetics, just uncomment them to enable
local function getWibarIcon(percentage)
	local iconPath = "/home/jetblack/.config/awesome/images/wibar/brightness/"
	if percentage > 90 then
		return iconPath .. "light-on-100.svg"
	elseif percentage > 80 then
		return iconPath .. "light-on-90.svg"
	elseif percentage > 70 then
		return iconPath .. "light-on-80.svg"
	elseif percentage > 60 then
		return iconPath .. "light-on-70.svg"
	elseif percentage > 50 then
		return iconPath .. "light-on-60.svg"
	elseif percentage > 40 then
		return iconPath .. "light-on-50.svg"
	elseif percentage > 30 then
		return iconPath .. "light-on-40.svg"
	elseif percentage > 20 then
		return iconPath .. "light-on-30.svg"
	elseif percentage > 10 then
		return iconPath .. "light-on-20.svg"
	else
		return iconPath .. "light-on-10.svg"
	end
end

-- Just read these files once when starting awesomewm
local brightnessCur = assert(io.open("/sys/class/backlight/intel_backlight/brightness", "r")):read("n")
local brightnessMax = assert(io.open("/sys/class/backlight/intel_backlight/max_brightness", "r")):read("n")
local initialPercentage = getPercentage(brightnessCur, brightnessMax)

local iconWidget = wibox.widget.imagebox()

--[[
local brightnessWidget = wibox.widget({
	{
		image = getWibarIcon(initialPercentage),
		resize = true,
		-- widget = wibox.widget.imagebox
		widget = iconWidget
	},
	{
		text = " ",
		widget = wibox.widget.textbox
	},
	layout = wibox.layout.fixed.horizontal,
})
--]]

local brightnessWidget = wibox.widget{
	image = getWibarIcon(initialPercentage),
	resize = true,
	widget = iconWidget
}

function M.updateIcon(operator, step)
	if operator == "+" then
		initialPercentage = initialPercentage + step
		iconWidget:set_image(getWibarIcon(initialPercentage))
	elseif operator == "-" then
		initialPercentage = initialPercentage - step
		iconWidget:set_image(getWibarIcon(initialPercentage))
	end
end

M.brightnessWidgetContainer = wibox.container.background(brightnessWidget)
M.brightnessWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_green3.png"

return M
