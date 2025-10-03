return {
	"saghen/blink.cmp",
	opts = {
		completion = {
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
			trigger = {
				show_on_keyword = false,
				show_on_backspace = false,
				show_on_backspace_in_keyword = false,
				show_on_backspace_after_accept = false,
				show_on_backspace_after_insert_enter = false,
				show_on_trigger_character = false,
				show_on_insert = false,
				show_on_accept_on_trigger_character = false,
				show_on_insert_on_trigger_character = false,
			},
			documentation = {
				auto_show = false,
			},
			ghost_text = {
				enabled = true,
			},
		},
		keymap = {
			-- Manual ghost text trigger - show completion with ghost text
			["<C-Space>"] = { "show" },
			["<C-@>"] = { "show" },
			-- Accept ghost text if visible, otherwise fallback to normal tab behavior
			["<Tab>"] = {
				function(cmp)
					if cmp.is_ghost_text_visible() then
						return cmp.accept()
					end
				end,
				"select_next",
				"fallback",
			},
			["<CR>"] = { "accept", "fallback" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					kind = "Copilot",
					score_offset = 100,
					async = true,
					transform_items = function(_, items)
						local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
						local kind_idx = #CompletionItemKind + 1
						CompletionItemKind[kind_idx] = "Copilot"
						for _, item in ipairs(items) do
							item.kind = kind_idx
						end
						return items
					end,
				},
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
