require("bar")
require("default")
require("items")

sbar.exec(
	"pkill -x sketchybar-toggle; ~/.bin/sketchybar-toggle --menu-bar-height 44 --debounce 200 --trigger-zone 5 --y-offset 0 &"
)
