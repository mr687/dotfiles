return {
	"ThePrimeagen/harpoon",
	enabled = false,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = function(_, opts)
		opts.settings = {
			save_on_toggle = false,
			sync_on_ui_close = false,
			save_on_change = true,
			enter_on_sendcmd = false,
			tmux_autoclose_windows = false,
			excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
			mark_branch = false,
			key = function()
				return vim.loop.cwd()
			end,
		}
	end,
	keys = function()
		local harpoon = require("harpoon")

		return {
			-- Harpoon marked files 1 through 4
			{
				"<a-1>",
				function()
					harpoon:list():select(1)
				end,
				desc = "Harpoon buffer 1",
			},
			{
				"<a-2>",
				function()
					harpoon:list():select(2)
				end,
				desc = "Harpoon buffer 2",
			},
			{
				"<a-3>",
				function()
					harpoon:list():select(3)
				end,
				desc = "Harpoon buffer 3",
			},
			{
				"<a-4>",
				function()
					harpoon:list():select(4)
				end,
				desc = "Harpoon buffer 4",
			},

			-- Harpoon user interface.
			{
				"<c-e>",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Toggle Menu",
			},
			{
				"<leader>a",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon add file",
			},
		}
	end,
	config = function(_, opts)
		require("harpoon").setup(opts)
	end,
}
