local wibox = require("wibox")
local naughty = require("naughty")
local timer = require("gears.timer")

local batteryWidget = wibox.widget.textbox()

-- get text of this text based battery widget
local function sendNoise(capacity, isCharging)
	if capacity <= 10 and not isCharging then
		naughty.notify({ text = "I'm gonna shutdown bro ", timeout = 10 })
	end
end

local function getWiboxText()
	local capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r")):read("n")
	-- kinda stupid
	local isCharging = assert(io.open("/sys/class/power_supply/BAT0/status", "r")):read("l") == "Charging" or assert(io.open("/sys/class/power_supply/BAT0/status", "r")):read("l") == "Full"
	local batteryIcon

	if capacity > 80 then
		batteryIcon = " "
	elseif capacity > 60 then
		batteryIcon = " "
	elseif capacity > 40 then
		batteryIcon = " "
	elseif capacity > 20 then
		batteryIcon = " "
	else
		batteryIcon = " "
	end

	sendNoise(capacity, isCharging)

	if isCharging then
		return batteryIcon .. capacity .. "%" .. " "
	else
		return batteryIcon .. capacity .. "%" .. " "
	end
end

-- refresh battery text every 60 second
timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		batteryWidget:set_text(getWiboxText())
	end
})

-- give a nice background image to it
_G.batteryWidgetContainer = wibox.container.background(batteryWidget)
_G.batteryWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_blue.png"
_G.batteryWidgetContainer.fg = "black"

return _G.batteryWidgetContainer
