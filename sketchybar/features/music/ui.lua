local user_config = require("user_config")
local utils = require("helpers.utils")
local script_duration = (os.getenv("XDG_CONFIG_HOME") or "~/.config") .. "/sketchybar/features/music/duration.sh"

local M = {}

local cover_sizes = {
	compact = {
		y_offset = 0,
		padding_left = 15,
		width = 25,
		height = 25,
		cover_radius = 5,
		scale = 0.86,
	},
	large = {
		y_offset = 15,
		padding_left = 20,
		width = 70,
		height = 70,
		cover_radius = 10,
		scale = 2.2,
	},
}

function M.update(opts)
	opts = opts or {}

	local override = opts.OVERRIDE == "1" and true or false
	local args = utils.str_split(opts.ARGS or "", "|")
	local state = args[1]
	local title = args[2] == "" and "Untitled" or args[2]
	local artist = args[3] == "" and "Unknown" or args[3]

	M.state = state
	M.update_opts = opts

	if not override then
		M.music_cover:set({ drawing = true })
		M.music_title:set({ drawing = true })
		M.music_artist:set({ drawing = true })

		M.music_elapsed_time:set({ drawing = true })
		M.music_duration:set({ drawing = true })

		M.music_nav_prev:set({ drawing = true })
		M.music_nav_play_pause:set({ drawing = true })
		M.music_nav_next:set({ drawing = true })
	end

	M.music_title:set({ label = title })
	M.music_artist:set({ label = "by " .. (artist or "Unknown") })

	M.music_nav_play_pause:set({
		icon = state == "playing" and user_config.features.music.icons.pause or user_config.features.music.icons.play,
	})

	local cover_size = cover_sizes["large"]

	sbar.animate("tanh", 15, function()
		M.music_cover:set({
			y_offset = cover_size.y_offset,
			padding_left = cover_size.padding_left,
			width = cover_size.width,
			background = {
				color = user_config.colors.grey,
				height = cover_size.height,
				corner_radius = cover_size.cover_radius,
				image = {
					scale = 2.2,
					corner_radius = cover_size.cover_radius,
				},
			},
		})

		M.music_title:set({ label = { color = user_config.colors.white } })
		M.music_artist:set({ label = { color = user_config.colors.grey } })

		M.music_elapsed_time:set({ label = { color = user_config.colors.grey } })
		M.music_duration:set({ label = { color = user_config.colors.grey } })

		M.music_nav_prev:set({ icon = { color = user_config.colors.white } })
		M.music_nav_play_pause:set({ icon = { color = user_config.colors.white } })
		M.music_nav_next:set({ icon = { color = user_config.colors.white } })
	end)

	M.visualizer.update(opts)
	M.music_duration_bar.update(opts)
	return 0
end

function M.reset(opts)
	opts = opts or {}
	local pinned = opts.pinned or false

	M.music_duration_bar.reset()
	sbar.animate("tanh", 15, function()
		M.music_title:set({ label = { color = user_config.colors.transparent } })
		M.music_artist:set({ label = { color = user_config.colors.transparent } })
		M.music_elapsed_time:set({ label = { color = user_config.colors.transparent } })
		M.music_duration:set({ label = { color = user_config.colors.transparent } })
		M.music_nav_prev:set({ icon = { color = user_config.colors.transparent } })
		M.music_nav_play_pause:set({ icon = { color = user_config.colors.transparent } })
		M.music_nav_next:set({ icon = { color = user_config.colors.transparent } })
	end)

	sbar.animate("tanh", 15, function()
		M.music_title:set({ drawing = false })
		M.music_artist:set({ drawing = false })
		M.music_elapsed_time:set({ drawing = false })
		M.music_duration:set({ drawing = false })
		M.music_nav_prev:set({ drawing = false })
		M.music_nav_play_pause:set({ drawing = false })
		M.music_nav_next:set({ drawing = false })
	end)

	if pinned then
		utils.tbl_merge(M.update_opts, { size = "compact" })
		M.visualizer.update(M.update_opts)

		local cover_size = cover_sizes["compact"]
		sbar.animate("tanh", 15, function()
			M.music_cover:set({
				y_offset = cover_size.y_offset,
				padding_left = cover_size.padding_left,
				width = cover_size.width,
				background = {
					height = cover_size.height,
					corner_radius = cover_size.cover_radius,
					image = {
						scale = cover_size.scale,
					},
				},
			})
		end)
		return
	end

	sbar.animate("tanh", 15, function()
		M.music_cover:set({ background = { color = user_config.colors.transparent } })
	end)

	sbar.animate("tanh", 15, function()
		M.music_cover:set({ drawing = false })
	end)

	M.visualizer.reset()
