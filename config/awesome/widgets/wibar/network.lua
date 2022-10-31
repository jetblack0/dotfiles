-- not done yet
local wibox = require("wibox")
local beautiful = require("beautiful")

local network_widget = wibox.widget({
	{
		image = beautiful.network.icon,
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

local network_widget_container = wibox.container.background(network_widget)
network_widget_container.bgimage = beautiful.network.background_image

return network_widget_container
