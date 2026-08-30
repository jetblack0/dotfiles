#!/bin/sh
# Swap the hyprland animation set.
#
# Usage: ./animation-switcher.sh [--list | --current | --next | <name>]

exec "$(dirname -- "$0")/hypr-switch.sh" animation "$@"
