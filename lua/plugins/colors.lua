return {
	{
		"morhetz/gruvbox",
	},

	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		light_style = "night", -- The theme is used when the background is set to light
		transparent = true, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			sidebars = "transparent",
			floats = "transparent",
		},
		sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
		dim_inactive = false, -- dims inactive windows
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

		--- You can override specific color groups to use other groups or a hex color
		--- function will be called with a ColorScheme table
		-- ---@param colors ColorScheme
		-- on_colors = function(colors) end,
		--
		-- --- You can override specific highlights to use other groups or a hex color
		-- --- function will be called with a Highlights and ColorScheme table
		-- ---@param highlights Highlights
		-- ---@param colors ColorScheme
		-- on_highlights = function(highlights, colors) end,

		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("tokyonight-night")

			vim.cmd([[
highlight Normal guibg=NONE ctermbg=NONE
      highlight NormalNC guibg=NONE ctermbg=NONE     
      highlight NonText guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight VertSplit guibg=NONE ctermbg=NONE   
      highlight StatusLine guibg=NONE ctermbg=NONE 
      highlight StatusLineNC guibg=NONE ctermbg=NONE
      highlight TabLine guibg=NONE ctermbg=NONE    
      highlight TabLineFill guibg=NONE ctermbg=NONE
      highlight TabLineSel guibg=NONE ctermbg=NONE
      highlight CursorLine guibg=#19202F ctermbg=NONE

      highlight StatusLineFileNameNC guibg=white ctermbg=white  
    ]])
			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
}
