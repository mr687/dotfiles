return {
	{ "nvim-neotest/neotest-plenary" },
	{
		"nvim-neotest/neotest",
		opts = { adapters = { "neotest-plenary" } },
		cmd = { "TestNearest", "TestFile" }, -- Load on test commands
	},
}
