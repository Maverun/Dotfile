--┌────────────────────────────────────────────────────────────────────────────┐
--│                                  Ordmode                                   │
--└────────────────────────────────────────────────────────────────────────────┘

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
	install_info = {
		url = 'https://github.com/milisims/tree-sitter-org',
		revision = 'main',
		files = {'src/parser.c', 'src/scanner.cc'},
	},
	filetype = 'org',
}


require('orgmode').setup({
	org_hide_emphasis_markers = true,
	org_agenda_files = {'~/Drive/orgmode/*'},
	org_default_notes_file = '~/Drive/orgmode/refile.org',
	org_agenda_templates = {
		f = {
			description = "File notes",
			template = "* %?\n  %u\n  %a",
			target = "~/Drive/orgmode/notes.org",
		},
		t = {
			description = "TODO File notes",
			template = "* TODO %?\n  %u\n  %a",
			target = "~/Drive/orgmode/notes.org",
		},
		T = {
			description = "Temp notes(Will be Delete)",
			template = "",
			target = "/tmp/notes.org",
		},
	},
	org_todo_keywords = { "TODO(t)", "|", "DONE", "CANCELED" },
	org_todo_keyword_faces = {
		TODO = ":foreground " .. '#9d7cd8' .. " :weight bold",
		DONE = ":foreground " .. '#9ece6a' .. " :weight bold",
		CANCELED = ":foreground " .. '#f7768e' .. " :weight bold",
	},

})

require('orgmode').setup_ts_grammar()
