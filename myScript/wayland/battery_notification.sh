#!/bin/sh

# send notification if the battery is lower then 10, suspend this computer if the battery is lower than 5
# NOTE: maybe not a good idea to use systemd timer for this, just start thsi script with your compositor

battery_low_count=0
refresh_rate=60
while true
do
	capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
	status="$(cat /sys/class/power_supply/ADP0/online)"

	if [ "$status" = "1" ]
	then
		battery_low_count=0
		sleep $refresh_rate
		continue
	fi

	if [ "$capacity" -lt 10 ] && [ $battery_low_count -eq 0 ]
	then
		dunstify -I ~/.config/dunst/images/icons/battery_low.svg "please charge your laptop !"
		battery_low_count=1
	fi

	if [ "$capacity" -lt 5 ]
	then
		dunstify -u "crtical" -I ~/.config/dunst/images/icons/battery_empty.svg "No battery left, I will suspend to prevent losing your work after 20 seconds !"
		sleep 20
		[ "$(cat /sys/class/power_supply/ADP0/online)" = "1" ] && continue
		systemctl suspend
	fi
	sleep $refresh_rate
done
