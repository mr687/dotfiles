local user_config = require("user_config")
local island = require("island")

local M = {}

M.status = "idle"
M.volume_icon = nil
M.volume_bar = nil
M.volume_listener = nil

local function get_icon(volume)
	local icon = user_config.features.volume.icons.muted
	if volume >= 70 then
		icon = user_config.features.volume.icons.max
	elseif volume >= 40 then
		icon = user_config.features.volume.icons.medium
	elseif volume >= 1 then
		icon = user_config.features.volume.icons.low
	else
		icon = user_config.features.volume.icons.muted
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
		M.volume_icon:set({ icon = { color = user_config.colors.transparent } })
		M.volume_bar:set({ background = { color = user_config.colors.transparent } })
	end)

	sbar.delay(0.1, function()
		sbar.animate("tanh", 5, function()
			M.volume_bar:set({ width = 0 })
		end)
		island.bar.reset_animation()

		sbar.delay(0.4, function()
			M.volume_icon:set({ drawing = false })
			M.volume_bar:set({ drawing = false })

			sbar.trigger("dynamic_island_request")

			M.status = "idle"
			interrupt = 0
		end)
	end)
end

local function start_animation(volume)
	local icon = get_icon(volume)

	M.volume_icon:set({ drawing = true, icon = icon })
	M.volume_bar:set({ drawing = true })

	if M.status == "idle" then
		M.status = "update"

		island.bar.start_animation({
			max_height = user_config.features.volume.expand_height,
			max_width = user_config.features.volume.max_expand_width,
			max_corner_radius = user_config.features.volume.corner_radius,
		})
	end

	sbar.delay(0.1, function()
		local volume_width = (volume / 100) * user_config.features.volume.max_expand_width * 2 - 30

		sbar.animate("tanh", 15, function()
			M.volume_bar:set({ width = volume_width })
		end)

		sbar.animate("sin", 10, function()
			M.volume_bar:set({ background = { color = user_config.colors.white } })
			M.volume_bar:set({ background = { border_color = user_config.colors.white } })
			M.volume_icon:set({ icon = { color = user_config.colors.white } })
		end)

		if M.status == "update" then
			interrupt = interrupt + 1
		end

		-- reset_animation
		sbar.delay(0.8, reset_animation)
	end)
end

function M.setup()
	M.volume_icon = sbar.add("item", {
		position = "left",
		padding_left = 15,
		padding_right = 0,
		width = 0,
		drawing = false,
		label = { drawing = false },
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
	M.volume_bar = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 15,
		padding_right = 0,
		icon = { drawing = false },
		label = { drawing = false },
		width = 0,
		y_offset = -19,
		background = {
			height = 2,
			color = user_config.colors.transparent,
			border_color = user_config.colors.transparent,
			y_offset = 0,
			shadow = { drawing = false },
		},
	})
	M.volume_listener = sbar.add("item", {
		drawing = true,
		width = 0,
		label = { drawing = false },
		icon = { drawing = false },
	})

	M.volume_listener:subscribe("volume_change", function(env)
		print("sk.volume_change")
		sbar.trigger("dynamic_island_queue", {
			INFO = "volume",
			ISLAND_ARGS = env.INFO,
		})
	end)
end

function M.update(env)
	-- local override = env.OVERRIDE
	local volume = tonumber(env.ARGS)

	start_animation(volume)
end

M.setup()

return M
