local user_config = require("user_config")

local M = {}

local function is_enabled(name)
	if not name then
		return false
	end
	if not M.features[name] then
		return false
	end
	return user_config.features[name].enabled or false
end

function M.update(opts)
	opts = opts or {}
	local identifier = opts.IDENTIFIER

	if is_enabled(identifier) then
		M.current_display = identifier
		M.features[identifier].update(opts)
	end

	sbar.delay(3, function()
		M.reset()
	end)
end

function M.reset()
	if not is_enabled(M.current_display) then
		return
	end

	M.features[M.current_display].reset()
	sbar.trigger("dynamic_island_request")

	M.current_display = nil
end

function M.setup(opts)
	opts = opts or {}
	M.opts = opts

	require("features.bar").setup(opts)

	local music = require("features.music")
	music.setup(opts)

	M.current_display = nil
	M.features = {
		music = music,
	}
end

return M
