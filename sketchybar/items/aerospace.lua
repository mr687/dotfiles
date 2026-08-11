local colors = require("colors")

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

local all_workspaces = exec_lines(
	"aerospace list-workspaces --all --json --format '%{workspace}%{workspace-is-visible}%{monitor-appkit-nsscreen-screens-id}' | jq -r '.[] | \"\\(.workspace)|\\(.\"monitor-appkit-nsscreen-screens-id\")\"'"
) -- Get all workspaces with their monitor IDs, e.g.: "A|1", "B|2", "C|1"

for _, space in ipairs(all_workspaces) do
	local space_id, monitor_id = space:match("([^|]+)|([^|]+)")

	-- Create space item
	sbar.add("item", "aerospace." .. space_id, {
		position = "left",
		display = monitor_id,
		label = {
			string = space_id,
			padding_left = 5,
			padding_right = 5,
		},
		background = {
			drawing = "off",
			color = colors.BACKGROUND_SPACE_ACTIVE,
			corner_radius = 5,
			height = 18,
			padding_left = 2,
			padding_right = 2,
		},
		drawing = "off",
		icon = { drawing = "off" },
	})
end

local function get_current_state(env)
	local state = {}
	local focused_workspace = env.FOCUSED_WORKSPACE or exec("aerospace list-workspaces --focused")

	-- local monitors = exec_lines("aerospace list-monitors")
	-- for i, _ in ipairs(monitors) do
	-- 	local non_empty_workspaces = exec_lines("aerospace list-workspaces --monitor" .. i .. "--empty no")
	-- 	for _, space_id in ipairs(non_empty_workspaces) do
	-- 		state[space_id] = {
	-- 			drawing = "on",
	-- 			active = (space_id == focused_workspace),
	-- 		}
	-- 	end
	-- end

	if state[focused_workspace] == nil then
		state[focused_workspace] = {
			drawing = "on",
			active = true,
		}
	end

	return state
end

local function update_all_workspaces(env)
	sbar.begin_config()

	local new_states = get_current_state(env)

	for _, space in ipairs(all_workspaces) do
		local space_id = space:match("([^|]+)|([^|]+)")
		local new_state = new_states[space_id] or {}

		sbar.set("aerospace." .. space_id, {
			drawing = "on",
			background = {
				drawing = new_state.active and "on" or "off",
			},
		})
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
