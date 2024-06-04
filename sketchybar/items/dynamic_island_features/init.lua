-- require("items.dynamic_island_features.music")
-- require("items.dynamic_island_features.appswitch")
-- require("items.dynamic_island_features.brightness")
-- require("items.dynamic_island_features.wifi")
-- require("items.dynamic_island_features.power")
-- require("items.dynamic_island_features.notification")

local user_config_features = require("user_config").features

local function load_if_enabled(name)
	if user_config_features[name].enabled then
		return require("items.dynamic_island_features." .. name)
	end
	return nil
end

local M = {}

M.appswitch = load_if_enabled("appswitch")
M.volume = load_if_enabled("volume")
M.brightness = load_if_enabled("brightness")
M.power = load_if_enabled("power")

return M
