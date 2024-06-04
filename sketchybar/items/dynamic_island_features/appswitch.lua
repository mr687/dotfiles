local user_config = require("user_config")
local island = require("island")
local app_icons = require("helpers.app_icons")

local M = {}

M.status = "idle"
M.app_logo = nil
M.app_name = nil

local function get_icon(app_name)
	local lookup = app_icons[app_name]
	local icon = ((lookup == nil) and app_icons["default"] or lookup)
	return icon
end

local interrupt = 0
local function reset_animation()
	if interrupt > 1 then
		interrupt = interrupt - 1
		return
	end

	sbar.animate("tanh", 15, function()
		M.app_logo:set({ label = { color = user_config.colors.transparent } })
		M.app_name:set({ label = { color = user_config.colors.transparent } })
	end)

	sbar.delay(0.1, function()
		island.bar.reset_animation()

		sbar.delay(0.4, function()
			M.app_logo:set({ drawing = false })
			M.app_name:set({ drawing = false })

			sbar.trigger("dynamic_island_request")

			M.status = "idle"
			interrupt = 0
		end)
	end)
end

local function start_animation(app_name)
	local icon = get_icon(app_name)
	M.app_logo:set({ drawing = true, label = icon })
	M.app_name:set({ drawing = true, label = app_name })

	if M.status == "idle" then
		M.status = "update"
	end

	local char_length = string.len(app_name)

	island.bar.start_animation({
		max_height = user_config.features.appswitch.expand_height,
		max_width = user_config.features.appswitch.max_expand_width + char_length * 7,
		max_corner_radius = user_config.features.appswitch.corner_radius,
	})

	sbar.animate("sin", 15, function()
		M.app_name:set({ label = { color = user_config.colors.white } })
		M.app_logo:set({ label = { color = user_config.colors.white } })
	end)

	if M.status == "update" then
		interrupt = interrupt + 1
	end

	sbar.delay(0.8, reset_animation)
end

function M.setup()
	M.app_logo = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 20,
		padding_right = 5,
		y_offset = -5,
		icon = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			font = {
				family = "sketchybar-app-font",
				style = "Regular",
				size = 12.0,
			},
		},
	})

	M.app_name = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = 20,
		width = 10,
		icon = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			y_offset = -2,
			align = "right",
			font = {
				family = user_config.font,
				style = "Bold",
				size = 12.0,
			},
		},
	})

	local appswitch_listener = sbar.add("item", {
		position = "center",
		drawing = true,
		icon = { drawing = false },
		label = { drawing = false },
		width = 0,
	})

	appswitch_listener:subscribe("front_app_switched", function(env)
		print("sk.front_app_switched", env.INFO)
		sbar.trigger("dynamic_island_queue", {
			INFO = "appswitch",
			ISLAND_ARGS = env.INFO,
		})
	end)
end

function M.update(env)
	local app_name = env.ARGS
	start_animation(app_name)
end

M.setup()

return M
