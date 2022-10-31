local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- TODO: how do i make a popup menu when click a widget?

local get_text = [[bash -c "free -h | head -n 2 | tail -n 1 | awk '{print \" \"\$3\"/\"\$2\" \"}'"]]

local memory_usage = awful.widget.watch(get_text, 30)

_G.memory_container = wibox.container.background(memory_usage)
_G.memory_container.bgimage = beautiful.memory.background_image
_G.memory_container.fg = beautiful.memory.forground

return _G.memory_container
