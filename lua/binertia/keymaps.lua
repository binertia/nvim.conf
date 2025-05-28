-- ** QOL ** --
vim.keymap.set("i", "<C-q>", "`", { desc = "back tick" })

vim.keymap.set("i", "<C-c>", "<esc>", { desc = "escape" })

vim.keymap.set("n", "<C-w>r", ":resize 10<CR>", { desc = "resize window to 10 line" })
vim.keymap.set("n", "<C-w>f", ":resize 100<CR>", { desc = "resize window to 100 line" })

vim.keymap.set(
	"n",
	"<leader>snr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "search & replace (infile)" }
)

-- move inside list ---------------
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- clear QuickfixList and cclose
vim.keymap.set("n", "<leader>cq", function()
	vim.fn.setqflist({})
	vim.cmd("cclose")
end, { desc = "Clear Quickfix List" })

-- list function (lsp)
vim.keymap.set("n", "<leader>lf", function()
	require("telescope.builtin").lsp_workspace_symbols({ symbols = { "function" } })
end, { desc = "List Functions (LSP)" })

-- list class (lsp)
vim.keymap.set("n", "<leader>lo", function()
	require("telescope.builtin").lsp_workspace_symbols({ symbols = { "class" } })
end, { desc = "List Class (LSP)" })

-- list method (lsp)
vim.keymap.set("n", "<leader>lm", function()
	require("telescope.builtin").lsp_workspace_symbols({ symbols = { "method" } })
end, { desc = "List Method (LSP)" })

-- no need to care after this line ------------------------------------------------------------------
vim.keymap.set({ "n", "v", "x", "i" }, "<C-a>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "v", "x", "i" }, "<C-space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- next buffer, prev buffer
vim.keymap.set("n", "L", vim.cmd.bn, { desc = ":bn" })
vim.keymap.set("n", "H", vim.cmd.bN, { desc = ":bN" })

-- primeagen mention
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "move focus to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "move focus to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "move focus to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "move focus to upper window" })
vim.keymap.set("n", "n", "nzzzv", { desc = "better next search result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "better previous search result" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "better yank" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "yank from cursor till end of line" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "p without change clipboard (useful for visual paste)" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move highlight down 1 line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move highlight up 1 line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "jump up 20 line (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "jump up 20 line (centered)" })

-- set lsp hover border to round TODO: move to lsp or else
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded" })
end)
