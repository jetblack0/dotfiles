#!/bin/sh
# Swap the hyprland layout (master/dwindle).
#
# Usage: ./layout-switcher.sh [--list | --current | --next | <name>]

exec "$(dirname -- "$0")/hypr-switch.sh" layout "$@"
