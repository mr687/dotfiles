sbar = require("sketchybar")

sbar.begin_config()

require("island").setup({})

sbar.end_config()

sbar.event_loop()
