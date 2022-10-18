local wibox = require("wibox")
local M = {}

local function getWibarimage(curVolume, isMute)
	if isMute then
		return "/home/jetblack/.config/awesome/images/wibar/volume/volume-mute.svg"
	elseif curVolume > 70 then
		return "/home/jetblack/.config/awesome/images/wibar/volume/volume-high.svg"
	elseif curVolume > 30 then
		return "/home/jetblack/.config/awesome/images/wibar/volume/volume-medium.svg"
	else
		return "/home/jetblack/.config/awesome/images/wibar/volume/volume-low.svg"
	end
end

-- pamixer --get-volume command doesn't output anything when first start up computer
local curVolume
repeat
	curVolume = assert(io.popen("pamixer --get-volume", "r")):read("n")
until curVolume ~= nil

local isMute = assert(io.popen("pamixer --get-mute", "r")):read("l") == "true"

local volumeWidget = wibox.widget{
	image = getWibarimage(curVolume, isMute),
	resize = true,
    widget = wibox.widget.imagebox
}

function M.updateIcon(state)
	if state == "raise" then
		curVolume = curVolume + 5
	elseif state == "lower" then
		curVolume = curVolume - 5
	elseif state == "mute" then
		isMute = not isMute
	end
	volumeWidget:set_image(getWibarimage(curVolume, isMute))
end

M.volumeWidgetContainer = wibox.container.background(volumeWidget)
M.volumeWidgetContainer.bgimage = "/home/jetblack/.config/awesome/images/wibar/background/bg_green3.png"
-- M.volumeWidgetContainer.fg = "black"

return M
