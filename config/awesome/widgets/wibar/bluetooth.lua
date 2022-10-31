-- not done yet
local wibox = require("wibox")
local beautiful = require("beautiful")

--[[
local bluetoothWidget = wibox.widget{
	image =  "/home/jetblack/.config/awesome/images/wibar/bluetooth/bluetooth-off.svg",
	resize = true,
	widget = wibox.widget.imagebox
}
--]]

local bluetooth_widget = wibox.widget({
	{
		text = " ",
		widget = wibox.widget.textbox
	},
	{
		image = beautiful.bluetooth.icon,
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.fixed.horizontal,
})

local bluetooth_widget_container = wibox.container.background(bluetooth_widget)
bluetooth_widget_container.bgimage = beautiful.bluetooth.background_image

return bluetooth_widget_container
