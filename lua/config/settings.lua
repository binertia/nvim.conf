local settings = {}

function settings.setup()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	local opt = vim.opt
	-- vim.o.statusline = "      %t"

	-- default --
	-- opt.guicursor = ""
	opt.laststatus = 2
	opt.showtabline = 0
	opt.clipboard = ""
	opt.autowrite = false

	-- tab --
	opt.shiftwidth = 4
	-- opt.smarttab = false
	opt.smartindent = true
	opt.tabstop = 4
	opt.softtabstop = 4
	opt.expandtab = true

	-- column --
	opt.signcolumn = "no"
	opt.wrap = true
	opt.cursorline = false
	opt.scrolloff = 8

	-- end of buffer :('~') > none --
	opt.fillchars = "eob: "

	-- line number ---
	opt.number = true
	opt.relativenumber = true

	-- FiraCode typeface--
	vim.o.guifont = "FiraCode Nerd Font:h14"
	-- vim.g.have_nerd_font = true

	-- Enable mouse mode, can be useful for resizing splits for example!
	opt.mouse = "a"

	-- Don't show the mode, since it's already in the status line
	-- opt.showmode = true
	opt.breakindent = true

	-- Save undo history
	opt.undofile = true

	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	opt.ignorecase = true
	opt.smartcase = true

	-- Keep signcolumn on by default
	-- opt.signcolumn = "yes"

	-- Decrease update time
	opt.updatetime = 50

	-- Decrease mapped sequence wait time
	opt.timeoutlen = 300

	-- Configure how new splits should be opened
	opt.splitright = true
	opt.splitbelow = true

	opt.list = false
	-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

	opt.inccommand = "split"

	-- Show which line your cursor is on
	opt.cursorline = true

	-- Minimal number of screen lines to keep above and below the cursor.
	opt.scrolloff = 8

	vim.g.netrw_browse_split = 0
	vim.g.netrw_banner = 0
	vim.g.netrw_winsize = 25

	opt.swapfile = false
	opt.backup = false
	opt.undodir = os.getenv("HOME") .. "/.nvswap"
	opt.undofile = true

	-- Set the statusline to display path in white and filename in yellow
	-- Set the statusline to display path in white and filename in yellow
	-- Set the statusline format
	-- vim.o.statusline =
	-- 	"%#StatusLine#%{fnamemodify(expand('%:p:h'), ':~')}%*/%#StatusLineFilename#%{expand('%:t')}%* %m %= %l ,%c %p%%"

	vim.o.statusline = "   %#StatusLine#%{fnamemodify(expand('%:p:h'), ':~')}%*/%#StatusLineFilename#%{expand('%:t')}%*"
		.. "  %m  %=%#StatusLineMode#%y%*    "
		.. "%=%-3l"
		.. ",%-3c   "
		.. "%-3p%%    %<"
	-- Highlight the full path part in white

	-- Highlight the filename part in ellow
end

return settings
