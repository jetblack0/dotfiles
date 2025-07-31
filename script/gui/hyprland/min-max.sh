#!/usr/bin/env bash

# Each workspace has its own secret workspace to minimize its windows to,
# and a single keybinding should bring those windows back.
# It would be nice if we can bring back each individual hidden window using
# waybar, with each hidden window is shown with its xdg icon.
# 
# NOTE: Waybar doesn't support dynamically render images, see: 
# https://github.com/Alexays/Waybar/pull/3151

set -o pipefail

function min() {
  hyprctl dispatch movetoworkspacesilent $target_space
}

function maxall() {
  for address in $(hyprctl -j clients | jaq -r ".[] | select(.workspace.id ==
    $target_space) | .address"); do
    hyprctl dispatch movetoworkspacesilent "$cur_space",address:"$address"
  done
}

# Get icons for applications in hidden windows, suppose to be used by waybar,
# but not supported yet.
function get_icon() {
  local cmd owned_package desktop_entry xdg_name
  hyprctl -j clients | jaq -r ".[] | select(.workspace.id == 1) | .pid" | while IFS= read -r pid; do
    {
      cmd=$(ps -o cmd= -p "$pid" | cut -d ' ' -f 1)
      owned_package=$(pacman -Qo "$cmd" 2>/dev/null | awk '{print $(NF-1)}')
      desktop_entry=$(pacman -Ql "$owned_package" 2>/dev/null | grep \
        '.*\.desktop$' | awk '{print $2}' | head -n 1)
    } || return 1

    xdg_name=$(
      awk -v sec='[Desktop Entry]' '
        $0 == sec { in_section = 1; next }
        in_section && /^\[/     { in_section = 0 }
        in_section && /^Icon=/  { split($0, a, "="); print a[2] }
      ' "$desktop_entry"
    )

    # Embedded Python code to get the icon path, didn't find a better way to do
    # this except using the gtk lib. TODO: Maybe I should implement this whole
    # thing in Python.
    python3 - "$xdg_name" << 'EOF'
import gi
import sys
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

icon_name = sys.argv[1]
icon_size = 16

icon_theme = Gtk.IconTheme.get_default()
icon_info = icon_theme.lookup_icon(icon_name, icon_size, 0)

if icon_info:
    print(icon_info.get_filename())
else:
    sys.stderr.write("icon not found\n")
    sys.exit(1)
EOF
  done
}


# Suppose to return a specific hidden window by clicking the icon in waybar, but
# since it's not been implemented yet, don't know that information is available
# and can be passed as a argument to this script.
# Positional arguments (first button, second button), or the window address
# would work for this script. 
# function max() {
# }



function main() {
  cur_winid=$(hyprctl -j activewindow | gojq -r '.address')
  cur_space=$(hyprctl -j activeworkspace | gojq -r '.id')
  target_space=$(( cur_space + 100 ))
  fallback_icon=".fallback.png"

  case "$1" in
    min)
      min
      ;;
    max)
      echo "not implemented yet"
      ;;
    maxall)
      maxall
      ;;
    geticon)
      if ! get_icon; then
        windows=$(hyprctl -j activeworkspace | gojq '.windows')
        for ((i = 1; i <= windows; i++)); do
          echo "$fallback_icon"
        done
      fi
      ;;
    *)
      echo "Usage: ./minmax.sh <min | max | maxall | geticon> [ARG]"
      exit 1
      ;;
  esac
}

main "$@"
