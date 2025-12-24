return {
	{
		"folke/sidekick.nvim",
		opts = function(_, opts)
			local function tmux_nav(command)
				return function()
					local termcodes = vim.api.nvim_replace_termcodes
					vim.api.nvim_feedkeys(termcodes("<C-\\><C-n>", true, false, true), "n", false)
					vim.schedule(function()
						---@diagnostic disable-next-line: param-type-mismatch
						pcall(vim.cmd, command)
					end)
				end
			end

			opts.cli = opts.cli or {}
			opts.cli.mux = vim.tbl_extend("force", { backend = "tmux", enabled = false }, opts.cli.mux or {})
			opts.cli.win = opts.cli.win or {}
			local keys = opts.cli.win.keys or {}

			keys.tmux_left = keys.tmux_left
				or {
					"<c-h>",
					tmux_nav("TmuxNavigateLeft"),
					mode = "t",
					desc = "Sidekick: move focus left",
				}

			keys.tmux_down = keys.tmux_down
				or {
					"<c-j>",
					tmux_nav("TmuxNavigateDown"),
					mode = "t",
					desc = "Sidekick: move focus down",
				}

			keys.tmux_up = keys.tmux_up
				or {
					"<c-k>",
					tmux_nav("TmuxNavigateUp"),
					mode = "t",
					desc = "Sidekick: move focus up",
				}

			keys.tmux_right = keys.tmux_right
				or {
					"<c-l>",
					tmux_nav("TmuxNavigateRight"),
					mode = "t",
					desc = "Sidekick: move focus right",
				}

			keys.tmux_prev = keys.tmux_prev
				or {
					"<c-\\>",
					tmux_nav("TmuxNavigatePrevious"),
					mode = "t",
					desc = "Sidekick: move to previous pane",
				}

			opts.cli.win.keys = keys
		end,
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-\\>",
				function()
					require("sidekick.cli").focus()
				end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ focus = true })
				end,
				desc = "Sidekick Toggle CLI",
				mode = { "n", "v" },
			},
			{
				"<leader>ao",
				function()
					require("sidekick.cli").toggle({ name = "opencode", focus = true })
				end,
				desc = "Sidekick Opencode Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ag",
				function()
					require("sidekick.cli").toggle({ name = "codex", focus = true })
				end,
				desc = "Sidekick Codex Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				desc = "Sidekick Ask Prompt",
				mode = { "n", "v" },
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
	},
}
