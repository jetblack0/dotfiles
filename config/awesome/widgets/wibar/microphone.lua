-- not done yet
local wibox = require("wibox")
local beautiful = require("beautiful")

local micWidget = wibox.widget{
	image = beautiful.microphone.icon,
	resize = true,
	widget = wibox.widget.imagebox
}

local mic_widget_container = wibox.container.background(micWidget)
mic_widget_container.bgimage = beautiful.microphone.background_image

return mic_widget_container
