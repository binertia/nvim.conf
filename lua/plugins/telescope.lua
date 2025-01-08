return {
	-- Fuzzy Finder (files, lsp, etc)

	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
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
		--------------- helper -------------------
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		local result_to_location_list = function(prompt_bufnr)
			actions.smart_send_to_loclist(prompt_bufnr)
			vim.cmd("lopen")
		end

		local result_to_quick_fix_list = function(prompt_bufnr)
			actions.smart_send_to_qflist(prompt_bufnr)
			vim.cmd("lopen")
		end

		local function split_bottom_short(prompt_bufnr)
			actions.select_horizontal(prompt_bufnr)
			vim.cmd("resize 10")
		end

		-------------------------------------------

		------------- telescope key mapping -------

		local common_mappings = {
			["<C-n>"] = actions.move_selection_next,
			["<C-p>"] = actions.move_selection_previous,
			["<C-j>"] = actions.preview_scrolling_down,
			["<C-k>"] = actions.preview_scrolling_up,
			["<C-f>l"] = result_to_location_list,
			["<C-f>q"] = result_to_quick_fix_list,
			["<C-f>b"] = split_bottom_short,
		}

		telescope.setup({
			defaults = {
				mappings = {
					i = vim.tbl_extend("force", common_mappings, {

						--- only i mode telescope keymap

						["<C-Enter>"] = "to_fuzzy_refine",
					}),
					n = common_mappings,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		local builtin = require("telescope.builtin")

		local function map(mode, key, fn, desc)
			vim.keymap.set(mode, key, fn, { desc = desc, noremap = true, silent = true })
		end

		--- helper function ---
		local function fuzzyCurrentBuf()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				previewer = false,
			}))
		end

		local function listNvimFiles()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end

		local function fuzzyAllBuf()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end

		local function grep_insensitive()
			builtin.grep_string({
				search = vim.fn.expand("<cword>"), -- Get the word under the cursor
				case_mode = "ignore_case", -- Make the search case-insensitive
			})
		end

		------------------------

		-- keymap --
		map("n", "<C-s>h", builtin.help_tags, "[S]earch [H]elp")
		map("n", "<C-s>k", builtin.keymaps, "[S]earch [K]eymaps")
		map("n", "<C-s>f", builtin.find_files, "[S]earch [F]iles")
		map("n", "<C-s>g", builtin.git_files, "[S]earch [G]it Files")
		map("n", "<C-s>w", builtin.grep_string, "[S]earch current [W]ord : sensitive")
		map("n", "<C-s><C-w>", grep_insensitive, "[S]earch current [W]ord : insensitive")
		map("n", "<C-s>W", builtin.live_grep, "[S]earch by [G]rep")
		map("n", "<C-s>p", builtin.diagnostics, "[S]earch [P]roblem")
		map("n", "<C-s>r", builtin.resume, "[S]earch [R]esume")
		map("n", "<C-s>o.", builtin.oldfiles, '[S]earch [O]ld Files ("." for repeat)')
		map("n", "<C-s>b", builtin.buffers, "[S]ind existing [B]uffers")
		map("n", "<C-s><C-s>", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, "Project Search")

		map("n", "<C-s>/", fuzzyCurrentBuf, "[/] Fuzzily search in current buffer")
		map("n", "<C-s>?", fuzzyAllBuf, "[S]earch [/] in Open Files")
		map("n", "<C-s>n", listNvimFiles, "[S]earch [N]eovim files")
	end,
}
