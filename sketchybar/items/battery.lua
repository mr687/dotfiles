local colors = require("colors")
local get_icon = require("icons.battery")

local num_hearts = 3
local num_per_heart = 4
local total_heart_states = num_hearts * num_per_heart
local item_ids = {}
local items = {}
local charge_state = {
	percentage = "N/A",
	time_remaining = "No estimate",
}

for i = num_hearts, 1, -1 do
	local item_id = "battery." .. i
	local item_prop = {
		position = "right",
		icon = { drawing = "off" },
		label = {
			font = "battery-heart:regular:18.0",
			drawing = "on",
			padding_left = 0,
			padding_right = 0,
		},
	}

	if i == num_hearts then
		item_prop.label.padding_right = 6
	elseif i == 1 then
		item_prop.label.padding_left = 6
	end

	items[i] = sbar.add("item", item_id, item_prop)
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

		charge_state.percentage = percentage
		local percent_num = tonumber(percentage)
		local _, _, remaining = batt_info:find(" (%d+:%d+) remaining")
		charge_state.time_remaining = remaining and (remaining .. "h") or "No estimate"
		local charging = batt_info:match("AC Power") and true or false

		local states = calculate_heart_states(percent_num)
		for i = 1, num_hearts do
			local item_id = "battery." .. i
			local icon = get_icon(states[i], charging)
			sbar.set(item_id, {
				label = { string = icon },
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
		color = colors.BATTERY_BG_COLOR,
		corner_radius = 5,
		height = 26,
	},
	popup = {
		drawing = "off",
		align = "center",
		background = {
			drawing = "on",
			color = colors.BAR_COLOR,
			corner_radius = 10,
			border_width = 3,
			border_color = colors.BORDER_COLOR,
		},
	},
})

local bracket_popup = sbar.add("item", {
	position = "popup." .. bracket.name,
	icon = {
		align = "left",
	},
	label = {
		align = "right",
		string = "00:00h",
	},
})

local function toggle_bracket_popup()
	local is_shown = bracket:query().popup.drawing == "on"
	bracket:set({ popup = { drawing = not is_shown } })
	if not is_shown then
		bracket_popup:set({
			icon = charge_state.percentage .. "% | ",
			label = "Time remaining: " .. charge_state.time_remaining,
		})
	end
end

bracket:subscribe({ "routine", "power_source_change", "system_woke" }, update_all_batteries)
bracket:subscribe({ "mouse.clicked" }, toggle_bracket_popup)

for i = 1, #items do
	items[i]:subscribe({ "mouse.clicked" }, toggle_bracket_popup)
end
