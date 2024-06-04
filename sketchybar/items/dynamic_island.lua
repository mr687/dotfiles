sbar.add("event", "dynamic_island_queue")
sbar.add("event", "dynamic_island_request")

sbar.add("item", "island", {
	position = "center",
	drawing = true,
	mach_helper = "git.crissnb.islandhelper",
	update_freq = 5,
	width = 0,
	label = { drawing = false },
	icon = { drawing = false },
})
sbar.exec("sketchybar --subscribe island dynamic_island_queue dynamic_island_request")

local features = require("items.dynamic_island_features")

sbar.add("event", "di_helper_listener_event")

local listener = sbar.add("item", "di_helper_listener", {
	position = "center",
	width = 0,
	label = { drawing = false },
	icon = { drawing = false },
})

listener:subscribe("di_helper_listener_event", function(env)
	local identifier = env.IDENTIFIER
	print("incoming: " .. identifier)

	if identifier == "volume" and features.volume then
		features.volume.update(env)
	elseif identifier == "brightness" and features.brightness then
		features.brightness.update(env)
	elseif identifier == "appswitch" and features.appswitch then
		features.appswitch.update(env)
	elseif identifier == "power" and features.power then
		features.power.update(env)
	end
end)
