local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({
     "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = {
				news = {
					lazyvim = true,
					neovim = true,
				},
			},
		},
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
	},
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		-- get a notification when new updates are found
		-- disable it as it's too annoying
		notify = false,
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		-- get a notification when changes are found
		-- disable it as it's too annoying
		notify = false,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"tohtml",
				"tarPlugin",
				"zipPlugin",
				"tutor",
			},
		},
	},
	debug = false,
})
