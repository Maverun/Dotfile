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
        -- library = vim.api.nvim_get_runtime_file("", true),
        preloadFileSize = 150,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

local lsp_installer = require('nvim-lsp-installer')
lsp_installer.on_server_ready(function(server)
    local opts = {on_attach = on_attach}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end
    if server.name == 'sumneko_lua' then
        opts = lua_setting
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)


-- remove the lsp servers with their configs you don want
local vls_binary = '/usr/local/bin/vls'
require'lspconfig'.vls.setup {
  cmd = {vls_binary},
}

 local signs = {
    { name = "LspDiagnosticsSignError", text = "" },
    { name = "LspDiagnosticsSignWarning", text = "" },
    { name = "LspDiagnosticsSignHint", text = "" },
    { name = "LspDiagnosticsSignInformation", text = "" },
  }

  local sign_names = {
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
  }

  for i, sign in ipairs(signs) do
    vim.fn.sign_define(sign_names[i], { texthl = sign_names[i], text = sign.text, numhl = "" })
  end




