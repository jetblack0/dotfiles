local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local powerButton = wibox.widget{
	image = "/home/jetblack/.config/awesome/icons/peripheral/power.svg",
	resize = true,
	widget = wibox.widget.imagebox
}

powerButton:buttons(gears.table.join(
	awful.button({}, 1, function()
		awful.spawn.with_shell("/home/jetblack/.config/rofi/powermenu.sh 2 4 everforest JetBrains\\ Mono\\ Nerd\\ Font 12")
	end)
))

-- add some nice little background
_G.powerButtonContainer = wibox.container.background(powerButton)
_G.powerButtonContainer.bgimage = "/home/jetblack/.config/awesome/icons/bg_pink2.png"

return _G.powerButtonContainer
