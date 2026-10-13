local terminal = os.getenv("TERM")
if terminal == "xterm-kitty" then
	return {}
end

return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	opts = {
		cursor_color = "#ff4000",
		particles_enabled = true,
		particle_max_num = 200,
		stiffness = 0.5,
		trailing_stiffness = 0.2,
		trailing_exponent = 5,
		damping = 0.6,
		gradient_exponent = 0,
		legacy_computing_symbols_support = true,
		min_horizontal_distance_smear = 3,
		min_vertical_distance_smear = 3,
		filetypes_disabled = {
			"snacks_terminal",
			"lazy",
		},
	},
}
