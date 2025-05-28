return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			ensure_installed = { "codelldb", "node2" },
			handlers = {},
		})

		require("dap-go").setup()
		dapui.setup()

		-- Automatically open UI when debugging
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		require("nvim-dap-virtual-text").setup({
			-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
			display_callback = function(variable)
				local name = string.lower(variable.name)
				local value = string.lower(variable.value)
				if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
					return "*****"
				end

				if #variable.value > 15 then
					return " " .. string.sub(variable.value, 1, 15) .. "... "
				end

				return " " .. variable.value
			end,
		})

		-- zig/c : use(codelldb)
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.c = {
			{
				name = "Debug C Binary",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to C binary: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
		dap.configurations.zig = {
			{
				name = "Debug Zig Binary",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}

		-- node.js (JavaScript/TypeScript)
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
		}

		dap.configurations.javascript = {
			{
				name = "Launch Node.js App",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
		}
		dap.configurations.typescript = dap.configurations.javascript

		-- eval var under cursor
		vim.keymap.set("n", "<Leader>?", function()
			require("dapui").eval(nil, { enter = true })
		end, { desc = "[DAP] eval var under cursor" })

		-- keybind
		vim.keymap.set("n", "<leader>1", dap.continue, { desc = "[DAP] continue" })
		vim.keymap.set("n", "<leader>2", dap.step_into, { desc = "[DAP] step Into" })
		vim.keymap.set("n", "<leader>3", dap.step_over, { desc = "[DAP] step Over" })
		vim.keymap.set("n", "<leader>4", dap.step_out, { desc = "[DAP] step Out" })
		vim.keymap.set("n", "<leader>5", dap.step_back, { desc = "[DAP] step Back" })
		vim.keymap.set("n", "<leader>0", dap.restart, { desc = "[DAP] restart" })

		vim.keymap.set("n", "<Leader>gb", dap.toggle_breakpoint, { desc = "[DAP] toggle breakpoint" })
		vim.keymap.set("n", "<Leader>gB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "[DAP] toggle breakpoint condition" })

		vim.keymap.set("n", "<leader>q", function()
			dap.terminate()
			dapui.close()
		end, { desc = "[DAP] terminate and close UI" })
		vim.keymap.set("n", "<Leader>gg", dap.run_to_cursor, { desc = "[DAP] run to cursor breakpoint" })
	end,
}
