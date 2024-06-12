return {
	-- Available options: all, main, id of display (e.g. 1, 2, 3)
	display = "main",
	-- Font icons may not load properly if not SF Pro
	font = "SF Pro",
	animation = {
		squish_amount = 25,
	},
	notch = {
		height = 44,
		width = 110,
		corner_radius = 10,
	},
	-- Feature settings
	features = {
		appswitch = {
			enabled = true,
			max_expand_width = 140,
			expand_height = 56,
			corner_radius = 15,
			icon_size = 0.4,
		},
		volume = {
			enabled = true,
			max_expand_width = 160,
			expand_height = 65,
			corner_radius = 12,
			normal_icon_color = 0xffffffff,
			icons = {
				max = "􀊩",
				medium = "􀊧",
				low = "􀊥",
				muted = "􀊣",
			},
		},
		brightness = {
			enabled = true,
			max_expand_width = 150,
			expand_height = 65,
			corner_radius = 12,
			normal_icon_color = 0xffffffff,
			icons = {
				low = "􀆫",
				high = "􀆭",
			},
		},
		music = {
			enabled = true,
			sources = {
				Music = true,
				Spotify = true,
			},
			max_expand_width = 240,
			expand_height = 120,
			corner_radius = 19,
			idle_state = {
				expand_height = 160,
			},
			resume_state = {
				max_expand_width = 155,
				expand_height = 56,
				corner_radius = 15,
			},
			icons = {
				prev = "􀊊",
				next = "􀊌",
				play = "􀊄",
				pause = "􀊆",
			},
		},
		wifi = {
			enabled = true,
			max_expand_width = 190,
			expand_height = 56,
			corner_radius = 15,
			icons = {
				connected = "􀙇",
				disconnected = "􀙈",
			},
		},
		power = {
			enabled = true,
			max_expand_width = 140,
			expand_height = 56,
			corner_radius = 15,
			icons = {
				ac = "􀢋",
				battery = "􀛨",
			},
		},
		notification = {
			enabled = true,
			max_expand_width = 180,
			expand_height = 90,
			corner_radius = 42,
			max_allowed_body = 250,
		},
	},
	monitor = {
		-- in case of built-in display, it must be divded by 2, e.g.: MBP 14 has 3024 resolution, so 3024/2=1512
		x_resolution = 1800,
	},
	colors = {
		white = 0xffffffff,
		black = 0xff000000,
		transparent = 0x00000000,
		hidden = 0xff000000,
		red = 0xfffc5d7c,
		green = 0xff9ed072,
		blue = 0xff76cce0,
		yellow = 0xffe7c664,
		orange = 0xfff39660,
		magenta = 0xffb39df3,
		grey = 0xff7f8490,
		with_alpha = function(color, alpha)
			if alpha > 1.0 or alpha < 0.0 then
				return color
			end
			return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
		end,
	},
}
