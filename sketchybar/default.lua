local colors = require("colors")

sbar.default({
	padding_left = 5,
	padding_right = 5,
	icon = {
		font = "Hack Nerd Font:Bold:17.0",
		color = colors.FOREGROUND,
		padding_left = 4,
		padding_right = 4,
	},
	label = {
		font = "Hack Nerd Font:Bold:14.0",
		color = colors.FOREGROUND,
		padding_left = 4,
		padding_right = 4,
	},
	updates = "when_shown",
})
