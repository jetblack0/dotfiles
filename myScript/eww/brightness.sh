#!/bin/sh
# return {percentage, icon_path}
# currently I just got one svg icon

get() {
	brightness_max=$(cat "$path"/max_brightness)
	brightness_cur=$(cat "$path"/brightness)

	percentage=$(echo "$brightness_cur * 100 / $brightness_max" | bc)
	icon_path="./images/icons/brightness/sun.svg"
	echo "{\"percentage\":\"$percentage\",\"icon_path\":\"$icon_path\"}"
}

[ -d /sys/class/backlight/intel_backlight ] && path="/sys/class/backlight/intel_backlight" || path="/sys/class/backlight/nvidia_0"

get

udevadm monitor | rg --line-buffered "backlight" | while read -r _
do
	get
done
