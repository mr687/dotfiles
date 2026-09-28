return {
	"stevearc/oil.nvim",
	enabled = true,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		win_options = {
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = true,
		},
		watch_for_changes = true,
	},
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	keys = {
		{ "<leader>e", mode = "n", ":Oil<CR>", { silent = true } },
	},
}
