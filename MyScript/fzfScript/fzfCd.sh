#! /bin/bash

cdEntry() {
	read -r dir

	if [ -d "$dir" ]; then
		cd "$dir" || return 1
	else
		return 1
	fi
}

# add desired directories path to this file
cdEntry=($(cat "$HOME"/Development/MyScript/fzfScript/fzfCdList))

for entry in "${cdEntry[@]}"; do
	echo "$entry"
done | fzf | cdEntry
