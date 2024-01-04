-- local iron = require("iron.core")

--
return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		iron.setup {
			config = {
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					sh = {
						-- Can be a table or a function that
						-- returns a table (see below)
						command = {"zsh"}
					}
				},
				-- How the repl window will be displayed
				-- See below for more information
				repl_open_cmd = require('iron.view').bottom(40),
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "\\ss",
				visual_send = "\\ss",
				send_file = "\\sf",
				send_line = "\\sl",
				send_until_cursor = "\\su",
				send_mark = "\\sm",
				mark_motion = "\\sc",
				mark_visual = "\\sc",
				remove_mark = "\\sd",
				cr = "\\s<cr>",
				interrupt = "\\s<space>",
				exit = "\\sq",
				clear = "\\sv",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			highlight = {
				italic = true
			},
			-- ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
		}
	end,
	keys = {
		{'\\sr',':vs<CR>:IronReplHere<CR>', desc="Iron Repl"}
	}
}
-- send_motion = "\\sc",
-- visual_send = "\\ss",
-- send_file = "\\sf",
-- send_line = "\\sl",
-- send_mark = "\\smm",
-- mark_motion = "\\smc",
-- mark_visual = "\\smc",
-- remove_mark = "\\smd",
-- cr = "\\s<cr>",
-- interrupt = "\\s<space>",
-- exit = "\\sq",
-- clear = "\\cl",
