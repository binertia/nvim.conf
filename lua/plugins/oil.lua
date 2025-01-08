return {
	"stevearc/oil.nvim",
	-- -@module 'oil'
	-- -@type oil.SetupOpts
	config = function()
		require("oil").setup({
			keymaps = {
				["<C-h>"] = false,
			},
			view_options = {
				show_hidden = true,
			},
		})

		vim.api.nvim_create_user_command("Ex", function()
			vim.cmd("Oil")
		end, {})
	end,
	opts = {},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
