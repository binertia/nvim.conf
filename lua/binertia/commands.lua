local M = {}

-- close current window
function M.close_current_pane()
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

-- convert px to em
function M.convert_px_to_em()
	local line = vim.api.nvim_get_current_line()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local cursor_row, cursor_col = cursor_pos[1], cursor_pos[2]

	local start_pos, end_pos, px_value = line:find("(%d+%.?%d*)px", cursor_col + 1)

	if not start_pos then
		start_pos, end_pos, px_value = line:find("(%d+%.?%d*)px")
		if not start_pos then
			vim.notify("No px value found", vim.log.levels.WARN)
			return
		end
	end

	local px_num = tonumber(px_value)
	if not px_num then
		vim.notify("Invalid px value", vim.log.levels.ERROR)
		return
	end

	local em_value = string.format("%.4f", px_num / 16):gsub("%.?0+$", "")
	if em_value:sub(-1) == "." then
		em_value = em_value:sub(1, -2)
	end

	-- Create new line with replacement
	local new_line = line:sub(1, start_pos - 1) .. em_value .. "em" .. line:sub(end_pos + 1)
	vim.api.nvim_set_current_line(new_line)

	-- Restore cursor position
	vim.api.nvim_win_set_cursor(0, { cursor_row, cursor_col })

	vim.notify("Converted " .. px_value .. "px to " .. em_value .. "em", vim.log.levels.INFO)
end

return M
