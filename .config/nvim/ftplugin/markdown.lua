
vim.cmd('runtime /ftplugin/textSetting.vim')

local q = require"vim.treesitter"
local tsutil = require'nvim-treesitter.ts_utils'

local NAMESPACE = vim.api.nvim_create_namespace("headline_star")

local the_query = [[
		(atx_heading [
		    (atx_h1_marker)
		    (atx_h2_marker)
		    (atx_h3_marker)
		    (atx_h4_marker)
		    (atx_h5_marker)
		    (atx_h6_marker)
		] @headline)
		(thematic_break) @dash
		(fenced_code_block) @codeblock
		(block_quote_marker) @quote
		(block_quote (paragraph (inline (block_continuation) @quote)))
		(task_list_marker_unchecked) @uncheckBox
		(task_list_marker_checked) @checkBox
]]

local parse_query_save = function(language, query)
	local ok, parsed_query = pcall(vim.treesitter.query.parse, language, query)
	if not ok then
		return nil
	end
	return parsed_query
end

local query_md = parse_query_save('markdown', the_query)

local function setExtmark(start_row, end_row, end_col, hl_group, conceal, start_col)
	start_col = start_col or 0
	vim.api.nvim_buf_set_extmark(0, NAMESPACE, start_row, 0, {
		end_row = end_row + 1,
		hl_group = hl_group,
	})
	vim.api.nvim_buf_set_extmark(0, NAMESPACE, start_row, start_col, {
		end_col = end_col,
		conceal = conceal,
		hl_group = hl_group,
	})
end

