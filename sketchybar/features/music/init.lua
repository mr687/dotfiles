local bar = require("features.bar")
local utils = require("helpers.utils")

local M = {}

function M.update(opts)
	local args = utils.str_split(opts.ARGS, "|")
	local state = args[1]

	M.music_state = state

	bar.update({ size = "ultra", override = opts.OVERRIDE == "1" and true or false })
	M.ui.update(opts)
end

function M.reset()
	if M.music_state == "playing" then
		M.ui.reset({ pinned = true })
		bar.reset({ size = "large", pinned = true })
	else
		M.ui.reset({ pinned = false })
		bar.reset({ pinned = false })
	end
end

function M.setup(opts)
	opts = opts or {}
	M.opts = opts

	require("features.music.listener").setup()
	M.ui = require("features.music.ui")
end

return M
