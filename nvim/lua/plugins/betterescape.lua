return {
	{
		"max397574/better-escape.nvim",
		enabled = false,
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},
}
