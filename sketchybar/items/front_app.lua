local front_app = sbar.add("item", "front_app", {
	padding_left = 0,
	label = {
		shadow = {
			drawing = "off",
		},
	},
	icon = {
		drawing = "off",
	},
	backgroung = {
		drawing = "off",
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
