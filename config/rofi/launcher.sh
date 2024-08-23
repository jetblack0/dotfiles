#!/bin/sh
# A rofi script to launch program, select emoji and nerd font icon

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
THEME="$ROFI_HOME/theme/launcher.rasi"

color="$1"
font="$2"
font_size="$3"

set_color_and_font

emoji_cmd="$ROFI_HOME/component/emoji.sh"
nerdicon_cmd="$ROFI_HOME/component/nerdicon.sh"

rofi -steal-focus -normal-window -modi "drun,multihead:$emoji_cmd,mail:$nerdicon_cmd" -show drun -theme "$THEME"
