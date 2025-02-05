if vim.env.VSCODE then
	vim.g.vscode = true
end

if vim.loader then
	vim.loader.enable()
end

vim.o.shell = "/bin/zsh"

require("config.lazy")
