return {
	{
		"olimorris/codecompanion.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
			"j-hui/fidget.nvim",
		},
		init = function()
			require("plugins.codecompanion.fidget-spinner"):init()
		end,
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
			"CodeCompanionCmd",
		},
		keys = {
			{ "<leader>ai", "<cmd>CodeCompanion<CR>", desc = "Inline" },
			{ "<leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "Chat" },
		},
		opts = {
			opts = {
				log_level = "DEBUG",
				language = "English",
			},
			display = {
				diff = {
					enabled = true,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "vertical", -- vertical|horizontal split for default provider
					opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
					provider = "default", -- default|mini_diff
				},
				chat = {
					intro_message = "Welcome to AI Companion ✨! Press ? for options",
					show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
					separator = "─", -- The separator between the different messages in the chat buffer
					show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
					show_settings = true, -- Show LLM settings at the top of the chat buffer?
					show_token_count = true, -- Show the token count for each response?
					start_in_insert_mode = false, -- Open the chat buffer in insert mode?
					-- Change the default icons
					icons = {
						pinned_buffer = " ",
						watched_buffer = "👀 ",
					},
					-- Alter the sizing of the debug window
					debug_window = {
						---@return number|fun(): number
						width = vim.o.columns - 5,
						---@return number|fun(): number
						height = vim.o.lines - 2,
					},
					-- Options to customize the UI of the chat buffer
					window = {
						layout = "vertical", -- float|vertical|horizontal|buffer
						position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
						border = "single",
						height = 0.8,
						width = 0.30,
						relative = "editor",
						opts = {
							breakindent = true,
							cursorcolumn = false,
							cursorline = false,
							foldcolumn = "0",
							linebreak = true,
							list = false,
							numberwidth = 1,
							signcolumn = "no",
							spell = false,
							wrap = true,
						},
					},
					---Customize how tokens are displayed
					---@param tokens number
					---@param adapter CodeCompanion.Adapter
					---@return string
					token_count = function(tokens, adapter)
						return " (" .. tokens .. " tokens)"
					end,
				},
			},
			strategies = {
				chat = {
					adapter = "copilot",
					roles = {
						---The header name for the LLM's messages
						---@type string|fun(adapter: CodeCompanion.Adapter): string
						llm = function(adapter)
							return "CodeCompanion (" .. adapter.formatted_name .. ")"
						end,

						---The header name for your messages
						---@type string
						user = "User",
					},
					keymaps = {
						completion = {
							send = {
								modes = { n = "<C-s>", i = "<C-s>" },
							},
							close = {
								modes = { n = "<C-c>", i = "<C-c>" },
							},
							modes = {
								i = "<C-x>",
							},
							index = 1,
							callback = "keymaps.completion",
							description = "Completion Menu",
						},
					},
				},
				slash_commands = {
					["buffer"] = {
						callback = "strategies.chat.slash_commands.buffer",
						description = "Insert open buffers",
						opts = {
							contains_code = true,
							provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
						},
					},
					["fetch"] = {
						callback = "strategies.chat.slash_commands.fetch",
						description = "Insert URL contents",
						opts = {
							adapter = "jina",
						},
					},
					["file"] = {
						callback = "strategies.chat.slash_commands.file",
						description = "Insert a file",
						opts = {
							contains_code = true,
							max_lines = 1000,
							-- provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
						},
					},
					["files"] = {
						callback = "strategies.chat.slash_commands.files",
						description = "Insert multiple files",
						opts = {
							contains_code = true,
							max_lines = 1000,
							provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
						},
					},
					["help"] = {
						callback = "strategies.chat.slash_commands.help",
						description = "Insert content from help tags",
						opts = {
							contains_code = false,
							provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
						},
					},
					["now"] = {
						callback = "strategies.chat.slash_commands.now",
						description = "Insert the current date and time",
						opts = {
							contains_code = false,
						},
					},
					["symbols"] = {
						callback = "strategies.chat.slash_commands.symbols",
						description = "Insert symbols for a selected file",
						opts = {
							contains_code = true,
							provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
						},
					},
					["terminal"] = {
						callback = "strategies.chat.slash_commands.terminal",
						description = "Insert terminal output",
						opts = {
							contains_code = false,
						},
					},
				},
				inline = {
					adapter = "copilot",
					keymaps = {
						accept_change = {
							modes = { n = "ga" },
							description = "Accept the suggested change",
						},
						reject_change = {
							modes = { n = "gr" },
							description = "Reject the suggested change",
						},
					},
				},
				agent = {
					adapter = "copilot",
				},
			},
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "claude-3.5-sonnet",
							},
						},
					})
				end,
			},
		},
	},
}
