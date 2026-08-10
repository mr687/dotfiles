#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_mode_change

sketchybar --add item aerospace.mode left \
  --subscribe aerospace.mode aerospace_mode_change \
  --set aerospace.mode label="(S)" drawing=off script="$PLUGIN_DIR/aerospace.sh"

sketchybar --add item aerospace left \
  --subscribe aerospace aerospace_workspace_change display_change system_woke front_app_switched \
  --set aerospace \
  drawing=off \
  script="$PLUGIN_DIR/aerospace.sh"

"$PLUGIN_DIR/aerospace.sh" aerospace
