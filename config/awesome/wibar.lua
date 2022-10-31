local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- TODO: move layoutbox widget to the widgets directory

-- A bunch of widgets (ugly)
local keyboard = require("widgets.wibar.keyboard")
local power = require("widgets.wibar.power")
local memory= require("widgets.wibar.memory")
local battery = require("widgets.wibar.battery")
local clock = require("widgets.wibar.clock")
local brightness = require("widgets.wibar.brightness").brightness_widget_container
local volume = require("widgets.wibar.volume")
local bluetooth = require("widgets.wibar.bluetooth")
local network = require("widgets.wibar.network")
local microphone = require("widgets.wibar.microphone")
local packages = require("widgets.wibar.packages")

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
	local layoutbox_container = wibox.container.background(s.mylayoutbox)
	layoutbox_container.bgimage = beautiful.layout.background_image
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

				keyboard,
				memory,
				packages,
				battery,
				-- wibox.widget.systray(),
				bluetooth,
				microphone,
				volume,
				brightness,
				network,
				layoutbox_container,
				power,
			},
		},
		{
			-- mytextclock,
			clock,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
		},
	})
end)
