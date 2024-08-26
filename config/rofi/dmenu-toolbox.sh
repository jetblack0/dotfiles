#!/bin/sh

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
THEME="$ROFI_HOME/theme/dmenu.rasi"
DMENU_SCRIPT="$ROFI_HOME/dmenu/"

color="$1"
font="$2"
font_size="$3"

set_color_and_font

tool="$(eza -1 "$DMENU_SCRIPT" | rofi -steal-focus -normal-window -theme "$THEME" -p "tool:" -dmenu)"

[ -z "$tool" ] && exit 0

"$DMENU_SCRIPT"/"$tool" "$color" "$font" "$font_size" 
