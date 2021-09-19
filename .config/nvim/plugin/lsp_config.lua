local popup_border = {
    {"╭", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╮", "FloatBorder"},
    {"│", "FloatBorder"},
    {"╯", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╰", "FloatBorder"},
    {"│", "FloatBorder"},
}


function on_attach(client,bufnr)
    local function map(...)
        vim.api.nvim_buf_set_keymap(bufnr,'n',...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = popup_border})
    vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = popup_border})
    -- Mappings.
    local opts = {noremap = true, silent = true}
    map("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    map("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map("<space>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    map("<space>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    map("<space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    map("<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    map("<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    map("<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    map("<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    map("<space>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    map("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    map("<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    map("gN", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    map("gn", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    map("<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local function contain(t,s)
    for _,i in pairs(t) do
        if i == s then
            return true
        end
    end
    return false
end

local lua_setting = {
  --cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        --path = runtime_path,
      },
      diagnostics = {
          disable = {'lowercase-global'},
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        preloadFileSize = 150,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

--local lspconfig = require'lspconfig'
--local lspinstall = require'lspinstall'

local function setup_servers()
    local ignoreServers = {}
    require'lspinstall'.setup()
    local lspconfig = require'lspconfig'
    local servers = require'lspinstall'.installed_servers()
    for _, server in pairs(servers) do
        if server == 'lua' then
            lspconfig[server].setup(lua_setting)
        elseif contain(ignoreServers,server) == false then
            lspconfig[server].setup{on_attach = on_attach}
            --lspconfig[server].setup{on_attach = on_attach}
        end
    end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


--for k, lang in pairs(servers) do
    --lspconf[lang].setup {
        --root_dir = vim.loop.cwd
    --}
--end

-- remove the lsp servers with their configs you don want
local vls_binary = '/usr/local/bin/vls'
require'lspconfig'.vls.setup {
  cmd = {vls_binary},
}

-- lua lsp settings
--local system_name
--if vim.fn.has("mac") == 1 then
  --system_name = "macOS"
--elseif vim.fn.has("unix") == 1 then
  --system_name = "Linux"
--elseif vim.fn.has('win32') == 1 then
  --system_name = "Windows"
--else
  --print("Unsupported system for sumneko")
--end

---- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
----local sumneko_root_path ='~/langservers/lua-language-server'
----local sumneko_binary = sumneko_root_path .. '/bin/'..system_name .. '/lua-language-server'
--local sumneko_root_path = vim.fn.expand(vim.fn.expand('~/langservers/lua-language-server'))
--local sumneko_binary = sumneko_root_path .. '/bin/'..system_name..'/lua-language-server'

--local runtime_path = vim.split(package.path, ';')
--table.insert(runtime_path, "lua/?.lua")
--table.insert(runtime_path, "lua/?/init.lua")

--require'lspconfig'.sumneko_lua.setup {
-- replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

-- diagnostics highlights

--local cmd = vim.cmd

--cmd "hi LspDiagnosticsSignError guifg=#f9929b"
--cmd "hi LspDiagnosticsVirtualTextError guifg=#BF616A"

--cmd "hi LspDiagnosticsSignWarning guifg=#EBCB8B"
--cmd "hi LspDiagnosticsVirtualTextWarning guifg=#EBCB8B"

--cmd "hi LspDiagnosticsSignInformation guifg=#A3BE8C"
--cmd "hi LspDiagnosticsVirtualTextInformation guifg=#A3BE8C"

--cmd "hi LspDiagnosticsSignHint guifg=#b6bdca"
--cmd "hi LspDiagnosticsVirtualTextHint guifg=#b6bdca"
