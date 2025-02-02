return {
	"williamboman/mason.nvim",
	opts = function(_, opts)
		opts.ui = {
			border = "rounded",
			height = 0.75,
			width = 0.75,
		}
		vim.list_extend(opts.ensure_installed, {
			"typescript-language-server",
			"prisma-language-server",
			"html-lsp",
		})
	end,
}
