#!/bin/sh
# a rofi frontend for pass.

# Usage:
# $1: color scheme of this rofi window, valid value: all files name inside ./theme/colorscheme directory, default to catppuccin if the color scheme is not found
# $2: font of this rofi popup
# $3: font size of this rofi popup
# for example: ./launcher.sh everforest Iosevka 15


set_color_and_font() {
	color_font_file="$ROFI_HOME/theme/font-color.rasi"

	if [ ! -f "$ROFI_HOME/theme/colorscheme/$color.rasi" ]
	then
		color="catppuccin"
	fi

	echo "@import \"$ROFI_HOME/theme/colorscheme/$color.rasi\"" > "$color_font_file"
	echo "* { font: \"$font $font_size\"; }" >> "$color_font_file"
}

ROFI_HOME="$HOME/.config/rofi"
THEME="$ROFI_HOME/theme/passmenu.rasi"

color="$1"
font="$2"
font_size="$3"

set_color_and_font

pass_all="$ROFI_HOME/component/pass/pass.sh"
pass_sites="$ROFI_HOME/component/pass/pass-sites.sh"
pass_keys="$ROFI_HOME/component/pass/pass-keys.sh"
pass_system="$ROFI_HOME/component/pass/pass-system.sh"
pass_onion="$ROFI_HOME/component/pass/pass-onion.sh"

rofi -steal-focus -normal-window -modi "sites:$pass_sites,keys:$pass_keys,system:$pass_system,links:$pass_onion" -show sites -theme "$THEME"
