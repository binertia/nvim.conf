return { -- tokyonight that will not hurt your eyes, you can change comment to another color if you found it really bad match
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		terminal_colors = true,
		on_colors = function(colors)
			colors.comment = "#6a8e94"
		end,
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			sidebars = "transparent",
			floats = "transparent",
		},
		sidebars = { "qf", "help" },
		hide_inactive_statusline = true,
		dim_inactive = true,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight-storm]])
	end,
}
