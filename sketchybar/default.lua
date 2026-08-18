local colors = require("colors")

sbar.default({
	padding_left = 5,
	padding_right = 5,
	icon = {
		font = "Hack Nerd Font:Bold:14.0",
		color = colors.FOREGROUND,
		padding_left = 10,
		padding_right = 10,
	},
	label = {
		padding_left = 10,
		padding_right = 10,
		font = "SF Pro:Semibold:14.0",
		color = colors.FOREGROUND,
	},
	background = {
		drawing = "off",
	},
	updates = "when_shown",
})
