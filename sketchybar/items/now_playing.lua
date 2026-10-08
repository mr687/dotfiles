-- now_playing.lua: Now Playing item for SbarLua based configs.
--
-- Needs the sketchybar-now-playing binary on PATH (or set BIN below).
-- Drop this file into ~/.config/sketchybar/items/ and load it from
-- init.lua after the bar setup:
--
--   require("items.now_playing")
--
-- Then start the event daemon once (init.lua, guarded so reloads do
-- not stack daemons):
--
--   sbar.exec("pgrep -f '[s]ketchybar-now-playing daemon' >/dev/null || "
--     .. "sketchybar-now-playing daemon >>/tmp/sketchybar-now-playing.log 2>&1 &")

-- sbar.exec inherits the bar's minimal PATH, so resolve the binary the
-- same way the shell plugin does: explicit env wins, then the common
-- install prefixes, then plain PATH. The os.execute probe degrades
-- gracefully (both Lua 5.1 numeric and 5.2+ boolean results accepted).

local colors = require("colors")

local function find_binary()
	local override = os.getenv("NOW_PLAYING_BIN")
	if override ~= nil and override ~= "" then
		return override
	end
	local home = os.getenv("HOME") or ""
	local candidates = {
		home .. "/.cargo/bin/sketchybar-now-playing",
		home .. "/.local/bin/sketchybar-now-playing",
		"/opt/homebrew/bin/sketchybar-now-playing",
		"/usr/local/bin/sketchybar-now-playing",
	}
	for _, path in ipairs(candidates) do
		local ok = os.execute("[ -x '" .. path .. "' ]")
		if ok == true or ok == 0 then
			return path
		end
	end
	return "sketchybar-now-playing"
end

local BIN = find_binary()
local EVENT = "now_playing_change"

-- Optional config file, forwarded to every invocation. Paths with a
-- single quote are not supported here; use the shell plugin if needed.
local CONFIG_FLAG = ""
do
	local config_path = os.getenv("NOW_PLAYING_CONFIG")
	if config_path ~= nil and config_path ~= "" then
		CONFIG_FLAG = " --config '" .. config_path .. "'"
	end
end

sbar.add("event", EVENT)

-- Last playback state from the event feed. Ground truth only: updated on
-- each event, never flipped on click, so `scroll_texts` strictly follows
-- PLAYING. Long lived Lua state, so no query or state file is needed,
-- unlike the shell plugin.
local playing_state = false

-- Placeholder until the first track: the full pill look (music icon,
-- label, transport buttons), always visible, never scrolling. The buttons
-- are dead until a player exists. Stopped playback returns to the
-- placeholder; only true idle maps here, paused tracks keep their entry.
local now_playing = sbar.add("item", "now_playing", {
	position = "q",
	drawing = false,
	update_freq = 10,
	scroll_texts = false,
	padding_right = 10,
	label = {
		font = "Press Start 2P:Regular:10.0",
		string = "",
		max_chars = 40,
		scroll_duration = 100,
	},
	icon = { drawing = "off" },
	background = {
		drawing = "on",
		color = colors.CLOCK_BG_COLOR,
		corner_radius = 5,
		height = 26,
	},
})

-- Event path: the daemon pushes TITLE, ARTIST, LABEL, ICON, PLAYING.
-- Scrolling strictly follows playback: on only while playing, off while
-- paused or idle. Idle arrives as the placeholder LABEL and renders
-- through the normal path; empty payloads (pre-placeholder daemons) only
-- stop motion.
now_playing:subscribe(EVENT, function(env)
	if env.LABEL == nil or env.LABEL == "" then
		playing_state = false
	else
		playing_state = (env.PLAYING == "true")
	end

	local label = env.LABEL or ""

	now_playing:set({
		drawing = playing_state,
		label = { string = label },
		scroll_texts = playing_state,
	})
end)

-- Polling fallback and post reload convergence. The periodic tick skips
-- the heavy `sync` (binary + perl adapter + bar update) while the event
-- daemon is alive: one `pgrep` instead of a full snapshot. Falls back to
-- polling the moment the daemon is gone.
now_playing:subscribe("routine", function()
	sbar.exec(
		"pgrep -f '[s]ketchybar-now-playing daemon' >/dev/null 2>&1 || " .. BIN .. CONFIG_FLAG .. " sync now_playing"
	)
end)

-- One immediate convergence at load so a reloaded bar with a live daemon
-- shows the current track without waiting one `update_freq` period.
sbar.exec(BIN .. CONFIG_FLAG .. " sync now_playing")
