return {
	"folke/snacks.nvim",
	enabled = true,
	priority = 1000,
	lazy = false,
	opts = {
		image = { enabled = true },
		scroll = { enabled = false },
		picker = {
			enabled = true,
			sources = {
				select = {
					layout = {
						preset = "fzf",
					},
				},
			},
		},
		dashboard = { enabled = true },
		scope = { enabled = false },
		indent = { enabled = true },
		animate = { enabled = false },
		terminal = { enabled = true },
		words = { enabled = true },
	},
}
