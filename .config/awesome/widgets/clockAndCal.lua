local wibox = require("wibox")
local awful = require("awful")

local mytextclock = wibox.container.background(wibox.widget.textclock(" %a %b %d %H:%M "))
mytextclock.bgimage = "/home/jetblack/.config/awesome/icons/bg_blue.png"
mytextclock.fg = "black"

local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach( mytextclock, "tc", {on_hover = false})

return mytextclock