local function refresh()
	vim.api.nvim_buf_clear_namespace(0, NAMESPACE, 0, -1)
	local language_tree = vim.treesitter.get_parser(0, 'markdown')
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()
	local headlines = { "◉", "✿", "✦", "¤", "⚪", "✸" }
	for _, captures, metadata in query_md:iter_matches(root, 0) do
		for id, node in pairs(captures) do
			local capture = query_md.captures[id]
			local start_row, start_column, end_row, _ =
			unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
			if capture == "headline" then
				local level = #q.get_node_text(node, 0)
				setExtmark(start_row, end_row, level, "markdownH" .. level, headlines[level])

				local headline_content_node = node:next_sibling()
				local headline_content = q.get_node_text(headline_content_node, 0)

				local reset_daily = headline_content:match("DAILY")
				local reset_weekly = headline_content:match("WEEKLY")
				if reset_daily or reset_weekly then
					local current_time = os.time()
					local previous_epoc = headline_content:match("%d+")
					if not headline_content:match("%d+") then
						headline_content = string.format("%s%s - <%d>", string.rep("#", level), headline_content, os.time())
						vim.api.nvim_buf_set_lines(0, start_row, start_row + 1, 0, { headline_content })
					elseif reset_daily then
						local previous_time = os.date("%d", previous_epoc)
						reset_daily = previous_time ~= os.date("%d", current_time)
					elseif reset_weekly then
						local previous_time = os.date("%V", previous_epoc)
						reset_weekly = previous_time ~= os.date("%V", current_time)
					end

					if reset_daily or reset_weekly then
						local section = node:parent():parent()
						local lines = vim.api.nvim_buf_get_lines(0, section:start(), section:end_(), 0)
						local new_line = {}
						for i, line in pairs(lines) do
							local str
							if i == 1 then
								str = string.gsub(line, "%d+", os.time())
							else
								str = string.gsub(line, "[x]", " ")
							end
							table.insert(new_line, str)
						end
						vim.api.nvim_buf_set_lines(0, section:start(), section:end_(), 0, new_line)
					end
				end
			elseif capture == "uncheckBox" then
				local level = "[ ]"
				setExtmark(start_row, end_row, start_column + #level, "markdownH6", "", start_column)
			elseif capture == "checkBox" then
				local level = "[x]"
				setExtmark(start_row, end_row, start_column + #level, "TSComment", "󰱒", start_column)
			end
		end
	end
end

local function find_all_headline()
	local language_tree = vim.treesitter.get_parser(0, 'markdown')
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()
	local data = {}
	for _, captures, metadata in query_md:iter_matches(root, 0, 0, 0) do
		for id, node in pairs(captures) do
			local capture = query_md.captures[id]
			local start_row, start_column, end_row, _ =
			unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
			if capture == "headline" then
				local hold = { start_row = start_row, end_row = end_row, level = #q.get_node_text(node, 0), index = #data + 1 }
				table.insert(data, hold)
			end
		end
	end
	return data
end

local function get_previous_headline(data)
	data = data or find_all_headline()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local previous = data[1]
	for i = 1, #data do
		if data[i].start_row > current_pos[1] then
			return previous
		else
			previous = data[i]
		end
	end
	return previous
end

local function insert_headline(data, previous_heading, text)
	local target_row, target_end, cursor_target
	if previous_heading.index ~= #data then
		target_row = data[previous_heading.index + 1].start_row
		target_end = target_row
		cursor_target = target_row + 1
	else
		target_row = -2
		target_end = -1
		cursor_target = vim.api.nvim_buf_line_count(0)
	end
	vim.api.nvim_buf_set_lines(0, target_row, target_end, false, { text })
	vim.api.nvim_win_set_cursor(0, { cursor_target, 0 })
end

local function add_neighbour_heading()
	local data = find_all_headline()
	local previous_heading = get_previous_headline(data)
	local text_ready = string.rep("#", previous_heading.level) .. " "
	insert_headline(data, previous_heading, text_ready)
end

local function add_inner_heading()
	local data = find_all_headline()
	local previous_heading = get_previous_headline(data)
	local text_ready = string.rep("#", previous_heading.level + 1) .. " "
	insert_headline(data, previous_heading, text_ready)
end

local function add_outer_heading()
	local data = find_all_headline()
	local previous_heading = get_previous_headline(data)
	local insurance = previous_heading.level == 1 and 0 or -1
	local text_ready = string.rep("#", previous_heading.level + insurance) .. " "
	insert_headline(data, previous_heading, text_ready)
end

local function toggleCheckBox()
	local save_current_cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_exec("normal ^", nil)
	local node = tsutil.get_node_at_cursor(0)
	local child = node:next_sibling()
	local text = nil
	if node:type() == "list_marker_minus" then
		if child:type() == "task_list_marker_unchecked" then
			text = "[x]"
		elseif child:type() == "task_list_marker_checked" then
			text = "[ ]"
		end
	end
	if text then
		local sr, sc, er, ec = child:range()
		vim.api.nvim_buf_set_text(0, sr, sc, er, ec, { text })
	end
	vim.api.nvim_win_set_cursor(0, save_current_cursor)
end

vim.keymap.set('n', '<leader>nhn', function() add_neighbour_heading() vim.cmd('normal! A') end, { buffer = true, noremap = true, desc = "Add Neighbour Heading" })
vim.keymap.set('n', '<leader>nhi', function() add_inner_heading() vim.cmd('normal! A') end,     { buffer = true, noremap = true, desc = "Add Inner Heading" })
vim.keymap.set('n', '<leader>nho', function() add_outer_heading() vim.cmd('normal! A') end,     { buffer = true, noremap = true, desc = "Add Outer Heading" })
vim.keymap.set('n', '<leader>c',   toggleCheckBox,                                               { buffer = true, noremap = true, desc = "Toggle Checkbox" })

vim.cmd[[
" Setting Abbreviations
iabbrev <buffer> h1 #
iabbrev <buffer> h2 ##
iabbrev <buffer> h3 ###
iabbrev <buffer> h4 ####
iabbrev <buffer> h5 #####
iabbrev <buffer> h6 ######
]]

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.bo.expandtab = true