end

function M.setup(opts)
	opts = opts or {}

	local y_offset = 15

	M.state = "idle"
	M.opts = opts
	M.music_cover = sbar.add("item", {
		position = "left",
		drawing = false,
		width = 70,
		padding_left = 20,
		padding_right = 0,
		icon = { drawing = false },
		label = { drawing = false },
		y_offset = y_offset,
		background = {
			height = 70,
			color = user_config.colors.transparent,
			corner_radius = 10,
			image = {
				string = "media.artwork",
				scale = 1.21,
				padding_left = 0,
				padding_right = 0,
			},
		},
	})

	M.music_title = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 33,
		padding_right = 0,
		width = 0,
		scroll_texts = true,
		y_offset = y_offset,
		icon = { drawing = false },
		background = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			max_chars = 25,
		},
	})

	M.music_artist = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = 33,
		padding_right = 0,
		width = 0,
		y_offset = -20 + y_offset,
		scroll_texts = true,
		icon = { drawing = false },
		background = { drawing = false },
		label = {
			color = user_config.colors.transparent,
			font = { size = 12 },
			max_chars = 25,
		},
	})

	M.music_elapsed_time = sbar.add("item", {
		position = "left",
		drawing = false,
		padding_left = -50,
		padding_right = 0,
		width = 0,
		y_offset = -53 + y_offset,
		icon = { drawing = false },
		background = { drawing = false },
		script = script_duration .. " elapsed_time",
		update_freq = 5,
		label = {
			string = "00:00",
			font = { size = 12 },
			color = user_config.colors.transparent,
		},
	})

	M.music_duration_bar = require("features.music.horizontal_bar")
	M.music_duration_bar.setup({
		position = "left",
		width = 260,
		padding_left = 0,
		padding_right = 0,
		y_offset = -54 + y_offset,
	})

	M.music_duration = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = 20,
		width = 0,
		y_offset = -53 + y_offset,
		icon = { drawing = false },
		background = { drawing = false },
		script = script_duration .. " duration",
		update_freq = 10,
		label = {
			string = "00:00",
			font = { size = 12 },
			color = user_config.colors.transparent,
		},
	})

	-- # NAVIGATION
	local nav_padding = 230
	local nav_y_offset = -85 + y_offset
	M.music_nav_prev = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = nav_padding,
		width = 0,
		y_offset = nav_y_offset,
		label = { drawing = false },
		background = { drawing = false },
		icon = {
			string = user_config.features.music.icons.prev,
			color = user_config.colors.transparent,
			font = { size = 24 },
		},
	})

	M.music_nav_play_pause = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = nav_padding - 40,
		width = 0,
		y_offset = nav_y_offset,
		label = { drawing = false },
		background = { drawing = false },
		icon = {
			string = user_config.features.music.icons.play,
			color = user_config.colors.transparent,
			font = { size = 24 },
		},
	})

	M.music_nav_next = sbar.add("item", {
		position = "right",
		drawing = false,
		padding_left = 0,
		padding_right = nav_padding - 100,
		width = 0,
		y_offset = nav_y_offset,
		label = { drawing = false },
		background = { drawing = false },
		icon = {
			string = user_config.features.music.icons.next,
			color = user_config.colors.transparent,
			font = { size = 24 },
		},
	})

	M.visualizer = require("features.music.visualizer")
	M.visualizer.setup({
		size = "large",
		drawing = false,
	})

	M.music_nav_play_pause:subscribe("mouse.clicked", function(_env)
		if M.state == "playing" then
			sbar.exec("nowplaying-cli pause")
		elseif M.state == "paused" then
			sbar.exec("nowplaying-cli play")
		end
	end)

	M.music_nav_prev:subscribe("mouse.clicked", function(_env)
		sbar.exec("nowplaying-cli previous")
	end)

	M.music_nav_next:subscribe("mouse.clicked", function(_env)
		sbar.exec("nowplaying-cli next")
	end)
end

M.setup()

return M
