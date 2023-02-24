#!/usr/bin/env bash
# return {icon_path, number_of_connected_devices, names (as string separated by space)}

get() {
	if [ "$(systemctl is-active bluetooth.service)" = "inactive" ]
	then
		echo "{\"icon_path\":\"./images/icons/bluetooth/bluetooth_off.svg\",\"number_of_connected_devices\":\"\",\"names\":\"\"}"
	else
		readarray -t names < <(bluetoothctl devices Connected | awk '{print $3}')
		number_of_connected_devices="${#names[@]}"
		if [ "$number_of_connected_devices" -eq 0 ]
		then
			echo "{\"icon_path\":\"./images/icons/bluetooth/bluetooth_on.svg\",\"number_of_connected_devices\":\"0\",\"names\":\"\"}"
		else
			echo "{\"icon_path\":\"./images/icons/bluetooth/bluetooth_connected.svg\",\"number_of_connected_devices\":\"$number_of_connected_devices\",\"names\":\"${names[*]}\"}"
		fi
	fi
}

refresh_rate=30
while true
do
	get
	sleep $refresh_rate
done
