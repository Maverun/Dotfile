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
					},
					-- python = {
					-- 	command = "source ~/venv/bin/activate && ipython",
					-- 	type = "bracketed"
					-- }
				},
				-- How the repl window will be displayed
				-- See below for more information
				repl_open_cmd = require('iron.view').bottom(40),
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "\\is",
				visual_send = "\\is",
				send_file = "\\if",
				send_line = "\\il",
				send_until_cursor = "\\iu",
				send_mark = "\\im",
				mark_motion = "\\ic",
				mark_visual = "\\ic",
				remove_mark = "\\id",
				cr = "\\i<cr>",
				interrupt = "\\i<space>",
				exit = "\\iq",
				clear = "\\iv",
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
		{'\\i','', desc="Iron"},
		{'\\ir',':vs<CR>:IronReplHere<CR>', desc="Iron Repl"}
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
