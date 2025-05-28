return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = {},
			},

			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		local ts = require("telescope")
		local standard_setup = {
			borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			preview = { hide_on_startup = true },
			layout_strategy = "vertical",
			layout_config = {
				vertical = {
					mirror = true,
					prompt_position = "top",
					width = function(_, cols, _)
						return cols
					end,
					height = function(_, _, rows)
						return rows
					end,
					preview_cutoff = 10,
					preview_height = 0.4,
				},
			},
		}
		ts.setup({
			defaults = vim.tbl_extend("error", standard_setup, {
				sorting_strategy = "ascending",
				path_display = { "filename_first" },
				mappings = {
					n = {
						["<C-k>"] = require("telescope.actions.layout").toggle_preview,
						["<C-c>"] = require("telescope.actions").close,
						["<C-o>"] = require("telescope.actions").send_selected_to_qflist,
						["<C-f>"] = require("telescope.actions").delete_buffer,
					},
					i = {
						["<C-k>"] = require("telescope.actions.layout").toggle_preview,
						["<C-o>"] = require("telescope.actions").send_selected_to_qflist,
						["<C-f>"] = require("telescope.actions").delete_buffer,
					},
				},
			}),
			pickers = {
				find_files = {
					find_command = {
						"fd",
						"--type",
						"f",
						"-H",
						"--strip-cwd-prefix",
					},
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")

		-- helper grep
		local function grep_insensitive()
			builtin.grep_string({
				search = vim.fn.expand("<cword>"),
				case_mode = "ignore_case",
			})
		end

		-- wrapper function
		local function with_opts(fn, opts)
			return function()
				fn(opts)
			end
		end

		-- telescope keymaps
		local mappings = {
			{ "<leader>sh", builtin.help_tags, "Search Help", "🦍 Search Help" },
			{ "<leader>sk", builtin.keymaps, "Search Keymaps" },
			{ "<C-s>f", builtin.find_files, "Search Files (root)", "📁 Search Files" },
			{ "<C-s>s", builtin.builtin, "Search Select Telescope", "🔧 Telescope Pickers" },
			{ "<C-s>w", builtin.grep_string, "Search current Word", "🔎 Word Under Cursor" },
			{ "<C-s>g", builtin.live_grep, "Search Word (Grep)", "🔎 Grep work dir" },
			{ "<C-s>d", builtin.diagnostics, "Search Diagnostics", "🚨 Diagnostics" },
			{ "<C-s>r", builtin.resume, "Search Resume", "⏪ Resume Search" },
			{ "<C-s>o", builtin.oldfiles, "Search Old files", "🕘 Recent Files" },
			{ "<C-s>b", builtin.buffers, "Search existing Buffers", "📄 Open Buffers" },
			{ "<C-s><C-w>", grep_insensitive, "Search current Word : insensitive", " grep stronk" },
		}

		-- set keymap by wrapper and mapping {}
		for _, map in ipairs(mappings) do
			local lhs, fn, desc, prompt = unpack(map)
			local rhs = prompt and with_opts(fn, { prompt_title = prompt }) or fn
			vim.keymap.set("n", lhs, rhs, { desc = desc })
		end

		-- default telescope / from kickstart.nvim
		vim.keymap.set("n", "<C-s>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 0,
				previewer = false,
			}))
		end, { desc = "Fuzzily search current buffer" })

		-- grep from all buffer open
		vim.keymap.set("n", "<C-s>?", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "grep all buffers",
			})
		end, { desc = "Fuzzily search all buffers" })

		-- primeagen grep++ : it's really useful
		vim.keymap.set("n", "<C-s><C-g>", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Search word++ (Grep)" })

		-- nvim conf files
		vim.keymap.set("n", "<leader>sx", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search Nvim conf" })

		-- search all man in $(MAN_PATH)
		vim.keymap.set("n", "<leader>sm", function()
			require("telescope.builtin").man_pages({
				prompt_title = "📘 Man Pages",
				sections = { "1", "2", "3" }, -- Most common sections
			})
		end, { desc = "Search Man Pages" })
	end,
}
