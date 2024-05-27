return {
	"folke/tokyonight.nvim",
	enabled = true,
	lazy = false,
	priority = 1000,

	opts = function(_, opts)
		local transparent = true
		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"
		opts.transparent = transparent
		opts.style = "night"
		opts.styles = {
			comments = { italic = true },
			keywords = { italic = true },
			sidebars = transparent and "transparent" or "dark",
			floats = transparent and "transparent" or "dark",
			hide_inactive_statusline = true,
			lualine_bold = true,
		}

		opts.on_colors = function(colors)
			colors.bg = bg
			colors.bg_dark = transparent and colors.none or bg_dark
			colors.bg_float = transparent and colors.none or bg_dark
			colors.bg_highlight = bg_highlight
			colors.bg_popup = bg_dark
			colors.bg_search = bg_search
			colors.bg_sidebar = transparent and colors.none or bg_dark
			colors.bg_statusline = transparent and colors.none or bg_dark
			colors.bg_visual = bg_visual
			colors.border = border
			colors.fg = fg
			colors.fg_dark = fg_dark
			colors.fg_float = fg
			colors.fg_gutter = fg_gutter
			colors.fg_sidebar = fg_dark
		end
	end,

	config = function(_, opts)
		require("tokyonight").setup(opts)
	end,
}
