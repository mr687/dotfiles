return {
	{
		enabled = false,
		"folke/flash.nvim",
	},

	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {
				hsl_color = {
					pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
					group = function(_, match)
						local utils = require("solarized-osaka.hsl")
						--- @type string, string, string
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						--- @type number?, number?, number?
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						--- @type string
						---@diagnostic disable-next-line: param-type-mismatch
						local hex_color = utils.hslToHex(h, s, l)
						return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Close blame window
				quit_blame = "q",
				-- Open blame commit
				blame_commit = "<CR>",
				-- Open file/folder in git repository
				browse = "<Leader>go",
				-- Open pull request of the current branch
				open_pull_request = "<Leader>gp",
				-- Create a pull request with the target branch is set in the `target_branch` option
				create_pull_request = "<Leader>gn",
				-- Opens a new diff that compares against the current index
				diff = "<Leader>gd",
				-- Close git diff
				diff_close = "<Leader>gD",
				-- Revert to the specific commit
				revert = "<Leader>gr",
				-- Revert the current file to the specific commit
				revert_file = "<Leader>gR",
			},
		},
	},

	{
		"telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			{
				"nvim-telescope/telescope-media-files.nvim",
				config = function()
					require("telescope").load_extension("media_files")
				end,
			},
		},
	},
	-- change some telescope options and a keymap to browse plugin files
	{
		"nvim-telescope/telescope.nvim",
		keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
			{
				"<leader>fm",
				function()
					require("telescope").extensions.media_files.media_files()
				end,
				desc = "Find Media Files",
			},
		},
		opts = {
			media_files = {
				-- filetypes whielist
				-- defaults to png, jpg, mp4, webm, pdf
				filetypes = { "png", "webp", "jpg", "jpeg" },
			},
		},
	},
}