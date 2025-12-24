return {
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		config = function()
			-- https://github.com/EQuimper/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/copilot.lua
			-- Set explicit Node path for Copilot to avoid version conflicts
			vim.g.copilot_node_command = vim.fn.expand("/Users/macbench/.nvm/versions/node/v24.9.0/bin/node")
			require("copilot").setup({})
		end,
		opts = {
			suggestion = {
				enabled = not vim.g.ai_cmp,
				auto_trigger = true,
				hide_during_completion = vim.g.ai_cmp,
				keymap = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{
		"giuxtaposition/blink-cmp-copilot",
		enabled = false,
	},
}
