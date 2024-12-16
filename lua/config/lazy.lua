-- Bootstrap lazy.nvim ---------------------------------------
-------------------------------------------------------------

-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
-- 	vim.fn.system({
-- 		"git",
-- 		"clone",
-- 		"--filter=blob:none",
-- 		"https://github.com/folke/lazy.nvim.git",
-- 		"--branch=stable",
-- 		lazypath,
-- 	})
-- end

-------------------------------------------------------------
-- config file to load --------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.tmux")

require("config.settings").setup()

require("config.commands").setup()

require("config.keymaps").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------
-- vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
--------------------------------------------------------------
-- Setup lazy.nvim -------------------------------------------

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = false },
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
--------------------------------------------------------------
