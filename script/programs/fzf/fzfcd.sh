#!/bin/sh

# Description: a script that use fzf to change the current directory, put frequently accessed directories to $file. Each directories in $file are separated by a new line, empty lines and lines start with # are ignored

# Usage: source ./fzfcd.sh

change_dir() {
    read -r dir
    [ -z "$dir" ] && return 1

    eval "dir=$dir"

    if [ -d "$dir" ]
    then
        cd "$dir" || return 1
    else
        return 1
    fi
}

cd_list="$HOME/Development/script/programs/fzf/cd-list"
grep -v "^#" "$cd_list" | grep -v "^$" | fzf | change_dir
