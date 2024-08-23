#!/bin/sh

# fullscreen powermenu using your bluured wallpaper as background, execute command with no question asked

# usage:
# $1: color scheme of this rofi window, valid value: all files name inside ./theme/colorscheme directory, default to catppuccin if the color scheme is not found
# $2 (optional): font of this rofi popup
# $3 (optional): font size of this rofi popup
# for example, ./powermenu.sh catppuccin Iosevka 15 or simply ./powermenu.sh

set_color_and_font() {
	color_font_file="$ROFI_HOME/theme/font-color.rasi"

	if [ ! -f "$ROFI_HOME/theme/colorscheme/$color.rasi" ] || [ -z "$color" ]
	then
		color="catppuccin"
	fi
	echo "@import \"$ROFI_HOME/theme/colorscheme/$color.rasi\"" > "$color_font_file"

	if [ -n "$font" ] && [ -n "$font_size" ]
	then
		font="Iosevka"
		font_size=15
	fi
	echo "* { font: \"$font $font_size\"; }" >> "$color_font_file"
}

rofi_cmd() {
	rofi -steal-focus -normal-window -dmenu \
		-theme "$THEME"
}

run_rofi() {
	printf "%s\n%s\n%s\n%s\n%s\n" "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
}


ROFI_HOME="$HOME/.config/rofi"
THEME="$ROFI_HOME/theme/powermenu.rasi"

color="$1"
font="$2"
font_size="$3"

shutdown=''
reboot=''
lock=''
suspend=''
logout=''


set_color_and_font
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
sac
