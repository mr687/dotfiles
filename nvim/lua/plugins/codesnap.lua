return {
	{
		"mistricky/codesnap.nvim",
		event = "BufRead",
		build = "make build_generator",
		opts = {
			save_path = os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures"),
			has_breadcrumbs = true,
			has_line_number = true,
			bg_theme = "bamboo",
			watermark = "",
		},
	},
}
