return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },

		config = function()
			require("todo-comments").setup({
				keywords = {
					DEBT = {
						icon = "󰁨 ",
						color = "error",
						alt = { "TECHDEBT", "TECH-DEBT" },
					},
				},
			})
		end,
	},
}
