return {
	"stevearc/oil.nvim",
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
	},
	config = function(_, opts)
		require("oil").setup(opts)
	end,
}
