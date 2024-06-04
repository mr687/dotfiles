local user_config = require("user_config")
local island = require("island")

local M = {}

M.status = "idle"
M.power_icon = nil
M.power_text = nil

local function get_icon(source)
	local icon = user_config.features.power.icons.battery
	if source == "AC" then
		icon = user_config.features.power.icons.ac
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
		M.power_icon:set({ label = { color = user_config.colors.transparent } })
		M.power_text:set({ label = { color = user_config.colors.transparent } })
	end)

	sbar.delay(0.1, function()
		island.bar.reset_animation()

		sbar.delay(0.4, function()
			M.power_icon:set({ drawing = false })
			M.power_text:set({ drawing = false })

			sbar.trigger("dynamic_island_request")

			M.status = "idle"
			interrupt = 0
		end)
	end)
end

local function start_animation(source)
	local icon = get_icon(source)
	M.power_icon:set({ drawing = true, label = icon })
	M.power_text:set({ drawing = true, label = source })

	if M.status == "idle" then
		M.status = "update"
	end

	local char_length = string.len(source)
	island.bar.start_animation({
		max_height = user_config.features.power.expand_height,
		max_width = user_config.features.power.max_expand_width + char_length * 7,
		max_corner_radius = user_config.features.power.corner_radius,
	})

	sbar.animate("sin", 15, function()
		M.power_text:set({ label = { color = user_config.colors.white } })
		M.power_icon:set({ label = { color = user_config.colors.white } })
	end)

	if M.status == "update" then
		interrupt = interrupt + 1
	end

	sbar.delay(0.8, reset_animation)
end

function M.setup()
	M.power_icon = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 15,
		padding_right = 0,
		y_offset = -5,
		icon = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			font = {
				family = user_config.font,
				style = "Bold",
				size = 12.0,
			},
		},
	})

	M.power_text = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = 15,
		width = 0,
		icon = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			y_offset = -5,
			align = "right",
			font = {
				family = user_config.font,
				style = "Bold",
				size = 12.0,
			},
		},
	})

	local power_listener = sbar.add("item", {
		position = "center",
		drawing = true,
		icon = { drawing = false },
		label = { drawing = false },
		width = 0,
	})

	power_listener:subscribe("power_source_change", function(env)
		print("sk.power_source_change", env.INFO)
		sbar.trigger("dynamic_island_queue", {
			INFO = "power",
			ISLAND_ARGS = env.INFO,
		})
	end)
end

function M.update(env)
	local source = env.ARGS
	start_animation(source)
end

M.setup()

return M
