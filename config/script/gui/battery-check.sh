#!/usr/bin/env bash

get_capacity() {
	total_capacity=0

	while read -r capacity
	do
		total_capacity=$(( total_capacity + capacity))
	done < <(cat /sys/class/power_supply/BAT*/capacity)

	echo "$total_capacity"
}

status="$(cat /sys/class/power_supply/AC/online)"
capacity=$(get_capacity)
urgency="low"

if [ "$status" = "1" ]
then
	path=$HOME/.config/eww/images/icons/battery/charging
else
	path=$HOME/.config/eww/images/icons/battery/normal
fi

if [ "$capacity" -gt 90 ]
then
	icon_path="$path"/100.svg
elif [ "$capacity" -gt 80 ]
then
	icon_path="$path"/90.svg
elif [ "$capacity" -gt 70 ]
then
	icon_path="$path"/80.svg
elif [ "$capacity" -gt 60 ]
then
	icon_path="$path"/70.svg
elif [ "$capacity" -gt 50 ]
then
	icon_path="$path"/60.svg
elif [ "$capacity" -gt 40 ]
then
	icon_path="$path"/50.svg
elif [ "$capacity" -gt 30 ]
then
	icon_path="$path"/40.svg
elif [ "$capacity" -gt 20 ]
then
	icon_path="$path"/30.svg
elif [ "$capacity" -gt 10 ]
then
	urgency="critical"
	icon_path="$path"/20.svg
else
	urgency="critical"
	icon_path="$path"/10.svg
fi

dunstify -u $urgency -I $icon_path "battery left: $capacity %"
