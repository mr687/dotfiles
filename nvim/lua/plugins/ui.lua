return {
	{
		"snacks.nvim",
		---@type snacks.Config
		opts = {
			styles = {
				snacks_image = {
					relative = "editor",
					col = -1,
				},
			},
			formats = { key = { "" } },
			notifier = {
				filter = function(notif)
					-- temporarily block notifications of vtls inlayHint exception
					-- REMOVE THIS once this issue is fixed: https://github.com/yioneko/vtsls/issues/159
					if string.match(notif.msg, "(vtsls: %-32603)") then
						return false
					end
					return true
				end,
			},
			dashboard = {
				width = 18,
				sections = {
          -- stylua: ignore start
          { hidden = true, icon = " ", key = "t", desc = "Find [T]ext", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { hidden = true, icon = " ", key = "r", desc = "[R]ecent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { hidden = true, icon = "󰒲 ", key = "l", desc = "[L]azy", action = ":Lazy" },
          { hidden = true, icon = " ", key = "s", desc = "Restore Session", section = "session" },

          -- Header
          { text = " ", padding = 12 },
          {
              padding = 2,
              text = {
                  { "Neovim :: M Λ C R O ", hl = "Normal" },
                  { "- Editing made simple", hl = "NonText" },
              },
              action = ":lua Snacks.dashboard.pick('files')",
              key = "f",
          },

          -- Keys
					{
						padding = 1,
						text = {
							{ "  Find [F]ile", width = 19, hl = "NonText" },
							{ "  Find [T]ext", hl = "NonText" },
						},
						action = ":lua Snacks.dashboard.pick('files')",
						key = "f",
					},
					{
						padding = 1,
						text = {
							{ " ", width = 3 },
							{ "  [N]ew File", width = 19, hl = "NonText" },
							{ "  [R]ecent File", hl = "NonText" },
						},
						action = ":ene | startinsert",
						key = "n",
					},
					{
						padding = 2,
						text = {
							{ " ", width = 9 },
							{ "  [C]onfig", hl = "NonText" },
							{ " ", width = 8 },
							{ "󰒲  [L]azy", hl = "NonText" },
							{ " ", width = 14 },
						},
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						key = "c",
					},
					{
						padding = 2,
						text = {
							{ " ", width = 5 },
							{ "  [Q]uit", hl = "NonText" },
						},
						action = ":quitall",
						key = "q",
					},

          -- Sartup
          -- { section = "startup", padding = 1 },
          { section = "terminal", cmd = "printf ' '", height = 15 },

          -- Keys
          {
              text = {
                  [[
  Copyright (c) 2024 - M Λ C R O developers
              ]],

                  hl = "NonText",
              },
          },
				},
			},
		},
	},
}
