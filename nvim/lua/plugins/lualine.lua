return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = function()
		local icons = LazyVim.config.icons

		return {
			options = {
				component_separators = { left = " ", right = " " },
				section_separators = { left = " ", right = " " },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icon = "",
						fmt = function(mode)
							return mode:lower()
						end,
					},
				},
				lualine_b = { { "branch", icon = "" } },
				lualine_c = {
					LazyVim.lualine.root_dir(),
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 0, right = 0 } },
					{ LazyVim.lualine.pretty_path() },
				},
			},
		}
	end,
}
