local colors = require("colors")

local front_app = sbar.add("item", "front_app", {
	label = {
		font = "Press Start 2P:Regular:10.0",
		shadow = {
			drawing = "off",
		},
	},
	icon = {
		drawing = "off",
	},
	background = {
		drawing = "on",
		color = colors.CLOCK_BG_COLOR,
		corner_radius = 5,
		height = 26,
	},
})

front_app:subscribe({ "front_app_switched" }, function(env)
	local app_name = env.INFO
	front_app:set({
		label = {
			string = app_name,
		},
	})
end)
