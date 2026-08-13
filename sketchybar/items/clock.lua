local colors = require("colors")

local clock = sbar.add("item", "clock", {
	position = "right",
	update_freq = 30,
	label = {
		font = "alarm clock:Regular:14.0",
		padding_left = 5,
		padding_right = 5,
	},
	icon = { drawing = "off" },
	background = {
		drawing = "on",
		color = colors.BACKGROUND_SPACE_ACTIVE,
		corner_radius = 5,
		height = 23,
	},
})

clock:subscribe({ "routine", "forced", "system_woke" }, function(env)
	clock:set({ label = { string = os.date("%b,%d %I:%M %p") } })
end)
