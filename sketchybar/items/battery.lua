local get_icon = require("icons.battery")

local num_hearts = 3
local num_per_heart = 4
local total_heart_states = num_hearts * num_per_heart
local item_ids = {}

for i = num_hearts, 1, -1 do
	local item_id = "battery." .. i
	local item_prop = {
		position = "right",
		icon = { drawing = "off" },
		label = { drawing = "off" },
		background = {
			drawing = "on",
			padding_left = 3,
			padding_right = 3,
		},
	}

	if i == num_hearts then
		item_prop.background.padding_right = 10
	elseif i == 1 then
		item_prop.background.padding_left = 10
	end

	sbar.add("item", item_id, item_prop)
	table.insert(item_ids, item_id)
end

local function calculate_heart_states(percentage)
	local states = {}
	local remaining = math.floor(percentage / 100 * total_heart_states)
	for i = 1, num_hearts do
		local health = math.min(remaining, num_per_heart)
		states[i] = health
		remaining = remaining - health
	end
	return states
end

local function update_all_batteries()
	sbar.exec("pmset -g batt", function(batt_info)
		sbar.begin_config()
		local percentage = batt_info:match("(%d+)%%")
		if not percentage then
			return
		end

		local percent_num = tonumber(percentage)
		local charging = batt_info:match("AC Power") and true or false

		local states = calculate_heart_states(percent_num)
		for i = 1, num_hearts do
			local item_id = "battery." .. i
			local icon = get_icon(states[i], charging)
			sbar.set(item_id, {
				background = { image = icon },
			})
		end
		sbar.end_config()
	end)
end

update_all_batteries()

local bracket = sbar.add("bracket", "bracket.battery", item_ids, {
	update_freq = 60,
	background = {
		drawing = "on",
		height = 0,
	},
})

bracket:subscribe({ "routine", "power_source_change", "system_woke" }, update_all_batteries)
