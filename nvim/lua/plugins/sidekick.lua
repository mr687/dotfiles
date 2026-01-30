return {
	-- copilot-language-server
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local sk = LazyVim.opts("sidekick.nvim") ---@type sidekick.Config|{}
			if vim.tbl_get(sk, "nes", "enabled") ~= false then
				opts.servers = opts.servers or {}
				opts.servers.copilot = opts.servers.copilot or {}
			end
		end,
	},
	{
		"folke/sidekick.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = function(_, opts)
			-- Accept inline sugesstions or next edits
			LazyVim.cmp.actions.ai_nes = function()
				local NES = require("sidekick.nes")
				if NES.have() and (NES.jump() or NES.apply()) then
					return true
				end
			end

			Snacks.toggle({
				name = "Sidekick NES",
				get = function()
					return require("sidekick.nes").enabled
				end,
				set = function(state)
					require("sidekick.nes").enable(state)
				end,
			}):map("<leader>uN")

			opts.nes = opts.nes or {}
			opts.nes.clear = opts.nes.clear or {}
			opts.nes.clear.esc = true -- Clear NES on <Esc>

			opts.cli = {}
		end,
		keys = {
			{ "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
		},
	},

	{
		"saghen/blink.cmp",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<Tab>"] = {
					"snippet_forward",
					function() -- sidekick next edit suggestion
						return require("sidekick").nes_jump_or_apply()
					end,
					function() -- if you are using Neovim's native inline completions
						return vim.lsp.inline_completion.get()
					end,
					"fallback",
				},
			},
		},
	},
}
