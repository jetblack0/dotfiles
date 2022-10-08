#! /bin/bash

# Using fzf to find some desired files and open it with proper program

getFile() {
	if [ -f "$1" ]; then
		echo "$1"
	elif [ -d "$1" ] && [ -n "$(ls "$1")" ]; then
		for entry in "$1"/*; do
			getFile "$entry"
		done
	fi
}

openEntry() {
	read -r file
	if [ -s "$file" ]; then
		dir="$(dirname "$file")"
		cd "$dir" || exit

		case "$(file --dereference --brief --mime-type -- "$file")" in
		image/*) feh "$file" ;;
		*) $EDITOR "$file" ;;
		esac
	fi
}

desiredEntry=(
	"$HOME/.config/alacritty" "$HOME/.config/kitty" "$HOME/.config/awesome" "$HOME/.config/clash" "$HOME/.config/nvim" "$HOME/.config/pfetch" "$HOME/.config/lf" "$HOME/.config/picom" "$HOME/.config/rofi" "$HOME/.config/macchina" "$HOME/.config/shell/zsh/.zshrc" "$HOME/.config/shell/.inputrc" "$HOME/.config/X11/.xinitrc" "$HOME/.config/X11/.Xresources" "$HOME/.config/shell/zsh/plugins/appearance"
	"$HOME/.bashrc" "$HOME/Development/MyScript" "$HOME/.config/fontconfig"
)

# TODO: look up getopt command
for stuff in "${desiredEntry[@]}"; do
	getFile "$stuff"
done | fzf | openEntry
