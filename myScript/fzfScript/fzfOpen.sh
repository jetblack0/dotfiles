#!/bin/sh

open() {
	read -r file

	if [ -e "$file" ]
	then
		nvim "$file" || return 1
	else
		return 1
	fi
}

file="$HOME/Development/myScript/fzfScript/fzfFileList"
grep -v "^#" "$file" | grep -v "^$" | fzf | open


