local user_config = require("user_config")

local M = {}

function M.setup()
	local music_listener = sbar.add("item", {
		position = "center",
		drawing = true,
		width = 0,
		icon = { drawing = false },
		label = { drawing = false },
		background = { drawing = false },
	})

	local function media_change_handler(env)
		local app = env.INFO.app
		if not user_config.features.music.sources[app] then
			return
		end

		local state = env.INFO.state
		local title = env.INFO.title
		local artist = env.INFO.artist
		local album = env.INFO.album
		local duration = env.INFO.duration
		local elapsedTime = env.INFO.elapsedTime
		local args = string.format("%s|%s|%s|%s|%s|%s", state, title, artist, album, duration, elapsedTime)
		sbar.trigger("dynamic_island_queue", { INFO = "music", ISLAND_ARGS = args })
	end
	music_listener:subscribe("media_change", media_change_handler)

	-- local function mouse_handler(env)
	-- 	local sender = env.SENDER
	--
	-- 	if sender == "mouse.entered.global" then
	-- 		return 0
	-- 	elseif sender == "mouse.exited.global" then
	-- 		return 0
	-- 	end
	-- end
	--
	-- music_listener:subscribe("mouse.entered.global", mouse_handler)
	-- music_listener:subscribe("mouse.exited.global", mouse_handler)
end

return M
