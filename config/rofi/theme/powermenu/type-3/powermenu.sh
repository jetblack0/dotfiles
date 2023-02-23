#!/bin/sh

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# fullscreen powermenu using your wallpaper and add blurred effect, execute command with no question asked
# usage: ./powermenu.sh

dir="/home/jetblack/.config/rofi/theme/powermenu/type-3/"
theme='style-6'

shutdown=''
reboot=''
lock=''
suspend=''
logout=''

rofi_cmd() {
	rofi -dmenu \
		-theme ${dir}/${theme}.rasi
}

run_rofi() {
	printf "%s\n%s\n%s\n%s\n%s\n" "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
}

chosen="$(run_rofi)"
case ${chosen} in
    "$shutdown")
		systemctl poweroff
        ;;
    "$reboot")
		systemctl reboot
        ;;
    "$lock")
		swaylock
        ;;
    "$suspend")
		mpc -q pause
		amixer set Master mute
		systemctl suspend
        ;;
    "$logout")
		hyprctl dispatch exit
        ;;
esac
