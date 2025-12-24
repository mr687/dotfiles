return {
	{
		"akinsho/flutter-tools.nvim",
		enabled = true,
		-- cond = function()
		-- 	-- Only enable for projects containing pubspec.yaml (Flutter/Dart)
		-- 	local root = vim.uv.cwd()
		-- 	return vim.fn.filereadable(root .. "/pubspec.yaml") == 1
		-- end,
		ft = { "dart" }, -- only load when editing Dart files
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"dart-lang/dart-vim-plugin",
			-- "stevearc/dressing.nvim", -- optional for vim.ui.select
		},
	},
}
