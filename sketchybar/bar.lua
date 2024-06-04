local user_config = require("user_config")

sbar.bar({
	display = user_config.display,
	position = "top",
	shadow = "off",
	sticky = "off",
	topmost = "on",
	padding_right = 0,
	padding_left = 0,
	height = user_config.notch.height,
	color = user_config.colors.black,
	corner_radius = user_config.notch.corner_radius,
	y_offset = -user_config.notch.corner_radius,
	-- y_offset = 40,
	margin = (user_config.monitor.x_resolution / 2) - user_config.notch.width,
	notch_width = 0,
})
