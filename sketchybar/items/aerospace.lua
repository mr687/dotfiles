local colors = require("colors")
local icons_map = require("icons")

-- Helper function to execute shell commands and get output
local function exec(command)
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+$", "")
end

-- Helper function to get lines from command output
local function exec_lines(command)
	local lines = {}
	for line in exec(command):gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	return lines
end

function trim(s)
	return s:match("^%s*(.-)%s*$")
end

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_monitor_change")
sbar.add("event", "aerospace_mode_change")

sbar.add("item", "aerospace.mode", {
	position = "left",
	label = { string = "" },
	icon = { drawing = "off" },
	background = { drawing = "off" },
	drawing = "off",
})

local workspace_states = {}
local all_workspaces = exec_lines(
	"aerospace list-workspaces --all --format '%{workspace}|%{monitor-is-main}|%{monitor-appkit-nsscreen-screens-id}'"
)

for _, space in ipairs(all_workspaces) do
	local space_id, monitor_is_main, monitor_id = space:match("([^|]+)|([^|]+)|([^|]+)")

	local label_y_offset = 0
	if monitor_is_main ~= "true" then
		label_y_offset = -1
	end

	-- Create space item
	sbar.add("item", "aerospace." .. space_id, {
		position = "left",
		display = monitor_id,
		drawing = "off",
		icon = {
			string = space_id,
			padding_left = 5,
			padding_right = 5,
			shadow = { drawing = "off" },
		},
		label = {
			font = "sketchybar-app-font:Regular:12.0",
			padding_left = 0,
			padding_right = 6,
			y_offset = label_y_offset,
			shadow = { drawing = "off" },
		},
		background = {
			drawing = "on",
			color = colors.BACKGROUND_SPACE_ACTIVE,
			corner_radius = 5,
			height = 23,
			border_color = colors.BORDER_COLOR,
			border_width = 1,
			padding_left = 0,
			padding_right = 5,
		},
		click_script = "aerospace workspace " .. space_id,
	})

	workspace_states[space_id] = {
		drawing = "off",
		active = false,
	}
end

local function get_current_state(env)
	local state = {}
	local focused_workspace = env.FOCUSED_WORKSPACE or exec("aerospace list-workspaces --focused")

	local monitors = exec_lines("aerospace list-monitors")
	for i, _ in ipairs(monitors) do
		local non_empty_workspaces = exec_lines("aerospace list-workspaces --monitor " .. i .. " --empty no")
		for _, space_id in ipairs(non_empty_workspaces) do
			local app_names = exec_lines("aerospace list-windows --workspace " .. space_id .. " --format '%{app-name}'")

			local app_icons = " "
			for _, app_name in ipairs(app_names) do
				if app_name then
					app_icons = app_icons .. " " .. icons_map(app_name)
				end
			end

			state[space_id] = {
				drawing = "on",
				label_string = app_icons,
				active = (space_id == focused_workspace),
			}
		end
	end

	if state[focused_workspace] == nil then
		state[focused_workspace] = {
			drawing = "on",
			active = true,
		}
	end

	return state
end

-- Helper function to check if two states are equal
local function states_equal(old, new)
	if (old == nil) ~= (new == nil) then
		return false
	end
	if old == nil then
		return true
	end

	return old.drawing == new.drawing and old.active == new.active
end

local function update_all_workspaces(env)
	sbar.begin_config()

	local new_states = get_current_state(env)

	for _, space in ipairs(all_workspaces) do
		local space_id = space:match("([^|]+)|([^|]+)")
		local new_state = new_states[space_id] or {}
		local old_state = workspace_states[space_id] or {}

		if new_state == nil then
			if old_state.drawing == "on" then
				sbar.set("aerospace." .. space_id, {
					drawing = "off",
					label = { string = "" },
					background = {
						color = colors.TRANSPARENT,
					},
				})
				workspace_states[space_id].drawing = "off"
				workspace_states[space_id].active = false
			end
		else
			if not states_equal(old_state, new_state) then
				sbar.set("aerospace." .. space_id, {
					drawing = new_state.drawing or "off",
					label = { string = trim(new_state.label_string or "") },
					background = {
						color = new_state.active and colors.BACKGROUND_SPACE_ACTIVE or colors.TRANSPARENT,
					},
				})
				workspace_states[space_id] = new_state
			end
		end
	end

	sbar.end_config()
end

update_all_workspaces({})

-- Create space separator that handles events
local poop = sbar.add("item", "poop", {
	position = "center",
	icon = { string = "💩", padding_left = 0, padding_right = 0, margin_right = 0 },
	label = { drawing = "off", padding_left = 0, margin_left = 0 },
	background = { drawing = "off" },
})

poop:subscribe("aerospace_workspace_change", function(env)
	update_all_workspaces(env)
end)

poop:subscribe("aerospace_mode_change", function(env)
	local mode = env.MODE
	if mode == "service" then
		sbar.set("aerospace.mode", {
			label = { string = "(S)" },
			drawing = "on",
		})
	else
		sbar.set("aerospace.mode", {
			label = { string = "" },
			drawing = "off",
		})
	end
end)

poop:subscribe("aerospace_monitor_change", function(env)
	if env.FOCUSED_WORKSPACE and env.TARGET_MONITOR then
		sbar.set("aerospace." .. env.FOCUSED_WORKSPACE, {
			display = env.TARGET_MONITOR,
		})
	end
end)
