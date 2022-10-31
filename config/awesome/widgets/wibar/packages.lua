local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

-- Only run once, so it's fine to use popen
local function get_text()
	return assert(io.popen("pacman -Q | wc -l", "r")):read("n")
end

local package_widget = wibox.widget({
	{
		text = " ",
		widget = wibox.widget.textbox,
	},
	{
		image = beautiful.package.icon,
		widget = wibox.widget.imagebox,
	},
	{
		text = get_text() .. " ",
		resize = true,
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
})

local package_widget_container = wibox.container.background(package_widget)
package_widget_container.bgimage = beautiful.package.background_image

return package_widget_container
