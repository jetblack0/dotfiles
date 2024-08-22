#!/bin/sh

open() {
    read -r file
    [ -z "$file" ] && return 1

    eval "file=$file"

    if [ -e "$file" ]
    then
        nvim "$file" || return 1
    else
        echo "$file is not a legit file" >&2
        return 1
    fi
}

open_list="$HOME/Development/script/programs/fzf/file-list"
grep -v "^#" "$open_list" | grep -v "^$" | fzf | open
