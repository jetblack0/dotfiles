-- not done yet
local wibox = require("wibox")

local networkWidget = wibox.widget({
	{
		image = "/home/jetblack/.config/awesome/images/wibar/network/signal-cellular-2.svg",
		resize = true,
		widget = wibox.widget.imagebox,
	},
	{
		text = " ",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
})

--[[
local networkWidget = wibox.widget{
	image = "/home/jetblack/.config/awesome/images/wibar/network/signal-cellular-2.svg",
	widget = wibox.widget.imagebox,
}
--]]

_G.networkWidgetContainer = wibox.container.background(networkWidget)
_G.networkWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_green3.png"
_G.networkWidgetContainer.fg = "black"

return _G.networkWidgetContainer
