#!/bin/sh

for address in $(hyprctl -j clients | jaq -r '.[] | select(.workspace.id == 10) | .address'); do hyprctl dispatch movetoworkspacesilent $(hyprctl -j activeworkspace | gojq -r '.id'),address:"$address" ; done
