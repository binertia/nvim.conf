local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local T = {}

-- if you want to use. config it to match your env.
-- tp function
function T.launch_tmux_session()
	local handle = io.popen("fd . ~/Project ~/.config ~/Works --type d --max-depth=3")
	if not handle then
		return
	end
	local result = handle:read("*a")
	handle:close()

	local home = os.getenv("HOME")

	local dirs = {}
	local display_dirs = {}

	for line in result:gmatch("[^\r\n]+") do
		table.insert(dirs, line)

		local display_path = line
		local dir_path = line:gsub("^" .. home .. "/", "")

		if dir_path:match("^Works/") then
			-- ~/Works path
			display_path = "  [W] 💻   " .. dir_path:gsub("^Works/", "")
		elseif dir_path:match("^Project/") then
			-- ~/Project path
			display_path = "  [P] 🌱   " .. dir_path:gsub("^Project/", "")
		elseif dir_path:match("^%.config/") then
			-- ~/.config path
			display_path = "  [C] 🗃️   " .. dir_path:gsub("^%.config/", "")
		else
			display_path = "~ " .. dir_path
		end

		table.insert(display_dirs, display_path)
	end

	pickers
		.new({}, {
			prompt_title = "Select Project Directory",
			finder = finders.new_table({
				results = dirs,
				entry_maker = function(entry)
					local index = 0
					for i, dir in ipairs(dirs) do
						if dir == entry then
							index = i
							break
						end
					end

					return {
						value = entry,
						display = display_dirs[index],
						ordinal = display_dirs[index],
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map) -- ignore LSP warning, it's dump
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local dir = selection and selection.value
					if not dir then
						return
					end

					local dirname = dir:match("([^/]+)/?$") -- remove the last part of path

					-- check in tmux or else
					local in_tmux = os.getenv("TMUX") ~= nil

					if not in_tmux then
						print("Not in tmux. Session canceled.")
						return
					end

					-- check session already exists = "switch" else "make new one"
					local check_cmd = string.format("tmux has-session -t '%s' 2>/dev/null", dirname)
					local session_exists = os.execute(check_cmd) == 0

					if session_exists then
						os.execute(string.format("tmux switch-client -t '%s'", dirname))
					else
						local create_cmd = string.format("tmux new-session -s '%s' -c '%s' -d", dirname, dir)
						os.execute(create_cmd)
						os.execute(string.format("tmux send-keys -t '%s' 'nvim .' C-m", dirname))
						os.execute(string.format("tmux switch-client -t '%s'", dirname))
					end
				end)
				return true
			end,
		})
		:find()
end

-- for fast switching between each session with telesceope (use case : if you need >3 session)
function T.switch_tmux_session()
	local in_tmux = os.getenv("TMUX") ~= nil

	if not in_tmux then
		print("Not in tmux. Session switching canceled.")
		return
	end

	-- Get list of tmux sessions
	local handle = io.popen("tmux list-sessions -F '#{session_name}:#{session_windows}:#{session_attached}'")
	if not handle then
		print("Failed to get tmux sessions")
		return
	end

	local result = handle:read("*a")
	handle:close()

	local sessions = {}
	local display_sessions = {}
	local current_session = ""

	-- Parse tmux sessions
	for line in result:gmatch("[^\r\n]+") do
		local session_name, windows, attached = line:match("([^:]+):([^:]+):([^:]+)")

		if session_name then
			table.insert(sessions, session_name)

			-- Format display string with windows count and attachment status
			local display = session_name

			-- Add window count
			display = display .. " [" .. windows .. " window" .. (tonumber(windows) ~= 1 and "s" or "") .. "]"

			-- Mark current session
			if attached == "1" then
				display = display .. " (current)"
				current_session = session_name
			end

			table.insert(display_sessions, display)
		end
	end

	if #sessions == 0 then
		print("No tmux sessions found")
		return
	end

	pickers
		.new({}, {
			prompt_title = "Switch Tmux Session",
			finder = finders.new_table({
				results = sessions,
				entry_maker = function(entry)
					local index = 0
					for i, session in ipairs(sessions) do
						if session == entry then
							index = i
							break
						end
					end

					return {
						value = entry,
						display = display_sessions[index],
						ordinal = display_sessions[index],
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map) -- same as above, ignore lsp
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local session_name = selection and selection.value

					if not session_name then
						return
					end

					if session_name == current_session then
						print("Already in session: " .. session_name)
						return
					end

					os.execute(string.format("tmux switch-client -t '%s'", session_name))
				end)
				return true
			end,
		})
		:find()
end

return T
