require("items.clock")
require("items.battery")
require("items.diora_age")
require("items.aerospace")
require("items.front_app")
require("items.now_playing")

sbar.exec(
	"pgrep -f '[s]ketchybar-now-playing daemon' >/dev/null || "
		.. "~/.cargo/bin/sketchybar-now-playing daemon >>/tmp/sketchybar-now-playing.log 2>&1 &"
)
