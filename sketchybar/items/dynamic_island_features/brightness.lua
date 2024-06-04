local user_config = require("user_config")
local island = require("island")

local M = {}

M.status = "idle"
M.brightness_icon = nil
M.brightness_bar = nil

local function get_icon(brightness)
	local icon = user_config.features.brightness.icons.low
	if brightness >= 40 then
		icon = user_config.features.brightness.icons.high
	else
		icon = user_config.features.brightness.icons.low
	end
	return icon
end

local interrupt = 0
local function reset_animation()
	if interrupt > 1 then
		interrupt = interrupt - 1
		return
	end

	sbar.animate("tanh", 15, function()
		M.brightness_icon:set({ icon = { color = user_config.colors.transparent } })
		M.brightness_bar:set({ background = { color = user_config.colors.transparent } })
	end)

	sbar.delay(0.1, function()
		sbar.animate("tanh", 5, function()
			M.brightness_bar:set({ width = 0 })
		end)
		island.bar.reset_animation()

		sbar.delay(0.4, function()
			M.brightness_icon:set({ drawing = false })
			M.brightness_bar:set({ drawing = false })

			sbar.trigger("dynamic_island_request")

			M.status = "idle"
			interrupt = 0
		end)
	end)
end

local function start_animation(brightness)
	local icon = get_icon(brightness)

	M.brightness_icon:set({ drawing = true, icon = icon })
	M.brightness_bar:set({ drawing = true })

	if M.status == "idle" then
		M.status = "update"

		island.bar.start_animation({
			max_height = user_config.features.brightness.expand_height,
			max_width = user_config.features.brightness.max_expand_width,
			max_corner_radius = user_config.features.brightness.corner_radius,
		})
	end

	local brightness_width = (brightness / 100) * (user_config.features.brightness.max_expand_width * 2 - 30)
	sbar.animate("tanh", 15, function()
		M.brightness_bar:set({ width = brightness_width })
	end)

	sbar.animate("sin", 10, function()
		M.brightness_bar:set({
			background = { color = user_config.colors.white, border_color = user_config.colors.white },
		})
		M.brightness_icon:set({ icon = { color = user_config.colors.white } })
	end)

	if M.status == "update" then
		interrupt = interrupt + 1
	end

	sbar.delay(0.8, reset_animation)
end

function M.setup()
	M.brightness_icon = sbar.add("item", {
		position = "left",
		drawing = false,
		width = 0,
		padding_left = 15,
		padding_right = 0,
		icon = {
			color = user_config.colors.transparent,
			y_offset = 2,
			font = {
				family = user_config.font,
				style = "Bold",
				size = 14.0,
			},
		},
	})

	M.brightness_bar = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 15,
		padding_right = 0,
		y_offset = -19,
		background = {
			height = 2,
			color = user_config.colors.transparent,
			border_color = user_config.colors.transparent,
			y_offset = 0,
			shadow = { drawing = false },
		},
	})

	local brightness_listener = sbar.add("item", {
		position = "center",
		drawing = true,
		icon = { drawing = false },
		label = { drawing = false },
		width = 0,
	})

	brightness_listener:subscribe("brightness_change", function(env)
		print("sk.brightness_change", env.INFO)
		sbar.trigger("dynamic_island_queue", {
			INFO = "brightness",
			ISLAND_ARGS = env.INFO,
		})
	end)
end

function M.update(env)
	local brightness = tonumber(env.ARGS)
	start_animation(brightness)
end

M.setup()

return M
