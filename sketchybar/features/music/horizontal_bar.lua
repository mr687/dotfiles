local user_config = require("user_config")

local M = {}

function M.update(opts)
	local override = opts.OVERRIDE == "1" and true or false

	if not override then
		M.bar_bg:set({ drawing = true })
		M.bar_value:set({ drawing = true })
	end

	sbar.animate("tanh", 15, function()
		M.bar_bg:set({ background = { color = user_config.colors.with_alpha(user_config.colors.white, 0.1) } })
		M.bar_value:set({ background = { color = user_config.colors.with_alpha(user_config.colors.white, 0.7) } })
	end)
end

function M.reset()
	sbar.animate("tanh", 15, function()
		M.bar_bg:set({ background = { color = user_config.colors.transparent } })
		M.bar_value:set({ background = { color = user_config.colors.transparent } })
	end)

	sbar.animate("tanh", 15, function()
		M.bar_bg:set({ drawing = false })
		M.bar_value:set({ drawing = false })
	end)
end

function M.setup(opts)
	opts = opts or {}

	M.opts = opts

	M.bar_bg = sbar.add("item", {
		position = opts.position or "left",
		drawing = false,
		padding_left = 0,
		padding_right = 0,
		width = opts.width or 0,
		y_offset = opts.y_offset or 0,
		icon = { drawing = false },
		label = { drawing = false },
		background = {
			height = 4,
			color = user_config.colors.transparent,
			corner_radius = 3,
		},
	})

	local script_duration = (os.getenv("XDG_CONFIG_HOME") or "~/.config") .. "/sketchybar/features/music/duration.sh"
	M.bar_value = sbar.add("item", {
		position = opts.position or "left",
		drawing = false,
		padding_left = -(opts.width or 0),
		padding_right = 0,
		width = 0,
		y_offset = opts.y_offset or 0,
		icon = { drawing = false },
		label = { drawing = false },
		script = script_duration .. " percentage " .. (opts.width or 0),
		update_freq = 5,
		background = {
			height = 4,
			color = user_config.colors.transparent,
			corner_radius = 3,
		},
	})
end

return M
