return {
	"folke/zen-mode.nvim",
	enabled = false,
	cmd = "ZenMode",
	opts = {
		plugins = {
			gitsigns = true,
			tmux = true,
			kitty = { enabled = false, font = "+2" },
		},
	},
	keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
}
