#! /bin/bash

# Description: a script that use fzf to change the current directory, you can add directories that you use most to a file and replace the path in the code "cat "$HOME"/Development/myScript/fzfScript/fzfCdList" to that file.

# Note: the directory path in that file should be absolute path, you can separate each path by white space or carriage return

# Usage: run command, ./fzfCd.sh


cdEntry() {
	read -r dir

	if [ -d "$dir" ]; then
		cd "$dir" || return 1
	else
		return 1
	fi
}

# add desired directories path to this file
cdEntry=($(cat "$HOME"/Development/myScript/fzfScript/fzfCdList))

for entry in "${cdEntry[@]}"; do
	echo "$entry"
done | fzf | cdEntry
