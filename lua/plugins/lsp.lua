return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },

		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				local telescope = require("telescope.builtin")

				-- open in split
				-- local function split_bottom_short(prompt_bufnr)
				-- 	actions.select_horizontal(prompt_bufnr)
				-- 	vim.cmd("resize 10")
				-- end
				local function open_in_split(telescope_func)
					return function()
						telescope_func({
							reuse_win = false,
							jump_type = "split",
						})
					end
				end

				-- local function open_in_split_resize(callback)
				-- 	return function()
				-- 		-- Open the split with the callback (e.g., telescope.lsp_definitions)
				-- 		vim.cmd("belowright split")
				-- 		vim.cmd("resize 10") -- Resize the split to 10 lines
				-- 		callback()
				-- 	end
				-- end

				map("<C-g>d", open_in_split(telescope.lsp_definitions), "[G]oto [D]efinition")
				-- Find references for the word under your cursor.
				map("<C-g>r", open_in_split(telescope.lsp_references), "[G]oto [R]eferences")
				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("<C-g>i", open_in_split(telescope.lsp_implementations), "[G]oto [I]mplementation")
				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				map("<C-g>t", open_in_split(telescope.lsp_type_definitions), "[G]oto [T]ype Definition")
				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<C-g>s", require("telescope.builtin").lsp_document_symbols, "[G]oto Document [S]ymbols")
				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map(
					"<C-g>ws",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[G]oto [W]orkspace [S]ymbols"
				)
				-- Change name the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>cn", vim.lsp.buf.rename, "[C]hange name")
				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>cc", vim.lsp.buf.code_action, "[C]hange [C]ode (code action)", { "n", "x" })
				-- WARN: This is not Goto Definition, this is Goto Declaration.
				map("<C-g>D", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				---------------------------------------------------------
				--- LSP: list all function in file ---
				map("<leader>ff", function()
					telescope.lsp_document_symbols({ symbols = "function" })
				end, "[F]etch file [F]unction")

				--- LSP: list all variable in file
				map("<leader>fv", function()
					telescope.lsp_document_symbols({ symbols = "variable" })
				end, "[F]etch file [V]ariable")

				-- peek document
				local function hover_documentation()
					vim.lsp.buf.hover()
				end

				-- keymap : peek document
				vim.keymap.set("n", "<leader>pd", hover_documentation, { desc = "[F]etch [D]ocumentation" })

				----------------------------------------------------------

				-- peek references
				local function peek_references()
					vim.lsp.buf.references({
						include_declaration = false, -- Optional: Exclude declarations, show only references
						prompt_title = "References",
					})
				end

				-- keymap : peek references
				vim.keymap.set("n", "<leader>pr", peek_references, { desc = "[F]unction [R]eferences" })

				----------------------------------------------------------
				--
				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Change diagnostic symbols in the sign column (gutter)
		-- if vim.g.have_nerd_font then
		--   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
		--   local diagnostic_signs = {}
		--   for type, icon in pairs(signs) do
		--     diagnostic_signs[vim.diagnostic.severity[type]] = icon
		--   end
		--   vim.diagnostic.config { signs = { text = diagnostic_signs } }
		-- end

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			ols = {},
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`ts_ls`) will work just fine
			-- ts_ls = {},
			--

			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
