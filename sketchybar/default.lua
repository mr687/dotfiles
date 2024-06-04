local user_config = require("user_config")
local padding = 3

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = user_config.font,
			style = "Bold",
			size = 14.0,
		},
		color = user_config.colors.white,
		padding_left = padding,
		padding_right = padding,
	},
	label = {
		font = {
			family = user_config.font,
			style = "SemiBold",
			size = 13.0,
		},
		color = user_config.colors.white,
		padding_left = padding,
		padding_right = padding,
	},
	background = {
		padding_left = padding,
		padding_right = padding,
	},
})
