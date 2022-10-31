#! /bin/bash

# Description: a script that open all the files in the desired directories with different programs depending on its mimetype by fzf. For example, if you add path /home/user/.config to the desired path, this script will list all the files in this directory using fzf, and open text files with vim, image files with feh, etc. You can define what programs to open them. Change the path in the code below "cat "$HOME"/Development/myScript/fzfScript/fzfFileList" to the path that you add your desired directory path 

# Note: the directory path in that file should be absolute path, you can separate each path by white space or carriage return 

# Usage: run command, ./fzfConfig.sh


# Get the all the files inside a directory recursively
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

		# Define what programs you wanna use to open different type of files
		case "$(file --dereference --brief --mime-type -- "$file")" in
		image/*) feh "$file" ;;
		*) $EDITOR "$file" ;;
		esac
	fi
}

desiredEntry=($(cat "$HOME"/Development/myScript/fzfScript/fzfFileList))

for stuff in "${desiredEntry[@]}"; do
	getFile "$stuff"
done | fzf | openEntry
