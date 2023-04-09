#!/bin/sh
# Description: a script to toggle the dark or light theme for programs that i can find a way to achieve this, definitely only works on my machine
# $1: dark, light or toggle
# Usage: source ./night_shift.sh

# use alacritty as the indicator of the current theme
get_toggle_theme() {
	line=$(grep -io "catppuccin-.*" ~/.config/alacritty/alacritty.yml)
	if [ "$line" = "catppuccin-mocha.yml" ]
	then
		echo "$light_theme"
	elif [ "$line" = "catppuccin-latte.yml" ]
	then
		echo "$dark_theme"
	fi
}

alacritty_theme() {
	location="$XDG_CONFIG_HOME/alacritty/alacritty.yml"

	sed -i -E "s/catppuccin-(latte|mocha).yml/catppuccin-$next_theme.yml/g" "$location"
}

neovim_theme() {
	location="$XDG_CONFIG_HOME/nvim/lua/pluginConfig/catppuccin.lua"
	location_illuminate="$XDG_CONFIG_HOME/nvim/lua/pluginConfig/illuminate.lua"

	if [ "$next_theme" = "mocha" ]
	then
		illuminate_color="#45475A"
	else
		illuminate_color="#F5C2E7"
	fi

	sed -i -E "s/flavour = \"(mocha|latte)\"/flavour = \"$next_theme\"/g" "$location"
	sed -i -E "s/bg = \"(#F5C2E7|#45475A)\"/bg = \"$illuminate_color\"/g" "$location_illuminate"
}

tmux_theme() {
	location="$XDG_CONFIG_HOME/tmux/tmux.conf"
	sed -i -E "s/(mocha|latte).conf/$next_theme.conf/g" "$location"

	if [ -n "$(pgrep tmux)" ]
	then
		tmux source-file "$location"
	fi
}

bat_theme() {
	location="$XDG_CONFIG_HOME/bat/config"

	sed -i -E "s/Catppuccin-(latte|mocha)/Catppuccin-$next_theme/g" "$location"
}

fzf_theme() {
	location="$XDG_CONFIG_HOME/shell/zsh/.zshenv"

	dark_config='--height 50% --layout=reverse --cycle --border=rounded --color=bw,spinner:#f4dbd6,hl:#F5BDE6:regular,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#B7BDF8:regular,prompt:#c6a0f6,hl+:#F5BDE6:regular'
	light_config='--height 50% --layout=reverse --cycle --border=rounded --color=bw,spinner:#dc8a78,hl:#EA76CB:regular,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#dc8a78,fg+:#179299:regular,prompt:#8839ef,hl+:#EA76CB:regular'

	if [ "$next_theme" = "mocha" ]
	then
		sed -i -E "s/FZF_DEFAULT_OPTS='.*'/FZF_DEFAULT_OPTS='$dark_config'/" "$location"
	else
		sed -i -E "s/FZF_DEFAULT_OPTS='.*'/FZF_DEFAULT_OPTS='$light_config'/" "$location"
	fi

	source "$XDG_CONFIG_HOME/shell/zsh/.zshenv"
}

qt5_theme() {
	location="$XDG_CONFIG_HOME/qt5ct/qt5ct.conf"

	sed -E -i "s/catppuccin_(latte|mocha)/catppuccin_$next_theme/" "$location"
}

gtk_theme() {
	gtk_three_location="$XDG_CONFIG_HOME/gtk-3.0/settings.ini"
	gtk_two_location="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

	if [ "$next_theme" = "mocha" ]
	then
		dark_or_light="Dark"
	else
		dark_or_light="Light"
	fi

	sed -E -i "2 s/Catppuccin-(Latte|Mocha)-Standard-Pink-(Light|Dark)/Catppuccin-$(echo "$next_theme" | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }')-Standard-Pink-$dark_or_light/" "$gtk_three_location"
	sed -E -i "5 s/Catppuccin-(Latte|Mocha)-Standard-Pink-(Light|Dark)/Catppuccin-$(echo "$next_theme" | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }')-Standard-Pink-$dark_or_light/" "$gtk_two_location"
}

