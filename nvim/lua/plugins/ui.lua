return {
	{
		"snacks.nvim",
		opts = {
			dashboard = {
				width = 60,
				row = nil, -- dashboard position. nil for center
				col = nil, -- dashboard position. nil for center
				pane_gap = 4, -- empty columns between vertical panes
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
				preset = {
					pick = function(cmd, opts)
						return LazyVim.pick(cmd, opts)()
					end,
					header = [[
▄▄▌   ▄▄▄· ·▄▄▄▄• ▄· ▄▌             ▄▄▄·
██•  ▐█ ▀█ ▪▀·.█▌▐█▪██▌ ▄█▀▄  ▄█▀▄ ▐█ ▄█
██ ▪ ▄█▀▀█ ▄█▀▀▀•▐█▌▐█▪▐█▌.▐▌▐█▌.▐▌ ██▀·
▐█▌ ▄▐█▪ ▐▌█▌▪▄█▀ ▐█▀·.▐█▌.▐▌▐█▌.▐▌▐█▪·•
.▀▀▀  ▀  ▀ ·▀▀▀ •  ▀ •  ▀█▄▀▪ ▀█▄▀▪.▀
]],
				},
				sections = {
					{
						section = "terminal",
						cmd = "chafa ~/.config/vim-wall.png --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
						height = 17,
						padding = 1,
					},
					{
						pane = 2,
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
				},
			},
		},
	},
}
