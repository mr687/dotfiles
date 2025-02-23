local isDev = false
local localDir = "~/.dev/oss/CopilotChat.nvim"

local prompts = {
	Explain = "Explain how the following code works.",
	Review = "Review the following code and provide suggestions for improvement.",
	Tests = "Explain the selected code and generate unit tests for it.",
	Refactor = "Refactor the following code to improve clarity and readability.",
	FixCode = "Fix the following code to make it work as intended.",
	FixError = "Explain the error in the following text and provide a solution.",
	BetterNamings = "Provide better names for the following variables and functions.",
	Documentation = "Provide documentation for the following code.",
	SwaggerApiDocs = "Provide documentation for the following API using Swagger.",
	SwaggerJsDocs = "Write JSDoc for the following API using Swagger.",
	Summarize = "Summarize the following text.",
	Spelling = "Correct any grammar and spelling errors in the following text.",
	Wording = "Improve the grammar and wording of the following text.",
	Concise = "Rewrite the following text to make it more concise.",
	Funny = "Rewrite the following text to make it more funny and professional.",
}

return {
	{
		dir = isDev and localDir or nil,
		"CopilotC-Nvim/CopilotChat.nvim",
		enabled = false,
		event = "VeryLazy",
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "claude-3.5-sonnet", -- default model is gpt-4o
			-- model = "gpt-4o", -- default model is gpt-4o
			agent = "copilot",
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",
			prompts = prompts,
			auto_follow_cursor = false, -- Don't follow the cursor after getting response
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-q>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Show help
				show_help = {
					normal = "g?",
				},
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			opts.question_header = "  " .. user .. " "
			opts.answer_header = "  Copilot "

			chat.setup(opts)

			local select = require("CopilotChat.select")
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			-- Inline chat with Copilot
			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			-- Restore CopilotChatBuffer
			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ah",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
				end,
				desc = "CopilotChat - Help actions",
			},
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>ap",
				":lua require('CopilotChat.integrations.fzflua').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
				mode = "x",
				desc = "CopilotChat - Prompt actions",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>av",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>ax",
				":CopilotChatInline<cr>",
				mode = "x",
				desc = "CopilotChat - Inline chat",
			},
			-- Custom input for CopilotChat
			{
				"<leader>ai",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Debug
			{ "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
			-- Toggle Copilot Chat Vsplit
			{ "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
			-- Copilot Chat Agents
			{ "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
		},
	},
}
