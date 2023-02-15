#!/bin/sh

# Description: a script that use fzf to change the current directory, put directories that you use most to $file, each directories are separated by a new line, you can put # as comment, empty line doesn't matter

# Usage: source ./fzfCd.sh

change_dir() {
	read -r dir

	if [ -d "$dir" ]
	then
		cd "$dir" || return 1
	else
		return 1
	fi
}

file="$HOME/Development/myScript/fzfScript/fzfCdList"
grep -v "^#" "$file" | grep -v "^$" | fzf | change_dir
