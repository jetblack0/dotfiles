local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local clock_container = wibox.container.background(wibox.widget.textclock(" %a %b %d %H:%M "))
clock_container.bgimage = beautiful.clock.background_image

local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach( clock_container, "tc", {on_hover = false})

return clock_container
