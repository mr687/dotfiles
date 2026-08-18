local colors = require("colors")

local clock = sbar.add("item", "clock", {
	position = "right",
	padding_left = 10,
	padding_right = 0,
	update_freq = 30,
	label = {
		font = "alarm clock:Regular:14.0",
	},
	icon = { drawing = "off" },
	background = {
		drawing = "on",
		color = colors.CLOCK_BG_COLOR,
		corner_radius = 5,
		height = 26,
	},
})

clock:subscribe({ "routine", "forced", "system_woke" }, function(env)
	clock:set({ label = { string = os.date("%b,%d %I:%M %p") } })
end)
