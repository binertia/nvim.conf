local cmd = require("binertia.commands")
local tmux = require("binertia.tmux-session")

vim.keymap.set("n", "<Leader>em", cmd.convert_px_to_em, { noremap = true, desc = "Convert px to em" })
vim.keymap.set("n", "<leader>bd", cmd.close_current_pane, { noremap = true, desc = "Close Current Pane" })

-- if you want to use with tmux. go to tmux-session file, config it to match your env.
vim.keymap.set("n", "<leader>tp", tmux.launch_tmux_session, { desc = "Tmux: Open Project in New Session" }) -- tp for teleport portal
vim.keymap.set("n", "<leader>ts", tmux.switch_tmux_session, { desc = "Tmux: Switch Session" }) -- ts for teleport switch