xwayland_theme() {
	if [ "$next_theme" = "mocha" ]
	then
		xrdb -load /home/jetblack/.config/X11/.Xresources_dark
	else
		xrdb -load /home/jetblack/.config/X11/.Xresources_light
	fi
}

hyprland_theme() {
	location="$XDG_CONFIG_HOME/hypr/hyprland.conf"
	if [ "$next_theme" = "mocha" ]
	then
		inactive_border_color="0xff1e1e2e"

		active_border_color_one="0xffb4befe"
		active_border_color_two="0xfff5c2e7"

	else
		inactive_border_color="0xffeff1f5"

		active_border_color_one="0xff1e1e2e"
		active_border_color_two="0xff1e1e2e"
	fi

	sed -E -i -e "s/col.inactive_border = (0xff1e1e2e|0xffeff1f5)/col.inactive_border = $inactive_border_color/" -e "s/col.active_border = .*/col.active_border = $active_border_color_one $active_border_color_two 45deg/" "$location"
}

rofi_theme() {
	location="$XDG_CONFIG_HOME/hypr/hyprland.conf"

	if [ "$next_theme" = "mocha" ]
	then
		next_rofi_theme="catppuccin"
	else
		next_rofi_theme="paper"
	fi

	sed -E -i -e "s/launcher.sh (catppuccin|paper)/launcher.sh $next_rofi_theme/" -e "s/powermenu.sh (catppuccin|paper)/powermenu.sh $next_rofi_theme/" "$location"
}

bottom_theme() {
	location="$XDG_CONFIG_HOME/bottom"

	if [ "$next_theme" = "mocha" ]
	then
		cat "$location"/bottom_dark.toml > "$location"/bottom.toml
	else
		cat "$location"/bottom_light.toml > "$location"/bottom.toml
	fi
}

newboat_theme() {
	location="$XDG_CONFIG_HOME/newsboat/config"

	if [ "$next_theme" = "mocha" ]
	then
		sed -E -i "s/(dark|light)/light/" "$location"
	else
		sed -E -i "s/(dark|light)/dark/" "$location"
	fi
}

lualine_theme() {
	location="$XDG_CONFIG_HOME/nvim/lua/pluginConfig/lualine.lua"

	if [ "$next_theme" = "mocha" ]
	then
		color_added="green_diff"
		color_modified="orange_diff"
		color_removed="red_diff"
	else
		color_added="green_diff_light"
		color_modified="orange_diff_light"
		color_removed="red_diff_light"
	fi

	sed -E -i "s/added.*fg = .*}/added = { fg = colors.$color_added }/" "$location"
	sed -E -i "s/modified.*fg = .*}/modified = { fg = colors.$color_modified }/" "$location"
	sed -E -i "s/removed.*fg = .*}/removed = { fg = colors.$color_removed }/" "$location"
}

fcitx5_theme() {
	location="$XDG_CONFIG_HOME/fcitx5/conf/classicui.conf"

	sed -E -i "s/catppuccin-(mocha|latte)/catppuccin-$next_theme/" "$location"

	# restart fcitx5
	kill "$(pidof fcitx5)" && fcitx5 -d > /dev/null 2>&1
}

swaylock_theme() {
	location="$XDG_CONFIG_HOME/swaylock/config"

	if [ "$next_theme" = "mocha" ]
	then
		next_wall="\/home\/jetblack\/Pictures\/Wallpaper\/landscape\/nature\/wallhaven-eyelqr\.jpg"
	else
		next_wall="\/home\/jetblack\/Pictures\/Wallpaper\/landscape\/simple\/minimalist-cat-window-sleeping-4k-tl-2048x1152\.jpg"
	fi

	sed -i -E "s/image=.*/image=$next_wall/" "$location"
}

