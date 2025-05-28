local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("binertia.setting") -- env setting
require("binertia.keymaps") -- qol map

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
	ui = {
		border = "rounded",
		size = {
			width = 0.8,
			height = 0.8,
		},
	},
	checker = { enabled = true, notify = false },
	change_detection = {
		notify = false,
	},
})
-- no bg for StatuslineFileName area
vim.api.nvim_set_hl(0, "Statusline", { bg = "none" })

-- this file will break nvim if you dont have tmux, remove it or go in file and remove tmux 2 custom command keymap
require("binertia.cmd-keymaps") -- custom-cmd : keymap set
