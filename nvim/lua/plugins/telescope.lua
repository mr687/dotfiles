return {
	"nvim-telescope/telescope.nvim",
	enabled = false,
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		{
			"nvim-telescope/telescope-frecency.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		-- "akinsho/flutter-tools.nvim",
	},
	cmd = { "Telescope" },
	opts = function(_, opts)
		local actions = require("telescope.actions")
		opts.defaults = {
			prompt_prefix = "💬 ",
			selection_caret = "👉 ",
			layout_strategy = "horizontal",
			-- sorting_strategy = "ascending",
			winblend = 0,
			layout_config = {
				prompt_position = "bottom",
				height = 0.7,
				width = 0.87,
			},
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
			},
		}
		opts.pickers = {
			colorscheme = { enable_preview = true },
		}
		opts.extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("frecency")
		-- telescope.load_extension("flutter")
		-- telescope.load_extension("notify")
	end,
	keys = function()
		local cmdT = "<cmd>Telescope "
		local cmdL = "<cmd>lua require('telescope')."
		return {
			{ "<leader>fC", cmdT .. "commands<cr>", desc = "Telescope commands" },
			{ "<leader>fF", cmdT .. "media_files<cr>", desc = "Telescope media files" },
			{ "<leader>fM", cmdT .. "man_pages<cr>", desc = "Telescope man pages" },
			{ "<leader>fR", cmdT .. "registers<cr>", desc = "Telescope registers" },
			{ "<leader>fS", cmdT .. "colorscheme<cr>", desc = "Telescope colorschemes" },

			{ "<leader>fb", cmdT .. "buffers<cr>", desc = "Telescope buffers" },
			{ "<leader>fd", cmdT .. "diagnostics<cr>", desc = "Telescope diagnostics" },
			{ "<leader>ff", cmdT .. "find_files<cr>", desc = "Telescope Find files" },
			{
				"<leader>fr",
				cmdT .. "frecency workspace=CWD path_display={'shorten'}<cr>",
				desc = "Telescope Find files",
			},
			{ "<leader>fg", cmdT .. "live_grep<cr>", desc = "Telescope Live Grep" },
			{ "<leader>fh", cmdT .. "help_tags<cr>", desc = "Telecope Help files" },

			{ "<leader>fi", cmdL .. "extensions.media_files.media_files()<cr>", desc = "Telescope Media files" },
			{ "<leader>fk", cmdT .. "keymaps<cr>", desc = "Telescope keymaps" },
			{ "<leader>fl", cmdT .. "resume<cr>", desc = "Telescope resume" },
			{ "<leader>fm", cmdT .. "marks<cr>", desc = "Telescope marks" },
			{ "<leader>fo", cmdT .. "oldfiles<cr>", desc = "Telescope old files" },
			{ "<leader>fp", cmdT .. "planets<cr>", desc = "Telescope Planets" },
			{ "<leader>fw", cmdT .. "grep_string<cr>", desc = "" },

			{ "<leader>gC", cmdT .. "git_commits<cr>", desc = "Telescope git commits" },
			{ "<leader>gb", cmdT .. "git_branches<cr>", desc = "Telescope git branches" },
			{ "<leader>go", cmdT .. "git_status<cr>", desc = "Telescope git status" },

			{ "<leader>LS", cmdT .. "lsp_dynamic_workspace_symbols<cr>", desc = "Telescope Workspace Symbols" },
			{ "<leader>Ls", cmdT .. "lsp_document_symbols<cr>", desc = "Telescope Document Symbols" },
		}
	end,
}
