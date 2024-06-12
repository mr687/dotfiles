return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	opts = {
		-- A list of parser names, or "all"
		ensure_installed = {},
		highlight = {
			enable = true,
			use_languagetree = true,
		},
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		refactor = {
			highlight_definitions = {
				enable = true,
			},
			highlight_current_scope = {
				enable = false,
			},
		},
	},
}
