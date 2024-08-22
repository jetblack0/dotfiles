#!/bin/sh
# send notification if the battery is lower then 10, suspend this computer if the battery is lower than 5

battery_low_count=0
refresh_rate=60

while true
do
	capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
	status="$(cat /sys/class/power_supply/AC/online)"

	if [ "$status" = "1" ]
	then
		battery_low_count=0
		sleep $refresh_rate
		continue
	fi

	if [ "$capacity" -lt 10 ] && [ $battery_low_count -eq 0 ]
	then
		if [ -z "$(who | grep "wayland")" ]
		then
			wall "please charge your laptop!"
		else
			dunstify -I /home/johnny/.config/dunst/images/icons/battery-low.svg "Battery notification" "please charge your laptop!"
		fi

		battery_low_count=1
	fi

	if [ "$capacity" -lt 5 ]
	then
		if [ -z "$(who | grep "wayland")" ]
		then
			wall "No battery left, I will suspend to prevent losing your work after 20 seconds!"
		else
			dunstify -u "crtical" -I /home/johnny/.config/dunst/images/icons/battery-empty.svg "Battery notification" "no battery left, I will suspend to prevent losing your work after 20 seconds!"
		fi

		sleep 20
		[ "$(cat /sys/class/power_supply/ADP0/online)" = "1" ] && continue
		systemctl suspend
	fi
	sleep $refresh_rate
done
