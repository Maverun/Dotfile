
vim.cmd('runtime /ftplugin/textSetting.vim')

--┌────────────────────────────────────────────────────────────────────────────┐
--│                                Abbrivations                                │
--└────────────────────────────────────────────────────────────────────────────┘
vim.cmd([[
iabbr <buffer> h1 # 
iabbr <buffer> h2 ## 
iabbr <buffer> h3 ### 
iabbr <buffer> h4 #### 
iabbr <buffer> h5 ##### 
iabbr <buffer> h6 ###### 
]])

local q = require"vim.treesitter.query"
local tsutil = require'nvim-treesitter.ts_utils'
local ts = require'nvim-treesitter'

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
	local ok, parsed_query = pcall(vim.treesitter.parse_query, language, query)
	if not ok then
		return nil
	end
	return parsed_query
end

query_md = parse_query_save('markdown',the_query)

local function setExtmark(start_row,end_row,end_col,hl_group,conceal,start_col)
	start_col = start_col or 0
	vim.api.nvim_buf_set_extmark(0,NAMESPACE,start_row,0,
		{
			end_row = end_row + 1,
			-- virt_text = {{"✿","function"}}, virt_text_pos = 'overlay'
			hl_group = hl_group,
	})
	vim.api.nvim_buf_set_extmark(0,NAMESPACE,start_row,start_col,
		{
			end_col = end_col,
			-- virt_text = {{"✿","function"}}, virt_text_pos = 'overlay'
			conceal = conceal,
			hl_group = hl_group,
	})
end

