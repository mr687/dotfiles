---@diagnostic disable: missing-fields
if lazyvim_docs then
	-- Native inline completions don't support being shown as regular completions
	vim.g.ai_cmp = false
end

if LazyVim.has_extra("ai.copilot-native") then
	if vim.fn.has("nvim-0.12") == 0 then
		LazyVim.error("You need Neovim >= 0.12 to use the `ai.copilot-native` extra.")
		return {}
	end
	if LazyVim.has_extra("ai.copilot") then
		LazyVim.error("Please disable the `ai.copilot` extra if you want to use `ai.copilot-native`")
		return {}
	end
end

vim.g.ai_cmp = false

return {
	-- copilot-language-server
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				copilot = {
          -- stylua: ignore
          keys = {
            {
              "<M-]>",
              function() vim.lsp.inline_completion.select({ count = 1 }) end,
              desc = "Next Copilot Suggestion",
              mode = { "i", "n" },
            },
            {
              "<M-[>",
              function() vim.lsp.inline_completion.select({ count = -1 }) end,
              desc = "Prev Copilot Suggestion",
              mode = { "i", "n" },
            },
          },
				},
			},
			setup = {
				copilot = function()
					vim.schedule(function()
						vim.lsp.inline_completion.enable()
					end)
					-- Accept inline suggestions or next edits
					LazyVim.cmp.actions.ai_accept = function()
						return vim.lsp.inline_completion.get()
					end
				end,
			},
		},
	},
}
