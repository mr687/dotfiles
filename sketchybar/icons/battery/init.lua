local icon_dir = "icons/battery/"

local battery_icon_map = {
	[ [[charge_heart_0]] ] = "charge_heart_0.png",
	[ [[charge_heart_1]] ] = "charge_heart_1.png",
	[ [[charge_heart_2]] ] = "charge_heart_2.png",
	[ [[charge_heart_3]] ] = "charge_heart_3.png",
	[ [[charge_heart_4]] ] = "charge_heart_4.png",
	[ [[heart_0]] ] = "heart_0.png",
	[ [[heart_1]] ] = "heart_1.png",
	[ [[heart_2]] ] = "heart_2.png",
	[ [[heart_3]] ] = "heart_3.png",
	[ [[heart_4]] ] = "heart_4.png",
}

return function(health, charging)
	local charging_prefix = charging and "charge_" or ""
	return icon_dir .. battery_icon_map[charging_prefix .. "heart_" .. health]
		or icon_dir .. battery_icon_map["heart_0"]
end
