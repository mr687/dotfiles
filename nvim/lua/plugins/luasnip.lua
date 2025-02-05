return {
	{
		"L3MON4D3/LuaSnip",
		-- Load only when snippet is needed
		event = "InsertEnter",
		config = function()
			require("luasnip").setup()
			-- Consider lazy-loading friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
