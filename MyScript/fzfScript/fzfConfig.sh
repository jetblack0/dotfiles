#! /bin/bash

# Using fzf to find some desired files and open it with proper program, slow af, try to use rg instead

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

desiredEntry=($(cat "$HOME"/Development/MyScript/fzfScript/fzfFileList))

for stuff in "${desiredEntry[@]}"; do
	getFile "$stuff"
done | fzf | openEntry
