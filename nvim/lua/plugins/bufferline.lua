return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	keys = {
		{ "<a-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
		{ "<a-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
		{ "<a-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
		{ "<a-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
		{ "<a-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
		{ "<a-9>", "<Cmd>BufferLineGoToBuffer -1<CR>", desc = "Go to last buffer" },

		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
	},
	opts = {
		options = {
			mode = "tabs",
			-- separator_style = "slant",
			show_buffer_close_icons = false,
			show_close_icon = false,
		},
	},
}
