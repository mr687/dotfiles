return {
	{
		"gbprod/yanky.nvim",
		-- Lazy-load only when yanking/pasting
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("yanky").setup()
			-- Add minimal configuration here
		end,
	},
}
