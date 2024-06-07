local user_config = require("user_config")
local utils = require("helpers.utils")

local half_x_resolution = user_config.monitor.x_resolution / 2
local squish_amount = user_config.animation.squish_amount
local notch_width = user_config.notch.width
local notch_height = user_config.notch.height
local notch_corder_radius = user_config.notch.corner_radius

local M = {}

local sizes = {
	default = {
		width = notch_width,
		height = notch_height,
		corner_radius = notch_corder_radius,
		y_offset = -notch_corder_radius,
	},
	large = {
		width = 150,
		height = notch_height + 9,
		corner_radius = 20,
		y_offset = -notch_corder_radius,
	},
	ultra = {
		width = 200,
		height = 200,
		corner_radius = 50,
		y_offset = -40,
	},
}

function M.update(opts)
	local size = sizes[opts.size or "default"]
	local override = opts.override or false

	local margins = {
		half_x_resolution - (notch_width + squish_amount),
		half_x_resolution - (size.width + squish_amount),
		half_x_resolution - size.width,
	}

	if override then
		table.remove(margins, 1)
	end

	local heights = {
		size.height + (squish_amount / 2),
		size.height,
	}

	sbar.animate("tanh", 8, function()
		for _, v in pairs(margins) do
			sbar.bar({ margin = v })
		end
	end)

	sbar.animate("tanh", 10, function()
		sbar.bar({ corner_radius = size.corner_radius, y_offset = size.y_offset })
	end)

	sbar.animate("tanh", 10, function()
		for _, v in pairs(heights) do
			sbar.bar({ height = v })
		end
	end)
end

function M.reset(opts)
	opts = opts or {}

	utils.tbl_merge(M.opts, opts)

	if M.opts.pinned then
		M.update(M.opts)
		return
	end

	sbar.animate("tanh", 10, function()
		sbar.bar({
			height = notch_height,
			corner_radius = notch_corder_radius,
			margin = half_x_resolution - notch_width + squish_amount,
		})
		sbar.bar({ margin = half_x_resolution - notch_width })
	end)
end

function M.setup(opts)
	opts = opts or {}

	M.opts = {
		size = "default",
	}
	utils.tbl_merge(M.opts, opts)

	local size = sizes[M.opts.size]
	sbar.bar({
		display = user_config.display,
		position = "top",
		shadow = "off",
		sticky = "off",
		topmost = "on",
		padding_right = 0,
		padding_left = 0,
		height = size.height,
		color = user_config.colors.black,
		corner_radius = size.corner_radius,
		y_offset = size.y_offset,
		margin = (user_config.monitor.x_resolution / 2) - size.width,
		notch_width = 0,
	})

	local padding = 3
	sbar.default({
		updates = "when_shown",
		icon = {
			font = {
				family = user_config.font,
				style = "Bold",
				size = 14.0,
			},
			color = user_config.colors.white,
			padding_left = padding,
			padding_right = padding,
		},
		label = {
			font = {
				family = user_config.font,
				style = "SemiBold",
				size = 13.0,
			},
			color = user_config.colors.white,
			padding_left = padding,
			padding_right = padding,
		},
		background = {
			padding_left = padding,
			padding_right = padding,
		},
	})
end

return M
