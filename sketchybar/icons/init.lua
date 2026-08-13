local icon_map = require("icons/icon_map")

return function(app_name)
	if icon_map[app_name] then
		return icon_map[app_name]
	end
	return ":default:"
end
