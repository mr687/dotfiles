return {
	"akinsho/bufferline.nvim",
	enabled = true,
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<c-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
		{ "<c-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
		{ "<c-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
		{ "<c-3>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
		{ "<c-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
		{ "<c-9>", "<Cmd>BufferLineGoToBuffer -1<CR>", desc = "Go to last buffer" },

		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
	},
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thin",
			show_buffer_close_icons = false,
			show_close_icon = false,
		},
	},
}
