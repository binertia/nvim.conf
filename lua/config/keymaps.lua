local keymaps = {}

--- close_current_pane : better :bd --------------------
--- close window better than close in developing -------
local function close_current_pane()
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(current_win)

	local windows = vim.api.nvim_tabpage_list_wins(0)
	local is_buffer_in_other_windows = false

	for _, win in ipairs(windows) do
		if win ~= current_win and vim.api.nvim_win_get_buf(win) == current_buf then
			is_buffer_in_other_windows = true
			break
		end
	end

	if is_buffer_in_other_windows then
		vim.cmd("close")
	else
		vim.api.nvim_buf_delete(current_buf, { force = true })
	end
end
---------------------------------------------------------------

function keymaps.setup()
	------------ ez life -----------
	vim.keymap.set("i", "<C-q>", "`")
	vim.keymap.set("i", "<C-c>", "<esc>")
	------------ no Q --------------
	vim.keymap.set("n", "Q", "<nop>")
	------------ move highlight code down-up ------------------
	vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move highlight down 1 line" })
	vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move highlight up 1 line" })

	------------ move between buffer --------------------------
	vim.keymap.set("n", "L", vim.cmd.bn)
	vim.keymap.set("n", "H", vim.cmd.bN)

	------------ move up down with center ---------------------
	vim.keymap.set("n", "<C-d>", "<C-d>zz")
	vim.keymap.set("n", "<C-u>", "<C-u>zz")
	------------ next search highlight center ----------------
	vim.keymap.set("n", "n", "nzzzv")
	vim.keymap.set("n", "N", "Nzzzv")

	------------ time for Yank -------------------------------
	vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
	vim.keymap.set("n", "<leader>Y", [["+Y]])

	------------ time for paste -------------------------------
	vim.keymap.set("x", "<leader>p", [["_dP]])

	------------ del line
	vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

	-- window resize ---
	vim.keymap.set("n", "<C-w>r", ":resize 10<CR>", { desc = "Resize window to 10 line" })
	vim.keymap.set("n", "<C-w>f", ":resize 100<CR>", { desc = "Resize window to 100 line" })
	-- close the current window (not buffer) -------------------------
	vim.keymap.set("n", "<leader>bd", close_current_pane, { desc = "Close Current Pane" })

	-- remove search highlight --------
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- move around list ---------------
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

	-- happy jest ---------------------
	vim.keymap.set("n", "<leader>ee", "oit('should Z', () => {<CR>  Z<CR> })<Esc><CR>O}<Esc>")
	vim.keymap.set("n", "<leader>er", "oexpect(Z).toZ(Z);<Esc>")
	vim.keymap.set("n", "<leader>et", "oexpect((Z) => { <C-r><C-w>() }).toThrow();<Esc>")

	-- fast rename in file ------------
	vim.keymap.set("n", "<leader>snr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

	-- Diagnostic keymaps
	vim.keymap.set("n", "<C-s>ld", vim.diagnostic.setloclist, { desc = "[L]ist [D]iagnostic" })

	-- move between pane ----
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	-- Function to convert px to em
	local function convert_px_to_em()
		local line = vim.api.nvim_get_current_line()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local cursor_col = cursor_pos[2]

		local match = line:sub(cursor_col):match("(%d+)px")

		if match then
			local px_value = tonumber(match)
			if px_value then
				local em_value = px_value / 16

				-- replace px with em in the current line
				local new_line = line:sub(1, cursor_col) .. em_value .. "em" .. line:sub(cursor_col + #match + 3)
				vim.api.nvim_set_current_line(new_line)
			else
				print("Invalid px value")
			end
		else
			print("No px value found")
		end
	end

	-- Bind the function to the Leader key + 'ce' in Normal Mode
	vim.api.nvim_create_user_command("ConvertPxToEm", convert_px_to_em, { desc = "Convert px to em under cursor" })

	vim.api.nvim_set_keymap("n", "<Leader>ce", ":ConvertPxToEm<CR>", { noremap = true, silent = true })
end

return keymaps
