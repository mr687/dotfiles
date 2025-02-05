return {
	"akinsho/flutter-tools.nvim",
	enabled = false,
	lazy = false,
	ft = "dart", -- Load only for Dart files
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = true,
}
