local awful = require("awful")
local wibox = require("wibox")

--[[
	memory.sh script just has one line:
echo " $(free -h | head -n 2 | tail -n 1 | awk '{print $3"/"$2}') "
	but I have no idea why I can't put it into the first argument directly
--]]

local memoryUsage = awful.widget.watch('/home/jetblack/.config/awesome/widgets/scripts/memory.sh', 30)

_G.memoryContainer = wibox.container.background(memoryUsage)
_G.memoryContainer.bgimage = "/home/jetblack/.config/awesome/icons/bg_green3.png"
_G.memoryContainer.fg = "black"

return _G.memoryContainer
