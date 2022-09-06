
vim.cmd('runtime /ftplugin/textSetting.vim')

local q = require"vim.treesitter.query"
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
]]

local parse_query_save = function(language, query)
    local ok, parsed_query = pcall(vim.treesitter.parse_query, language, query)
    if not ok then
        return nil
    end
    return parsed_query
end

query_md = parse_query_save('markdown',the_query)

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
		    local start_row, start_column, end_row, _ =
			unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
		    local level = #q.get_node_text(node,0)
		    -- print(id,node,capture, q.get_node_text(node,bufnr),level,headlines[level], start_row,start_column,end_row)

		    if capture == "headline" then
			vim.api.nvim_buf_set_extmark(0,NAMESPACE,start_row,0,
			{
			    end_row = end_row + 1,
			    -- virt_text = {{"✿","function"}}, virt_text_pos = 'overlay'
			    hl_group = 'markdownH'..level,
			})
			vim.api.nvim_buf_set_extmark(0,NAMESPACE,start_row,0,
			{
			    end_col = level,
			    -- virt_text = {{"✿","function"}}, virt_text_pos = 'overlay'
			    conceal = headlines[level],
			    hl_group = 'markdownH'..level,
			})
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
	else
		target_row = -2
		target_end = -1
	end

	vim.api.nvim_buf_set_lines(0,target_row,target_end,false,{text})
	vim.api.nvim_win_set_cursor(0,{target_row + 1, 0})
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

local markdownHeadlineStar = vim.api.nvim_create_augroup('markdownHeadlineStar', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
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
