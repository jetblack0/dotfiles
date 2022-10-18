local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Keyboard map indicator and switcher with background image
local mykeyboardlayout = wibox.container.background(awful.widget.keyboardlayout())
mykeyboardlayout.fg = "black"
mykeyboardlayout.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_blue.png"

local powerLauncher = require("widgets/wibar/power")
local memoryUsage = require("widgets/wibar/memoryUsage")
local batteryAndNotification = require("widgets/wibar/batteryAndNotification")
local clockAndCal = require("widgets/wibar/clockAndCal")
local brightness = require("widgets/wibar/brightness").brightnessWidgetContainer
local volume = require("widgets/wibar/volume").volumeWidgetContainer
local bluetooth = require("widgets/wibar/bluetooth")
local network = require("widgets/wibar/network")
local microphone = require("widgets/wibar/microphone")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Make background for layoutbox
	local mylayoutboxWithColor = wibox.container.background(s.mylayoutbox)
	mylayoutboxWithColor.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_pink2.png"
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		bg = beautiful.bg_normal .. "00",
		width = 1890,
		height = 20,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.stack,
		{
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
			},
			nil,
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,

				mykeyboardlayout,
				memoryUsage,
				batteryAndNotification,
				-- wibox.widget.systray(),
				bluetooth,
				microphone,
				volume,
				brightness,
				network,
				mylayoutboxWithColor,
				powerLauncher,
			},
		},
		{
			-- mytextclock,
			clockAndCal,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		},
	})
end)
