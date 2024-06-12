local M = {}

function M.setup(opts)
	opts = opts or {}
	M.opts = opts

	local island_features = require("features")
	island_features.setup(opts)

	sbar.add("event", "dynamic_island_queue")
	sbar.add("event", "dynamic_island_request")

	local island = sbar.add("item", "island", {
		position = "center",
		drawing = true,
		mach_helper = "git.crissnb.islandhelper",
		update_freq = 5,
		width = 0,
		icon = { drawing = false },
		label = { drawing = false },
		background = { drawing = false },
	})
	sbar.exec("sketchybar --subscribe island dynamic_island_queue dynamic_island_request")

	-- sbar.add("event", "bluetooth_change", "UIDeviceBatteryStateDidChangeNotification")
	-- island:subscribe("bluetooth_change", function(env)
	-- 	print("bluetooth_change")
	-- 	for key, value in pairs(env.INFO) do
	-- 		print(key, value)
	-- 	end
	-- end)

	sbar.add("event", "di_helper_listener_event")
	local helper_listener = sbar.add("item", "di_helper_listener", {
		position = "center",
		width = 0,
		label = { drawing = false },
		icon = { drawing = false },
	})
	helper_listener:subscribe("di_helper_listener_event", function(env)
		local identifier = env.IDENTIFIER
		print("incoming: " .. identifier)
		island_features.update(env)
	end)
end

return M