eww_theme() {
	location="$XDG_CONFIG_HOME/eww/eww.scss"

	if [ "$next_theme" = "mocha" ]
	then
		clock_background="#F5C2E7"
		clock_foreground="#000000"
		buttons_background="#C6AAE8"
		system_icon_background="#BAB4D9"
		indicator_background="#BAB4D9"
		progressbar_empry_background="#A5ADCB"
		progressbar_fill="#7B9C98"
		workspace_background="#BAB4D9"
		tooltip_background="#BAB4D9";
		tooltip_foreground="#1E1E2E";
		calendar_selected_foreground="#D3859A";
		calendar_empty_foreground="#70706C";
		music_box_background="#BAB4D9";
		widget_border_length="0px"
		calendar_background_color="#F5C2E7"
	else
		clock_background="#7B9C98"
		clock_foreground="#000000"
		buttons_background="#EFF1F5"
		system_icon_background="#EFF1F5"
		indicator_background="#EFF1F5"
		progressbar_empry_background="#D6D3D6"
		progressbar_fill="#7B9C98"
		workspace_background="#EFF1F5"
		tooltip_background="#EFF1F5";
		tooltip_foreground="#1E1E2E";
		calendar_selected_foreground="#179299";
		calendar_empty_foreground="#70706C";
		music_box_background="#EFF1F5";
		widget_border_length="2px"
		calendar_background_color="#EFF1F5"
	fi

	sed -E -i "s/clock_background: #[A-Za-z0-9]{6}/clock_background: $clock_background/" "$location"
	sed -E -i "s/clock_foreground: #[A-Za-z0-9]{6}/clock_foreground: $clock_foreground/" "$location"
	sed -E -i "s/buttons_background: #[A-Za-z0-9]{6}/buttons_background: $buttons_background/" "$location"
	sed -E -i "s/system_icon_background: #[A-Za-z0-9]{6}/system_icon_background: $system_icon_background/" "$location"
	sed -E -i "s/indicator_background: #[A-Za-z0-9]{6}/indicator_background: $indicator_background/" "$location"
	sed -E -i "s/progressbar_empry_background: #[A-Za-z0-9]{6}/progressbar_empry_background: $progressbar_empry_background/" "$location"
	sed -E -i "s/progressbar_fill: #[A-Za-z0-9]{6}/progressbar_fill: $progressbar_fill/" "$location"
	sed -E -i "s/workspace_background: #[A-Za-z0-9]{6}/workspace_background: $workspace_background/" "$location"
	sed -E -i "s/tooltip_background: #[A-Za-z0-9]{6}/tooltip_background: $tooltip_background/" "$location"
	sed -E -i "s/tooltip_foreground: #[A-Za-z0-9]{6}/tooltip_foreground: $tooltip_foreground/" "$location"
	sed -E -i "s/calendar_selected_foreground: #[A-Za-z0-9]{6}/calendar_selected_foreground: $calendar_selected_foreground/" "$location"
	sed -E -i "s/calendar_empty_foreground: #[A-Za-z0-9]{6}/calendar_empty_foreground: $calendar_empty_foreground/" "$location"
	sed -E -i "s/music_box_background: #[A-Za-z0-9]{6}/music_box_background: $music_box_background/" "$location"
	sed -E -i "s/widget_border_length: [0-9]px/widget_border_length: $widget_border_length/" "$location"
	sed -E -i "s/calendar_background_color: #[A-Za-z0-9]{6}/calendar_background_color: $calendar_background_color/" "$location"
}

dark_theme="mocha"
light_theme="latte"

case "$1" in
	dark) next_theme=$dark_theme ;;
	light) next_theme=$light_theme ;;
	toggle|*) next_theme=$(get_toggle_theme) ;;
esac

# cli part
alacritty_theme
neovim_theme
tmux_theme
bat_theme
fzf_theme
bottom_theme
newboat_theme
lualine_theme

# gui part
qt5_theme
gtk_theme
xwayland_theme
hyprland_theme
rofi_theme
fcitx5_theme
swaylock_theme
eww_theme
