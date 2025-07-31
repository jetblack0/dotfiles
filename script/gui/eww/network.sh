#!/bin/sh
# return {icon, essid, signal}

get() {
	if [ "$(cat $path_one)" = "1" ] || [ -e $path_two ]
	then
		echo '{"icon_path":"./images/icons/network/plugged.svg", "name":""}'
		exit
	fi

	info=$(nmcli -t -f active,ssid,signal dev wifi | grep "^yes")

	if [ -z "$info" ]
	then
		echo '{"icon_path":"./images/icons/network/wifi_off.svg", "name":""}'
		exit
	else
		essid=$(echo "$info" | awk -F ':' '{print $2}')
		signal=$(echo "$info" | awk -F ':' '{print $3}')
		if [ "$signal" -gt 80 ]
		then
			echo "{\"icon_path\":\"./images/icons/network/wifi_5.svg\", \"name\":\"$essid\"}"
		elif [ "$signal" -gt 60 ]
		then
			echo "{\"icon_path\":\"./images/icons/network/wifi_4.svg\", \"name\":\"$essid\"}"
		elif [ "$signal" -gt 40 ]
		then
			echo "{\"icon_path\":\"./images/icons/network/wifi_3.svg\", \"name\":\"$essid\"}"
		elif [ "$signal" -gt 20 ]
		then
			echo "{\"icon_path\":\"./images/icons/network/wifi_2.svg\", \"name\":\"$essid\"}"
		else 
			echo "{\"icon_path\":\"./images/icons/network/wifi_1.svg\", \"name\":\"$essid\"}"
		fi
	fi
}

path_two="/sys/class/net/enp0s20f0u1c4i2/carrier"
path_one="/sys/class/net/enp7s0/carrier"
refresh_rate=60

while true
do
	get
	sleep $refresh_rate
done
