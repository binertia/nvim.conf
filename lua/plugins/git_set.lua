return { -- neogit and diffview is good for working on change.
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{
		"sindrets/diffview.nvim",
		opts = {
			keymaps = {
				view = {
					-- close diffview
					{ "n", "<leader>co", "<Cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
				},
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			integrations = {
				diffview = true,
			},
		},
	},
}
