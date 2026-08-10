#!/usr/bin/env bash

sketchybar --add item clock right \
  --set clock update_freq=30 icon.drawing=off script="$PLUGIN_DIR/clock.sh" \
  --add item battery right \
  --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change
