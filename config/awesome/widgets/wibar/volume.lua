local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local function get_wibar_image(cur_volume, is_mute)
	if is_mute then
		return beautiful.volume.icon_mute
	elseif cur_volume > 70 then
		return beautiful.volume.icon_high
	elseif cur_volume > 30 then
		return beautiful.volume.icon_medium
	else
		return beautiful.volume.icon_low
	end
end

local function update(volume_widget)
	--[[ local cur_volume = assert(io.popen("pamixer --get-volume", "r")):read("n")
	local is_mute = assert(io.popen("pamixer --get-mute", "r")):read("l") == "true" ]]

	-- Get the current volume info asynchronously, avoid using something like io.popen() !
	awful.spawn.easy_async_with_shell("pamixer --get-volume ; pamixer --get-mute", function(stdout)
		local lines = {}
		for s in stdout:gmatch("[^\n]+") do
			table.insert(lines, s)
		end

		local cur_volume = tonumber(lines[1])
		local is_mute = lines[2] == "true"

		volume_widget:set_image(get_wibar_image(cur_volume, is_mute))
	end)
end

local volume_widget = wibox.widget({
	resize = true,
	widget = wibox.widget.imagebox,
})

-- initialize
update(volume_widget)

-- TODO: why there are two pactl subscribe processes?
local pactl_subscribe = [[
bash -c "pactl subscribe 2>/dev/null"]]

-- Kill all the pactl subscribe processes before running this callback function
awful.spawn.easy_async_with_shell('kill $(pgrep -f "pactl subscribe")', function()
	-- Update this widget asynchronously when pactl subscribe print something new
	awful.spawn.with_line_callback(pactl_subscribe, {
		-- Function that is called with each line of output on stdout
		stdout = function(line)
			if string.find(line, "Event 'change' on sink #") then
				update(volume_widget)
			end
		end,
	})
end)

local volume_widget_container = wibox.container.background(volume_widget)
volume_widget_container.bgimage = beautiful.volume.background_image

return volume_widget_container
