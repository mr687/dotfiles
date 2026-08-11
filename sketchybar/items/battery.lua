local battery = sbar.add("item", "battery", {
	position = "right",
	update_freq = 120,
})

battery:subscribe({ "routine", "system_woke", "power_source_change" }, function(env)
	sbar.exec("pmset -g batt", function(batt_info)
		local percentage = batt_info:match("(%d+)%%")
		local charging = batt_info:match("AC Power") ~= nil

		if not percentage then
			return
		end

		local percent_num = tonumber(percentage)
		local icon = ""

		-- Determine icon and color based on percentage
		if percent_num >= 90 then
			icon = ""
		elseif percent_num >= 60 then
			icon = ""
		elseif percent_num >= 30 then
			icon = ""
		elseif percent_num >= 10 then
			icon = ""
		else
			icon = ""
		end

		-- Override with charging icon if charging
		if charging then
			icon = ""
		end

		battery:set({
			icon = { string = icon },
			label = { string = percentage .. "%" },
		})
	end)
end)
