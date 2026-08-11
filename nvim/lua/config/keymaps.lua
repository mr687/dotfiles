local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("x", "p", [["_dP]])
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- move a blocks of text up/down with K/J in visual mode
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- Maps '<leader>cp' to strictly copy the RELATIVE path and line number
vim.keymap.set("n", "<leader>cp", function()
	-- The ':%.' modifier forces the path to be relative to the current directory
	local path = vim.fn.expand("%:.")
	local line = vim.fn.line(".")
	local result = path .. ":" .. line

	vim.fn.setreg("+", result)
	print("Copied relative: " .. result)
end, { desc = "Copy relative path and line number" })

require("plugins.herdr.herdr_nav")
