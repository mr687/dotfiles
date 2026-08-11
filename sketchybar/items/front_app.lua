local front_app = sbar.add("item", "front_app", {
	icon = {
		drawing = "off",
	},
})

front_app:subscribe({ "front_app", "front_app_switched" }, function(env)
	local sender = env.SENDER
	local app_name = env.INFO
	if sender == "front_app_switched" then
		front_app:set({
			label = {
				string = app_name,
			},
		})
	end
end)
