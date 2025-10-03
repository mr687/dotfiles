return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1,
		---@param opts tokyonight.Config
		opts = function(_, opts)
			local transparent = true

			opts.transparent = transparent
			opts.style = "moon"
			opts.light_style = "day"
			opts.styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { bold = true },
				variables = { bold = true, italic = true },
				sidebars = transparent and "transparent" or "dark",
				floats = transparent and "transparent" or "dark",
				hide_inactive_statusline = true,
				lualine_bold = true,
			}
			opts.cache = true

			opts.on_colors = function(colors)
				colors.bg_dark = transparent and colors.none or colors.bg_dark
				colors.bg_float = transparent and colors.none or colors.bg_float
				colors.bg_sidebar = transparent and colors.none or colors.bg_sidebar
				colors.bg_statusline = transparent and colors.none or colors.bg_statusline

				colors.fg_gutter = colors.fg_dark
				colors.comment = colors.fg_dark
				colors.border = colors.fg_dark

				-- colors.bg = bg
				-- colors.bg_highlight = bg_highlight
				-- colors.bg_popup = bg_dark
				-- colors.bg_search = bg_search
				-- colors.bg_visual = bg_visual

				-- colors.fg = fg
				-- colors.fg_dark = fg_dark
				-- colors.fg_float = fg
				-- colors.fg_gutter = fg_gutter
				-- colors.fg_sidebar = fg_dark
			end
		end,

		config = function(_, opts)
			require("tokyonight").setup(opts)
		end,
	},
}
