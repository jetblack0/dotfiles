-- not done yet
local wibox = require("wibox")

local micWidget = wibox.widget{
	image =  "/home/jetblack/.config/awesome/images/wibar/microphone/microphone-off.svg",
	resize = true,
	widget = wibox.widget.imagebox
}

_G.micWidgetContainer = wibox.container.background(micWidget)
_G.micWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_green3.png"
_G.micWidgetContainer.fg = "black"

return _G.micWidgetContainer
