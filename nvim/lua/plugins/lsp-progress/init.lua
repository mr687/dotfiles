local ui = require("vim._core.ui2")
local api = vim.api

ui.enable({
	enable = true,
	msg = {
		targets = {
			progress = "msg",
		},
	},
})

local message_id = nil
local function progress(percent, title, is_running)
	local status = "success"
	if is_running then
		status = "running"
	end
	message_id = api.nvim_echo({ { title } }, false, {
		id = message_id,
		percent = percent,
		source = "lsp-progress",
		status = status,
		title = "LSP",
		kind = "progress",
	})
end

api.nvim_create_autocmd("LspProgress", {
	callback = function(args)
		local value = args.data.params.value
		if value == nil then
			return
		end

		local percent = value.percentage or 0
		if percent < 1 then
			return
		end

		local title = value.title
		local is_running = true

		if percent > 95 and percent <= 100 then
			is_running = false
		end

		progress(percent, title, is_running)
	end,
})

return {}
