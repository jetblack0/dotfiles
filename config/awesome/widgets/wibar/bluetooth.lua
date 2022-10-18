-- not done yet
local wibox = require("wibox")

--[[
local bluetoothWidget = wibox.widget{
	image =  "/home/jetblack/.config/awesome/images/wibar/bluetooth/bluetooth-off.svg",
	resize = true,
	widget = wibox.widget.imagebox
}
--]]

local bluetoothWidget = wibox.widget({
	{
		text = " ",
		widget = wibox.widget.textbox
	},
	{
		image = "/home/jetblack/.config/awesome/images/wibar/bluetooth/bluetooth-off.svg",
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.fixed.horizontal,
})

_G.bluetoothWidgetContainer = wibox.container.background(bluetoothWidget)
_G.bluetoothWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_green3.png"
_G.bluetoothWidgetContainer.fg = "black"

return _G.bluetoothWidgetContainer
