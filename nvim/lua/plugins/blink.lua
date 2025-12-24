return {
	"saghen/blink.cmp",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
			trigger = {
				-- show_on_keyword = false,
				-- show_on_backspace = false,
				-- show_on_backspace_in_keyword = false,
				-- show_on_backspace_after_accept = false,
				-- show_on_backspace_after_insert_enter = false,
				-- show_on_trigger_character = false,
				-- show_on_insert = false,
				-- show_on_accept_on_trigger_character = false,
				-- show_on_insert_on_trigger_character = false,
			},
			documentation = {
				auto_show = true,
			},
			ghost_text = {
				enabled = true,
			},
		},
		keymap = {
			-- Manual ghost text trigger - show completion with ghost text
			["<C-Space>"] = { "show" },
			["<C-@>"] = { "show" },
			["<CR>"] = { "accept", "fallback" },
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
				"dadbod",
			},
		},
		appearance = {
			-- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
			kind_icons = {
				Copilot = "",
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",

				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",

				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",

				Unit = "󰪚",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",

				Keyword = "󰻾",
				Constant = "󰏿",

				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󰪚",
				TypeParameter = "󰬛",
			},
		},
	},
}
