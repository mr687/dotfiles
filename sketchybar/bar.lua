local colors = require("colors")

sbar.bar({
	topmost = "window", -- REQUIRED for sketchybar-toggle
	position = "top",
	height = 44,
	blur_radius = 0,
	notch_width = 240,
	color = colors.TRANSPARENT,
})
