#! /bin/bash

# Using fzf to find some desired files and open it with proper program

getFile() {
	if [ -f "$1" ]
	then
		echo "$1"
	elif [ -d "$1" ] && [ -n "$(ls "$1")" ]
	then
		for entry in "$1"/*
		do
			getFile "$entry"
		done
	fi
}

openFile () {
	read -r file
	if [ -s "$file" ]
	then
		dir="$(dirname "$file")"
		cd "$dir" || exit
		case "$(file --dereference --brief --mime-type -- "$file")" in
			text/*) $EDITOR "$file";;
		esac
	fi
}

desiredEntry=("$HOME/.config/alacritty" "$HOME/.config/kitty" "$HOME/.config/awesome" "$HOME/.config/clash" "$HOME/.config/nvim" "$HOME/.config/pfetch" "$HOME/.config/lf" "$HOME/.config/picom" "$HOME/.config/rofi" "$HOME/.config/macchina" "$HOME/.zshrc" "$HOME/.xinitrc" "$HOME/.bashrc" "$HOME/Development/MyScript" "/etc/systemd/system/clash.service")


for stuff in "${desiredEntry[@]}"
do
	getFile "$stuff"
done | fzf | openFile

