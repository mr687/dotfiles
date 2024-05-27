return {
	"nvim-cmp",
	lazy = true,
	dependencies = { "hrsh7th/cmp-emoji" },
	opts = function(_, opts)
		table.insert(opts.sources, { name = "emoji" })
	end,
}
