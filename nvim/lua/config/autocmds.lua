-- ignore capitalization mistakes
vim.cmd("ca W w")
vim.cmd("ca Q q")
vim.cmd("ca WQ wq")
vim.cmd("ca Wq wq")

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
}) -- return to last edit position when opening files

local HighlightYank = vim.api.nvim_create_augroup("HighlightYank", {})
autocmd("TextYankPost", {
	group = HighlightYank,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 500,
		})
	end,
}) -- highlight yanked text using the 'IncSearch' highlight group for 40ms

local CleanOnSave = vim.api.nvim_create_augroup("CleanOnSave", {})
autocmd({ "BufWritePre" }, {
	group = CleanOnSave,
	pattern = "*",
	command = [[%s/\s\+$//e]],
}) -- remove trailing whitespace from all lines before saving a file)

-- Turn off paste mode when leaving insert
autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

autocmd("FileType", {
	pattern = { "dart" },
	callback = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Goto Definition2" })
		keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto Declaration2" })
	end,
})

-- -- Remove unused imports on save
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	group = vim.api.nvim_create_augroup("ts_imports", { clear = true }),
-- 	pattern = { "*.tsx,*.ts" },
-- 	callback = function()
-- 		vim.lsp.buf.code_action({
-- 			apply = true,
-- 			context = {
-- 				only = { "source.removeUnused.ts" },
-- 				diagnostics = {},
-- 			},
-- 		})
-- 	end,
-- })