function refresh()
	vim.api.nvim_buf_clear_namespace(0, NAMESPACE, 0, -1)
	local language_tree = vim.treesitter.get_parser(0, 'markdown')
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()
	-- headlines = { "◉", "✿", "○", "✸" }
	headlines = { "◉", "✿", "✦", "¤", "⚪", "✸" }
	for _, captures, metadata in query_md:iter_matches(root, 0) do
		for id, node in pairs(captures) do
			local capture = query_md.captures[id]
			-- print(capture, node)
			local start_row, start_column, end_row, _ =
			unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
			-- print(id,node,capture, q.get_node_text(node,0),start_row,start_column,end_row)
			if capture == "headline" then
				local level = #q.get_node_text(node,0)
				setExtmark(start_row,end_row,level,"markdownH"..level,headlines[level])

				
				-- print("heading..", q.get_node_text(node,0))
				headline_content_node = node:next_sibling()
				headline_content = q.get_node_text(headline_content_node,0)
				-- if q.get_node_text(headline_content,0):match("<DAILY>") then
				
				reset_daily = headline_content:match("DAILY")
				reset_weekly = headline_content:match("WEEKLY")
				if reset_daily or reset_weekly then
					current_time = os.time()
					previous_epoc = headline_content:match("%d+")
					-- confirm if it first time or not.
					if not headline_content:match("%d+") then
						print("is first timer")
						headline_content = string.format("%s%s - <%d>",string.rep("#",level),headline_content,os.time())
						vim.api.nvim_buf_set_lines(0, start_row,start_row+1,0,{headline_content})
					elseif reset_daily then
						print("right here, checking ")
						previous_time = os.date("%d",previous_epoc)
						reset_daily = previous_time ~= os.date("%d",current_time)

					elseif reset_weekly then
						previous_time = os.date("%V",previous_epoc)
						reset_weekly = previous_time ~= os.date("%V",current_time)
					end

					print(reset_daily,reset_weekly, "meaning")
					if reset_daily or reset_weekly then
						-- print("Nothing to reset!")
						-- break
					-- print('child:',q.get_node_text(child,0))
					-- grandpa yo
						section = node:parent():parent()

						-- section_start = headline_section:start()
						-- print(vim.inspect(section_start))
						lines = vim.api.nvim_buf_get_lines(0,section:start(),section:end_(),0)
						print(vim.inspect(lines))
						new_line = {}
						for __, line in pairs(lines) do
							if __ == 1 then
								str = string.gsub(line,"%d+",os.time())
							else
								str = string.gsub(line,"[x]"," ")
							end
							table.insert(new_line,str)
						end
						print(vim.inspect(new_line))
						vim.api.nvim_buf_set_lines(0,section:start(),section:end_(),0,new_line)
					end
				end
			elseif capture == "uncheckBox" then

				-- print(capture, q.get_node_text(node:next_sibling(),0),start_row,start_column)
				local level = "[ ]"
				-- setExtmark(start_row,end_row,start_column +#level,"markdownH6","",start_column)
				setExtmark(start_row,end_row,start_column + #level,"markdownH6","", start_column)
			elseif capture == "checkBox" then
				local level = "[x]"
				setExtmark(start_row,end_row, start_column + #level,"TSComment","", start_column)
			end

		end
	end
end

function find_all_headline()
	local language_tree = vim.treesitter.get_parser(0, 'markdown')
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local data = {}
	for _, captures, metadata in query_md:iter_matches(root, 0,0,0) do
		for id, node in pairs(captures) do
			local capture = query_md.captures[id]
			local start_row, start_column, end_row, _ =
			unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
			if capture == "headline" then
				hold = {start_row = start_row, end_row = end_row, level = #q.get_node_text(node,0),index = #data + 1}
				table.insert(data,hold)
			end
		end
	end
	return data
end

local function get_previous_headline(data)
	local data = data or find_all_headline()
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
end --get_previous_headline

function insert_headline(data,previous_heading,text)
	if previous_heading.index ~= #data then
		target_row = data[previous_heading.index + 1].start_row
		target_end = target_row
		cursor_target = target_row +1
	else
		target_row = -2
		target_end = -1
		cursor_target = vim.api.nvim_buf_line_count(0)
	end

	vim.api.nvim_buf_set_lines(0,target_row,target_end,false,{text})
	vim.api.nvim_win_set_cursor(0,{cursor_target, 0})
end

function add_neighbour_heading()
	local data = find_all_headline()
	previous_heading = get_previous_headline(data)
	text_ready = string.rep("#",previous_heading.level) .. " "
	insert_headline(data,previous_heading,text_ready)
end

-- if we are in H1, we want to create child header, then this is.
function add_inner_heading()
	local data = find_all_headline()
	previous_heading = get_previous_headline(data)
	text_ready = string.rep("#",previous_heading.level + 1) .. " "
	insert_headline(data,previous_heading,text_ready)
end

-- when you are inside say H2 (##) and you want to return to parent of header so H1 (#)
function add_outer_heading()
	local data = find_all_headline()
	previous_heading = get_previous_headline(data)
	-- Making sure we are not on H1, if we are on main heading which is only #, we need to subtract 0.
	insurance = - 1
	if previous_heading.level == 1 then
		insurance = 0
	end
	text_ready = string.rep("#",previous_heading.level + insurance) .. " "
	insert_headline(data,previous_heading,text_ready)
end

function toggleCheckBox()
	save_current_cursor = vim.api.nvim_win_get_cursor(0)
	-- the reason i do this instead of setting curosr at 0,0 is cuz of ts with "block_continuation" mess up, 
	-- but with '^' which go to first char of line...is ideal.
	vim.api.nvim_exec("normal ^",nil)
	node = tsutil.get_node_at_cursor(0)
	child = node:next_sibling()
	text = nil
	print(node:type(),node:child_count())
	if node:type() == "list_marker_minus" then
	if child:type() == "task_list_marker_unchecked" then
			-- text = "- [x] "
			text = "[x] "
		elseif child:type() == "task_list_marker_checked" then
			text = "[ ] "
		end
	end
	if text then
		-- text = text .. q.get_node_text(child:next_sibling(), 0)
		sr,sc,er,ec = child:range()
		vim.api.nvim_buf_set_text(0,sr,sc,er,ec,{text})
	end
	--restore to current cursor.
	vim.api.nvim_win_set_cursor(0,save_current_cursor)

end

local markdownHeadlineStar = vim.api.nvim_create_augroup('markdownHeadlineStar', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter','TextChanged','InsertLeave' }, {
	group = markdownHeadlineStar,
	desc = 'Show star conceal and highlight.',
	callback = function()
		refresh()
	end
})

-- vim.api.nvim_buf_set_keymap(0,'n','<leader>oh',[[:lua print(vim.inspect(find_headline()))]], {noremap = true})
vim.api.nvim_buf_set_keymap(0,'n','<leader>oh',[[:lua add_neighbour_heading()<CR>A]], {noremap = true, desc = "Add Neighbour Heading"})
vim.api.nvim_buf_set_keymap(0,'n','<leader>oih',[[:lua add_inner_heading()<CR>A]], {noremap = true, desc = "Add Inner Heading"})
vim.api.nvim_buf_set_keymap(0,'n','<leader>ooh',[[:lua add_outer_heading()<CR>A]], {noremap = true, desc = "Add Outer Heading"})
vim.api.nvim_buf_set_keymap(0,'n','<leader>c',[[:lua toggleCheckBox()<CR>]], {noremap = true, desc = "Toggle Checkbox"})
