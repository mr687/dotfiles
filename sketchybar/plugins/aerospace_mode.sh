#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace_mode.sh

mode="$(aerospace list-modes --current)"
if test "$mode" = "service"; then
  sketchybar --set "aerospace.mode" drawing=on
else
  sketchybar --set "aerospace.mode" drawing=off
fi
