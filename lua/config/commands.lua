local commands = {}

function commands.setup()
	-- custom command --
	vim.api.nvim_create_user_command("CopySwapName", function()
		desc = "Copy current swap file for resolve conflict to sys.clipboard", vim.cmd("redir => output")
		vim.cmd("swapname")
		vim.cmd("redir END")
		vim.fn.system('echo "' .. vim.g.output .. '" | pbcopy')
	end, {})

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank()
		end,
	})

	--- auto command --

	local autocmd = vim.api.nvim_create_autocmd

	autocmd("TextYankPost", {
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({
				higroup = "IncSearch",
				timeout = 40,
			})
		end,
	})

	autocmd({ "BufWritePre" }, {
		pattern = "*",
		command = [[%s/\s\+$//e]],
	})
end

return commands
