-- custom battery-heart font
local battery_icon_map = {
	[ [[heart_0]] ] = "",
	[ [[heart_1]] ] = "",
	[ [[heart_2]] ] = "",
	[ [[heart_3]] ] = "",
	[ [[heart_4]] ] = "",
	[ [[charge_heart_0]] ] = "",
	[ [[charge_heart_1]] ] = "",
	[ [[charge_heart_2]] ] = "",
	[ [[charge_heart_3]] ] = "",
	[ [[charge_heart_4]] ] = "",
}

return function(health, charging)
	local charging_prefix = charging and "charge_" or ""
	return battery_icon_map[charging_prefix .. "heart_" .. health] or battery_icon_map["heart_0"]
end
