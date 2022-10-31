local wibox = require("wibox")
local naughty = require("naughty")
local timer = require("gears.timer")
local beautiful = require("beautiful")

-- TODO: Find some nice icons and change it to imagebox

-- Send noise if battery is lower than 10
local function send_noise(capacity, is_charging)
	if capacity <= 10 and not is_charging then
		naughty.notify({ text = "I'm gonna shutdown bro ", timeout = 10 })
	end
end

-- Get battery info
local function get_wibox_text()
	local capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r")):read("n")
	-- kinda stupid
	local is_charging = assert(io.open("/sys/class/power_supply/BAT0/status", "r")):read("l") == "Charging" or assert(io.open("/sys/class/power_supply/BAT0/status", "r")):read("l") == "Full"
	local battery_icon

	if capacity > 80 then
		battery_icon = " "
	elseif capacity > 60 then
		battery_icon = " "
	elseif capacity > 40 then
		battery_icon = " "
	elseif capacity > 20 then
		battery_icon = " "
	else
		battery_icon = " "
	end

	send_noise(capacity, is_charging)

	if is_charging then
		return battery_icon .. capacity .. "%" .. " "
	else
		return battery_icon .. capacity .. "%" .. " "
	end
end

local battery_widget = wibox.widget.textbox()

-- refresh battery text every 60 second
timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		battery_widget:set_text(get_wibox_text())
	end
})

-- give a nice background image to it
local battery_widget_container = wibox.container.background(battery_widget)
battery_widget_container.bgimage = beautiful.battery.background_image

return battery_widget_container
