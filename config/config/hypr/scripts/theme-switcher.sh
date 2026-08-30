#!/bin/sh
# Swap the hyprland theme.
#
# Usage: ./theme-switcher.sh [--list | --current | --next | <name>]

exec "$(dirname -- "$0")/hypr-switch.sh" theme "$@"
