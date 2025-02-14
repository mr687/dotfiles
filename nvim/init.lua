if vim.env.VSCODE then
	vim.g.vscode = true
end

if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end
vim.print = _G.dd

vim.o.shell = "/bin/zsh"

require("config.lazy")
