require'snippets'.snippets = {
  -- The _global dictionary acts as a global fallback.
  -- If a key is not found for the specific filetype, then
  --  it will be lookup up in the _global dictionary.
  _global = require('../snippet/global');
  lua = require('../snippet/lua');
  c = require('../snippet/c');
}

-- And now for some examples of snippets I actually use.
--local snippets = require'snippets'
--local U = require'snippets.utils'
--snippets.snippets = {
  --lua = {
    --req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']];
    --func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
    --["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
    ---- Match the indentation of the current line for newlines.
    --["for"] = U.match_indentation [[
--for ${1:i}, ${2:v} in ipairs(${3:t}) do
  --$0
--end]];
  --};
  --_global = {
    ---- If you aren't inside of a comment, make the line a comment.
    --copyright = U.force_comment [[Copyright (C) Maverun ${=os.date("%Y")}]];
  --};
--}
