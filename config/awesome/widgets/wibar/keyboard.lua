local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local keyboard_container = wibox.container.background(awful.widget.keyboardlayout())
keyboard_container.bgimage = beautiful.keyboard.background_image

return keyboard_container
