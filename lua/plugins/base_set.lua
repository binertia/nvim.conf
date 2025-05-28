return { -- tpope
	{
		"tpope/vim-sleuth", -- detect tabstop and shiftwidth automatically
	},
	{
		"tpope/vim-commentary",
	},
	{
		"tpope/vim-obsession",
		event = "VeryLazy",
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
}
