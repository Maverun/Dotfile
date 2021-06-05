vim.o.completeopt = "menuone,noselect"

require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        path = true,
        buffer = {kind = "﬘" , true},
        calc = true,
        --vsnip = {kind = "﬌"}, --replace to what sign you prefer
        snippets_nvim = {kind = "﬌"}, --replace to what sign you prefer
        ultisnips = true,
        nvim_lsp = true,
        nvim_lua = true,
        spell = true,
        tags = true,
        --snippets_nvim = true,
        treesitter = true
    }
}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end


snip = require("snippets")
-- tab completion
-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
  elseif snip.has_active_snippet() then
    return t "<C-k>"
  elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

--Shift tab
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif snip.has_active_snippet() then
    return t "<C-j>"
  elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true)
  --elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    --return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    --return t "<S-Tab>"
    return t "<C-h>"
  end
end

--  mappings

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

function _G.completions()
    local npairs = require("nvim-autopairs")
    local _, expanded = snip.lookup_snippet_at_cursor()
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]('<CR>')
        end
    elseif expanded ~= nil then
        snip.expand_at_cursor()
        return
    end
    return npairs.check_break_line_char()
end



vim.api.nvim_set_keymap("i", "<CR>", "v:lua.completions()", {expr = true})
vim.api.nvim_set_keymap("i", "<F3>", "v:lua.teap()", {expr = true})
--vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true})


--print(snip.snippets['_global'])
--for key, value in pairs(snip.snippets['_global']) do
    --print(key, '---',value)
--end


