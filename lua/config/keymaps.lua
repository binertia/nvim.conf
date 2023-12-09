-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead

--local Util = require("lazyvim.util")
-- local map = Util.safe_keymap_set

vim.keymap.set("n", "<C-i>", "<Nop>")
-- move around buffer
vim.keymap.set("n", "L", vim.cmd.bn)
vim.keymap.set("n", "H", vim.cmd.bN)

--telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find projext file" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "find projext grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "find buffer" })
vim.keymap.set("n", "<leader>to", function()
    builtin.lsp_document_symbols({})
end, { desc = "find document_symbols" })
vim.keymap.set("n", "<leader>tf", function()
    builtin.lsp_document_symbols({ symbols = "function" })
end, { desc = "find document_symbols" })
vim.keymap.set("n", "<leader>ti", function()
    builtin.lsp_document_symbols({ symbols = "variable" })
end, { desc = "find document_symbols" })
vim.keymap.set("n", "<leader>Git", builtin.git_files, { desc = "git file" })
vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "treesitter" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "project search" })

--telescope undo
vim.keymap.set("n", "<leader>un", "<cmd>Telescope undo<cr>")

--fugitive
vim.keymap.set("n", "<leader>git", vim.cmd.Git, { desc = "show git" })

--tmux
vim.keymap.set({ "n", "t" }, "<C-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<CMD>NavigatorDown<CR>")
-- vim.keymap.set({ "n", "t" }, "<C-p>", "<CMD>NavigatorPrevious<CR>")

--terminal
-- local lazyterm = function()
--     Util.terminal(nil, { cwd = Util.root() })
-- end
-- map("n", "<leader>tp", lazyterm, { desc = "Terminal (root dir)" })
-- map("n", "<leader>tf", function()
--     Util.terminal()
-- end, { desc = "Terminal (cwd)" })
--
-- -- Terminal Mappings
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
