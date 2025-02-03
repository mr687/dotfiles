if vim.loader then
	vim.loader.enable()
end

vim.o.shell = "/bin/zsh"

require("config.lazy")
