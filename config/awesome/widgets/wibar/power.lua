local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local power_button = wibox.widget{
	image = beautiful.power.icon,
	resize = true,
	widget = wibox.widget.imagebox
}

power_button:buttons(gears.table.join(
	awful.button({}, 1, function()
		awful.spawn.with_shell("/home/jetblack/.config/rofi/powermenu.sh 2 4 everforest JetBrains\\ Mono\\ Nerd\\ Font 12")
	end)
))

-- add some nice little background
local power_button_container = wibox.container.background(power_button)
power_button_container.bgimage = beautiful.power.background_image

return power_button_container
