return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				vtsls = {
					initialization_options = {
						settings = {
							typescript = {
								tsserver = {
									maxTsServerMemory = 8192,
								},
							},
						},
					},
					settings = {
						typescript = {
							tsserver = {
								maxTsServerMemory = 8192,
							},
						},
					},
				},
			},
		},
	},
}
