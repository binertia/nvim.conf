return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		"folke/lazydev.nvim",
	},

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "super-tab",
			["<C-space>"] = {},
			["<C-k>"] = { "show_documentation", "hide_documentation" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			window = {
				winhighlight = "Normal:CmpMenu,FloatBorder:CmpMenuBorder",
			},
			scrollbar = false,
			accept = { auto_brackets = { enabled = false } },
			documentation = {
				treesitter_highlighting = true,
				window = {
					winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder",
					border = "rounded",
					winblend = 0,
				},
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			menu = {
				winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder",
				border = "rounded",
				winblend = 0,

				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
					treesitter = { "lsp" },
				},
			},
		},
		signature = {
			enabled = true,
			window = {
				winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder",
				border = "rounded",
			},
		},

		ghost_text = { enabled = false },

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
