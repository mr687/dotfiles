local user_config = require("user_config")

if not user_config.features.music.enabled then
	return
end

local media_cover = sbar.add("item", {
	position = "left",
	drawing = false,
	updates = true,
	y_offset = 0,
	padding_left = 20,
	padding_right = 0,
	icon = { drawing = false },
	label = { drawing = false },
	background = {
		color = user_config.colors.hidden,
		image = {
			string = "media.artwork",
			scale = 2.0,
			corner_radius = user_config.features.music.corner_radius,
		},
	},
})

local media_title = sbar.add("item", {
	position = "left",
	drawing = false,
	width = 0,
	y_offset = -10,
	icon = { drawing = false },
	padding_left = 20,
	padding_right = 0,
	label = {
		width = "dynamic",
		padding_left = 0,
		padding_right = 0,
		color = user_config.colors.white,
		font = {
			family = user_config.font,
			style = "Bold",
			size = 14.0,
		},
	},
})

local media_artist = sbar.add("item", {
	position = "left",
	drawing = false,
	width = 0,
	y_offset = -30,
	icon = { drawing = false },
	padding_left = 20,
	padding_right = 0,
	label = {
		width = "dynamic",
		padding_left = 0,
		padding_right = 0,
		color = user_config.colors.white,
		font = {
			family = user_config.font,
			style = "SemiBold",
			size = 12.0,
		},
	},
})

local interrupt = 0
local function animate_music_island(state)
	if not state then
		interrupt = interrupt - 1
	end
	if interrupt > 0 and not state then
		return
	end

	sbar.animate("tanh", 8, function()
		local target_width = (user_config.monitor.x_resolution / 2)
			- user_config.notch.width
			- user_config.animation.squish_amount

		sbar.bar({
			margin = target_width,
		})

		local info_expand_size = (user_config.monitor.x_resolution / 2) - user_config.features.music.max_expand_width
		sbar.bar({
			margin = info_expand_size - user_config.animation.squish_amount,
		})

		sbar.bar({
			margin = info_expand_size,
		})
	end)

	sbar.animate("tanh", 10, function()
		local info_max_expand_height = (
			user_config.features.music.expand_height + (user_config.animation.squish_amount / 2)
		)

		sbar.bar({
			height = info_max_expand_height,
		})

		sbar.bar({
			height = user_config.features.music.expand_height,
		})
	end)

	sbar.animate("tanh", 10, function()
		sbar.bar({
			corner_radius = user_config.features.music.corner_radius,
		})
	end)
end

local function is_empty() end

media_cover:subscribe("media_change", function(env)
	local title = env.INFO.title
	local artist = env.INFO.artist
	local drawing = (env.INFO.state == "playing")
	media_artist:set({ drawing = drawing, label = artist })
	media_title:set({ drawing = drawing, label = title })
	media_cover:set({ drawing = drawing })

	if drawing then
		animate_music_island(true)
		interrupt = interrupt + 1
		sbar.delay(5, animate_music_island)
	end
end)
