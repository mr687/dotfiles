#!/usr/bin/env bash

if test -z "$NAME"; then
  NAME="$1"
fi

update_mode() {
  local mode
  mode="$(aerospace list-modes --current)"

  if test "$mode" = "service"; then
    sketchybar --set "$1" drawing=on
  else
    sketchybar --set "$1" drawing=off
  fi
}

update_workspace() {
  local focused
  focused="$(aerospace list-workspaces --focused --format "%{workspace}")"
  if test "$focused" = "$1"; then
    sketchybar --set "$NAME" background.drawing=on
  else
    sketchybar --set "$NAME" background.drawing=off
  fi
}

case "$NAME" in
*.mode)
  update_mode "$NAME"
  ;;
*.workspace.*)
  # shellcheck disable=SC2001
  current_workspace="$(echo "$NAME" | sed 's/^.*\.workspace\.//g')"

  has_workspace="no"
  workspaces="$(aerospace list-workspaces --all)"
  for workspace in $workspaces; do
    if test "$current_workspace" = "$workspace"; then
      has_workspace="yes"
      break
    fi
  done

  if test "$has_workspace" = "yes"; then
    update_workspace "$current_workspace"
  else
    sketchybar --remove "$NAME"
  fi
  ;;
*)
  workspaces="$(aerospace list-workspaces --all --json --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' | jq 'map(@base64).[]')"
  last_id=""
  for workspace64 in $workspaces; do
    workspace="$(echo "$workspace64" | jq -r '@base64d|fromjson|.workspace')"
    display="$(echo "$workspace64" | jq -r '@base64d|fromjson|."monitor-appkit-nsscreen-screens-id"//"active"')"

    item_id="$NAME.workspace.$workspace"

    existing_item="$(sketchybar --query "$item_id")"
    if test $? -ne 0; then
      item=(
        display="$display"
        label="$workspace"
        label.padding_left=5
        label.padding_right=5
        background.color=0x40ffffff
        background.corner_radius=5
        background.height=18
        background.drawing=off
        background.padding_left=2
        background.padding_right=2
        icon.drawing=off
        script="$PLUGIN_DIR/aerospace.sh"
      )
      sketchybar --add item "$item_id" left \
        --subscribe "$item_id" aerospace_workspace_change space_windows_change display_change system_woke front_app_switched \
        --set "$item_id" "${item[@]}"

      if test -n "$last_id"; then
        sketchybar --move "$item_id" after "$last_id"
      fi
    fi

    last_id="$item_id"
  done
  ;;
esac
