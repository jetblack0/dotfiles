local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- send noise if battery is lower than 10
local function send_noise(capacity, is_charging)
	if capacity <= 10 and not is_charging then
		naughty.notify({ text = "I'm gonna shutdown bro ", timeout = 10 })
	end
end

local function get_text(capacity, is_charging)
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

	if is_charging then
		return battery_icon .. capacity .. "%" .. " "
	else
		return battery_icon .. capacity .. "%" .. " "
	end
end

-- refresh battery text every 60 second
local battery_widget = awful.widget.watch(
	"cat /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT0/status",
	60,
	function(widget, stdout)
		local lines = {}
		for s in stdout:gmatch("[^\n]+") do
			table.insert(lines, s)
		end

		local capacity = tonumber(lines[1])
		local is_charging = lines[2]

		-- Sometimes i plug my charger but the status file says not charging, wired
		if is_charging == "Charging" or is_charging == "Full" then
			is_charging = true
		else
			is_charging = false
		end

		send_noise(capacity, is_charging)

		widget:set_text(get_text(capacity, is_charging))
	end
)

local battery_widget_container = wibox.container.background(battery_widget)
battery_widget_container.bgimage = beautiful.battery.background_image

return battery_widget_container
