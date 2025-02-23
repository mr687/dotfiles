return {
	{
		"yetone/avante.nvim",
		enabled = false,
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		opts = {
			auto_suggestions_provider = "ollama",
			---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
			provider = "ollama",
			vendors = {
				["openrouter-deepseek"] = {
					__inherijjjjted_from = "openai",
					disable_tools = true,
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "OPENROUTER_API_KEY",
					model = "deepseek/deepseek-r1:free",
				},
				ollama = {
					__inherited_from = "openai",
					api_key_name = "",
					endpoint = "http://127.0.0.1:11434/v1",
					model = "codegemma",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat/completions",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								messages = require("avante.providers").copilot.parse_messages(code_opts),
								max_tokens = 2048,
								stream = true,
							},
						}
					end,
				},
			},
		},
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			{
				"echasnovski/mini.pick",
				optional = true,
			}, -- for file_selector provider mini.pick
			{
				"nvim-telescope/telescope.nvim",
				optional = true,
			}, -- for file_selector provider telescope
			{
				"hrsh7th/nvim-cmp",
				optional = true,
			}, -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	vim.g.ai_cmp and {
		"saghen/blink.cmp",
		optional = true,
		dependencies = { "saghen/blink.compat", "MeanderingProgrammer/render-markdown.nvim" },
		opts = {
			sources = {
				default = {
					"avante_commands",
					"avante_mentions",
					"avante_files",
					"markdown",
				},
				compat = {
					"avante_commands",
					"avante_mentions",
					"avante_files",
				},
				providers = {
					avante_commands = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 90, -- show at a higher priority than lsp
						opts = {},
					},
					avante_files = {
						name = "avante_files",
						module = "blink.compat.source",
						score_offset = 100, -- show at a higher priority than lsp
						opts = {},
					},
					avante_mentions = {
						name = "avante_mentions",
						module = "blink.compat.source",
						score_offset = 1000, -- show at a higher priority than lsp
						opts = {},
					},
					markdown = {
						name = "RenderMarkdown",
						module = "render-markdown.integ.blink",
						fallbacks = { "lsp" },
					},
				},
			},
		},
	},
}
