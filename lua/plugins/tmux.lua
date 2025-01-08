return {
	{
		-- {
		-- 	"vimpostor/vim-tpipeline",
		-- 	config = function()
		-- 		vim.g.tpipeline_restore = 1
		-- 		vim.g.tpipeline_statusline =
		-- 			-- "       #[fg=#96CEB4]%f#[fg=default]       #[fg=#C8CFA0]%y#[fg=default]   %=       🍌  #[fg=#96CEB4]⌽════⌽#[fg=default]  🦧      %l, %c   %p %%   "
		-- 			-- vim.g.tpipeline_statusline = "                %f           %y                                    %p %%   "
		-- 			"#[fg=#96CEB4]%F#[fg=default]   #[fg=#C8CFA0]%y#[fg=default]"
		-- 	end,
		-- }, -- Example of style, adjust it based on available themes if necessary
		-- 	-- Additional settings for customization of pipeline line
		-- 	-- You can adjust these settings to make the line match your theme
		{
			"numToStr/Navigator.nvim",
			lazy = false,
			config = function()
				require("Navigator").setup({
					-- Save modified buffer(s) when moving to mux
					-- nil - Don't save (default)
					-- 'current' - Only save the current modified buffer
					-- 'all' - Save all the buffers
					auto_save = nil,

					-- Disable navigation when the current mux pane is zoomed in
					disable_on_zoom = false,

					-- Multiplexer to use
					-- 'auto' - Chooses mux based on priority (default)
					-- table - Custom mux to use
					mux = "auto",
				})
				require("Navigator").left()
				require("Navigator").right()
				require("Navigator").up()
				require("Navigator").down()
				require("Navigator").previous()
			end,
		},

		{
			"christopher-francisco/tmux-status.nvim",
			lazy = true,
			opts = {},
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
	},
}
