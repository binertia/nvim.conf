vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- default --
opt.laststatus = 2
opt.showtabline = 0
opt.clipboard = ""
opt.autowrite = false
opt.cursorline = true
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

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
opt.scrolloff = 8

-- end of buffer :('~') > none --
opt.fillchars = "eob: "

-- line number ---
opt.number = true
opt.relativenumber = true

-- firaCode typeface--
vim.o.guifont = "FiraCode Nerd Font:h14"
vim.g.have_nerd_font = true

-- disable mouse mode : = "a" to enable
opt.mouse = ""

opt.showmode = true
opt.breakindent = true

-- case-insensitive searching
opt.ignorecase = true
opt.smartcase = true

-- keep signcolumn on by default
opt.signcolumn = "yes:1"

-- decrease update time
opt.updatetime = 50

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

opt.list = false
opt.inccommand = "split"

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.nvswap"
opt.undofile = true
