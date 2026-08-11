local clock = sbar.add("item", "clock", {
	position = "right",
	update_freq = 30,
	icon = { drawing = "off" },
	background = { drawing = "off" },
})

clock:subscribe({ "routine", "forced", "system_woke" }, function(env)
	clock:set({ label = { string = os.date("%a %d %b %I:%M %p") } })
end)
