#!/usr/bin/env bash

# Move PiP windows to current workspace (handles both "Picture-in-Picture" and "Picture in Picture")
# https://github.com/nikitabobko/AeroSpace/issues/2#issuecomment-3041947801
current_monitor=$(aerospace list-monitors --focused | awk '{print $1}')
current_workspace=$(aerospace list-workspaces --focused)
win_list=$(aerospace list-windows --monitor "$current_monitor" | grep -E "(Picture-in-Picture|Picture in Picture)" | awk '{print $1}')
echo "$win_list" | while IFS= read -r window_id; do
  if [ -n "$window_id" ]; then
    aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace" </dev/null
  fi
done

# Trigger sketchybar
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE" PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE"
