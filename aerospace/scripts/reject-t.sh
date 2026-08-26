#!/usr/bin/env bash
# ~/.config/aerospace/reject-t.sh
# Called from on-window-detected; AEROSPACE_WINDOW_ID inherited from callback context.
# Moves non-terminal window to first free numbered workspace (1–10).

wid="${AEROSPACE_WINDOW_ID:?}"

# Gate: only act when window landed in T
[ "$(aerospace echo --window-id "$wid" -- '%{workspace}')" = "T" ] || exit 0

# Find first free among 1–10
occupied="$(aerospace list-windows --all --format '%{workspace}' | sort -u)"
for w in $(seq 1 10); do
  grep -qx "$w" <<<"$occupied" || {
    aerospace move-node-to-workspace --window-id "$wid" "$w"
    exit 0
  }
done
