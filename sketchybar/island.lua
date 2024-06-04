local user_config = require("user_config")
local half_x_resolution = user_config.monitor.x_resolution / 2
local squish_amount = user_config.animation.squish_amount
local notch_width = user_config.notch.width
local notch_height = user_config.notch.height
local notch_corder_radius = user_config.notch.corner_radius

local M = {}

M.bar = {
	start_animation = function(option)
		local margin_1 = half_x_resolution - (notch_width + squish_amount)
		local margin_2 = half_x_resolution - option.max_width

		sbar.animate("tanh", 8, function()
			sbar.bar({ margin = margin_1 })
			sbar.bar({ margin = margin_2 - squish_amount })
			sbar.bar({ margin = margin_2 })
		end)

		sbar.animate("tanh", 10, function()
			sbar.bar({ corner_radius = option.max_corner_radius })
		end)

		sbar.animate("tanh", 10, function()
			sbar.bar({ height = option.max_height + (squish_amount / 2) })
			sbar.bar({ height = option.max_height })
		end)
	end,
	reset_animation = function()
		local margin_1 = half_x_resolution - notch_width + squish_amount
		local margin_2 = half_x_resolution - notch_width

		sbar.animate("tanh", 10, function()
			sbar.bar({ height = notch_height, corner_radius = notch_corder_radius, margin = margin_1 })
			sbar.bar({ margin = margin_2 })
		end)
	end,
}

return M
