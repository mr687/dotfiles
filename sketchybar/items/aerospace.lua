local colors = require("colors")
local icons_map = require("icons")

local function trim(s)
	return s and s:match("^%s*(.-)%s*$") or ""
end

local all_workspaces = {}
for i = 1, 10 do
	table.insert(all_workspaces, tostring(i))
end
for ascii = string.byte("A"), string.byte("Z") do
	table.insert(all_workspaces, string.char(ascii))
end

local workspace_states = {}

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

for _, space_id in ipairs(all_workspaces) do
	sbar.add("item", "aerospace." .. space_id, {
		position = "left",
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
			y_offset = 0,
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
		display = 1,
		drawing = "off",
		active = false,
		label = "",
	}
end

local function parse_and_render(focused_ws, windows_output)
	local ws_has_windows = {}
	local ws_icons = {}
	local ws_monitors = {}

	for line in windows_output:gmatch("[^\r\n]+") do
		local ws, app, monitor_id = line:match("^([^|]+)|(.*)|(.*)$")
		if ws and monitor_id then
			ws_monitors[ws] = monitor_id
		end
		if ws and app then
			ws_has_windows[ws] = true
			local icon = icons_map(app)
			if icon and icon ~= "" then
				if not ws_icons[ws] then
					ws_icons[ws] = {}
				end
				table.insert(ws_icons[ws], icon)
			end
		end
	end

	sbar.begin_config()
	for _, space_id in ipairs(all_workspaces) do
		local is_focused = (space_id == focused_ws)
		local is_non_empty = (ws_has_windows[space_id] == true)
		local is_visible = is_focused or is_non_empty

		local monitor_id = ws_monitors[space_id] or 1
		local icons_list = ws_icons[space_id]
		local label_str = icons_list and table.concat(icons_list, " ") or ""
		local drawing_str = is_visible and "on" or "off"

		local old = workspace_states[space_id]

		if
			old.drawing ~= drawing_str
			or old.active ~= is_focused
			or old.label ~= label_str
			or old.display ~= monitor_id
		then
			sbar.set("aerospace." .. space_id, {
				display = monitor_id,
				drawing = drawing_str,
				label = {
					drawing = (label_str ~= "") and "on" or "off",
					string = label_str,
				},
				background = {
					color = is_focused and colors.BACKGROUND_SPACE_ACTIVE or colors.TRANSPARENT,
				},
			})

			old.display = monitor_id
			old.drawing = drawing_str
			old.active = is_focused
			old.label = label_str
		end
	end
	sbar.end_config()
end

local function update_all_workspaces(env)
	local focused_ws = env and env.FOCUSED_WORKSPACE

	if focused_ws and focused_ws ~= "" then
		sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}|%{monitor-id}'", function(output)
			parse_and_render(focused_ws, output)
		end)
	else
		sbar.exec(
			"aerospace list-workspaces --focused; echo '---'; aerospace list-windows --all --format '%{workspace}|%{app-name}|%{monitor-id}'",
			function(output)
				local focused_part, windows_part = output:match("^(.-)\r?\n%-%-%-\r?\n(.*)$")
				if focused_part then
					focused_ws = trim(focused_part)
					parse_and_render(focused_ws, windows_part or "")
				end
			end
		)
	end
end

update_all_workspaces({})

local poop = sbar.add("item", "poop", {
	position = "center",
	icon = { string = "💩", padding_left = 0, padding_right = 0, margin_right = 0 },
	label = { drawing = "off", padding_left = 0, margin_left = 0 },
	background = { drawing = "off" },
	click_script = "sketchybar --reload",
})

poop:subscribe({ "aerospace_workspace_change", "front_app_switched", "space_windows_change" }, update_all_workspaces)

poop:subscribe("aerospace_mode_change", function(env)
	local is_service = env.MODE == "service"
	sbar.set("aerospace.mode", {
		label = { string = is_service and "(S)" or "" },
		drawing = is_service and "on" or "off",
	})
end)

poop:subscribe("aerospace_monitor_change", function(env)
	if env.FOCUSED_WORKSPACE and env.TARGET_MONITOR then
		sbar.set("aerospace." .. env.FOCUSED_WORKSPACE, {
			display = env.TARGET_MONITOR,
		})
	end
end)
