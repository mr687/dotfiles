local user_config = require("user_config")
local utils = require("helpers.utils")
local visualizer_sh = (os.getenv("XDG_CONFIG_HOME") or "~/.config") .. "/sketchybar/features/music/visualizer.sh"

local M = {}

local sizes = {
	compact = {
		scale = 1.0,
		y_offset = 0,
		padding_right = 15,
		color = user_config.colors.with_alpha(user_config.colors.white, 0.4),
	},
	large = {
		scale = 2.0,
		y_offset = 15,
		padding_right = 20,
		color = user_config.colors.white,
	},
}

function M.update(opts)
	opts = opts or {}

	local size = sizes[opts.size or "large"]

	local override = opts.OVERRIDE == "1" and true or false
	local args = utils.str_split(opts.ARGS or "", "|")
	local state = args[1]

	if not override then
		for _, v in pairs(M.sticks) do
			v:set({ drawing = true })
		end
	end

	sbar.animate("tanh", 10, function()
		for i, v in pairs(M.sticks) do
			v:set({
				padding_right = 2 * i + size.padding_right,
				width = 2 * size.scale,
				y_offset = size.y_offset,
				background = {
					corner_radius = 2 * size.scale,
					color = size.color,
				},
			})
		end
	end)

	os.execute("pkill -f " .. visualizer_sh .. " >/dev/null || true")
	if state == "playing" then
		os.execute("bash " .. visualizer_sh .. " " .. size.scale .. " &")
	end

	if not (state == "playing") then
		for _, v in pairs(M.sticks) do
			v:set({ background = { height = 1 } })
		end
	end
end

function M.reset()
	os.execute("pkill -f " .. visualizer_sh .. " >/dev/null || true")

	sbar.animate("tanh", 15, function()
		for _, v in pairs(M.sticks) do
			v:set({ drawing = false })
		end
	end)
end

local function create_stick(group_name, index, opts)
	opts = opts or {}

	local size = sizes[opts.size or "compact"]
	local padding = 2 * index
	local padding_left = 0
	local padding_right = padding + size.padding_right

	local default_options = {
		position = "right",
		drawing = opts.drawing or false,
		padding_left = padding_left,
		padding_right = padding_right,
		icon = { drawing = false },
		label = { drawing = false },
		width = 2 * size.scale,
		y_offset = size.y_offset,
		background = {
			height = 1,
			color = user_config.colors.with_alpha(user_config.colors.white, 0.4),
			corner_radius = 2 * size.scale,
		},
	}
	local name = group_name .. "." .. index
	local item = sbar.add("item", name, default_options)
	return item
end

function M.setup(opts)
	opts = opts or {}
	M.opts = opts

	M.sticks = {
		create_stick("stick", 1, opts),
		create_stick("stick", 2, opts),
		create_stick("stick", 3, opts),
		create_stick("stick", 4, opts),
		create_stick("stick", 5, opts),
		create_stick("stick", 6, opts),
	}
end

return M
