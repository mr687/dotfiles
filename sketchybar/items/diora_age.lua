local colors = require("colors")

local birthday = { year = 2026, month = 9, day = 18 }
local jakarta_offset = 7 * 60 * 60
local weather_interval = 15 * 60
local retry_interval = 60

local papa = { latitude = -7.008167304070147, longitude = 110.39675306260962 } -- Semarang
local diora = { latitude = -6.782074901255724, longitude = 111.19438509683046 } -- Pati

local weather = sbar.add("item", "papa_diora_weather", {
	position = "right",
	update_freq = 60,
	padding_left = 10,
	padding_right = 10,
	icon = { drawing = "off" },
	label = {
		font = "Press Start 2P:Regular:10.0",
		string = "🧸 diora …",
	},
	background = {
		drawing = "on",
		color = colors.CLOCK_BG_COLOR,
		corner_radius = 5,
		height = 26,
	},
})

-- Gregorian calendar-day arithmetic avoids local timezone/DST conversion.
local month_offsets = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 }
local function day_number(date)
	local year = date.year - 1
	local leap = date.year % 4 == 0 and (date.year % 100 ~= 0 or date.year % 400 == 0)
	return 365 * year
		+ math.floor(year / 4)
		- math.floor(year / 100)
		+ math.floor(year / 400)
		+ month_offsets[date.month]
		+ date.day
		+ ((leap and date.month > 2) and 1 or 0)
end

local birth_day = day_number(birthday)

local url = string.format(
	"https://api.open-meteo.com/v1/forecast"
		.. "?latitude=%.6f,%.6f&longitude=%.6f,%.6f"
		.. "&current=temperature_2m&temperature_unit=celsius"
		.. "&timezone=Asia%%2FJakarta",
	papa.latitude,
	diora.latitude,
	papa.longitude,
	diora.longitude
)

local command = "/usr/bin/curl --fail --silent --show-error" .. " --connect-timeout 5 --max-time 15 '" .. url .. "'"

local in_flight = false
local next_fetch_at = 0
local temperatures = nil
local fetch_failed = false
local last_label = nil

local function format_temperature(value)
	if value == nil then
		return "--°C"
	end
	if math.abs(value) < 0.05 then
		value = 0
	end
	local text = string.format("%.1f", value):gsub("%.0$", "")
	return text .. "°C"
end

local function render()
	local today = os.date("!*t", os.time() + jakarta_offset)
	local age = math.max(0, day_number(today) - birth_day)
	local label = string.format(
		"🧸 diora %dd | 👨 %s · 👶 %s",
		age,
		format_temperature(temperatures and temperatures.papa),
		format_temperature(temperatures and temperatures.diora)
	)

	if fetch_failed then
		label = label .. (temperatures and " · stale" or " · unavailable")
	end

	-- Send an IPC update only when the visible text actually changes.
	if label ~= last_label then
		weather:set({ label = label })
		last_label = label
	end
end

local function temperature(entry)
	if type(entry) ~= "table" or type(entry.current) ~= "table" then
		return nil
	end

	local value = entry.current.temperature_2m
	if type(value) == "number" and value == value and math.abs(value) < math.huge then
		return value
	end
end

local function unavailable()
	-- Keep cached temperatures; the age continues updating even while offline.
	fetch_failed = true
	next_fetch_at = os.time() + retry_interval
	render()
end

local function refresh(env)
	render()
	if in_flight then
		return
	end

	local now = os.time()
	local manual = env and env.SENDER == "mouse.clicked"
	if not manual and now < next_fetch_at then
		return
	end

	in_flight = true
	-- Startup, routine and wake events share this cache; clicks bypass it.
	next_fetch_at = now + weather_interval

	-- SbarLua runs curl asynchronously and decodes JSON into a Lua table.
	sbar.exec(command, function(data, exit_code)
		in_flight = false

		if exit_code ~= 0 or type(data) ~= "table" then
			unavailable()
			return
		end

		local papa_c = temperature(data[1])
		local diora_c = temperature(data[2])
		if papa_c == nil or diora_c == nil then
			unavailable()
			return
		end

		temperatures = { papa = papa_c, diora = diora_c }
		fetch_failed = false
		render()
	end)
end

weather:subscribe({
	"routine",
	"forced",
	"system_woke",
	-- "mouse.clicked",
}, refresh)
refresh()
