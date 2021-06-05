local U = require'snippets.utils'


local function test(x)
    print(x)
end

function make_table(csv)
  local str = "|"
  local headers_complete = false
  local headers = {}

  for cell in csv:gmatch('([^,]+)') do
    -- match and remove EOL char
    if cell:sub(-1) == '.' then
      cell = cell:sub(1, -2)
      headers_complete = true
    end

    -- capitalize each word
    cell = string.gsub(" "..cell, "%W%l", string.upper):sub(2)

    str = str .. string.format(" %s |", cell)
    headers[#headers+1] = cell:len()

    -- build the header separator
    if headers_complete then
      str = str .. '\n|'
      for i=1, #headers do
        str = str .. string.format(" %s |", string.rep('-', headers[i]))
      end
      str = str .. '\n|'
    end
  end
  return str
end

function string_headline(text)
    --local clen = string.len(U.force_comment(''))
    local clen = 3
    local top = '┌'..string.rep('─',78-clen)..'┐'
    local half = string.len(text) / 2
    print(half)
    local middle = (80 - clen) / 2
    local bottom = '└'..string.rep('─',78 - clen)..'┘'
    --local message = '│'..string.rep(" ",middle-1-half)..text..string.rep(" ",80-half)..'│'
    local left = '│'..string.rep(" ",middle-1-half)..text
    local message = left..string.rep(" ",80-string.len(left)-2)..'│'
    --local len = 80 - (2 * clen)
    return table.concat{
        top,
        '\n',
        message,
        '\n',
        bottom,
    }
end

local data = {
    -- Insert a basic snippet, which is a string.
    todo = U.force_comment "TODO(Maverun - ${=os.date()}): ";

    uname = function() return vim.loop.os_uname().sysname end;
    date = os.date();

    -- Evaluate at the time of the snippet expansion and insert it. You
    --  can put arbitrary lua functions inside of the =... block as a
    --  dynamic placeholder. In this case, for an anonymous variable
    --  which doesn't take user input and is evaluated at the start.
    --epoch = "${=os.time()}";
    -- Equivalent to above.
    epoch = function() return os.time() end;

    -- Use the expansion to read the username dynamically.
    --note = [[NOTE(${=io.popen("id -un"):read"*l"}): ]];

    -- Do the same as above, but by using $1, we can make it user input.
    -- That means that the user will be prompted at the field during expansion.
    -- You can *EITHER* specify an expression as a placeholder for a variable
    --  or a literal string/snippet using `${var:...}`, but not both.
    note = [[NOTE(${1=io.popen("id -un"):read"*l"}): ]];
    -- The final important note is the use of negative number variables.
    -- Negative variables *never* ask for user input, but otherwise behave
    --  like normal variables.
    -- This can be useful for storing the value of an expression, and repeating
    --  it in multiple locations.
    -- The following snippet will ask for the user's input using `input()` *once*,
    --  but use the value in multiple places.
    user_input = [[hey? ${-1=vim.fn.input("what's up? ")} = ${-1}]];

    copyright = U.force_comment [[Copyright (C) Maverun ${=os.date("%Y")}]];


    headline = U.force_comment [[${1|string_headline(S.v)}]];
    info_owner = U.force_comment [[
        ${=os.date()}
        Author: ${1:Maverun}
    ]];
    tbl = [[${1|make_table(S.v)}]];
}

return data

