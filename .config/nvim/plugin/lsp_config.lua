local popup_border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

local navic = require('nvim-navic')
function on_attach(client, bufnr)
    local function map(l, r, o)
        local options = { noremap = true, silent = true }
        if o then options = vim.tbl_extend('force', options, o) end
        vim.api.nvim_buf_set_keymap(bufnr, 'n', l, r, o)
        if client['name'] == 'pylsp' then return end
        navic.attach(client,bufnr)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = popup_border })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = popup_border })
    -- Mappings.
    map("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { desc = 'Go to Declaration' })
    map("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { desc = 'Go to Definitions' })
    map("<space>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", { desc = 'Hover info' })
    map("<space>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = 'Implementation' })
    map("<space>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = 'Signature Help' })
    map("<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { desc = 'Add Workspace Folder' })
    map("<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { desc = 'Remove Workspace Folder' })
    map("<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { desc = 'List Workspace Folder' })
    map("<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { desc = 'Type Definitions' })
    map("<space>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = 'Rename' })
    map("gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = 'References' })
    map("<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = 'Show Line Diagnostics' })
    map("gN", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = 'Go to previous diagnostics' })
    map("gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = 'Go to next diagnostics' })
    map("<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = 'Diagnostics Loclists' })

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.formatting()<CR>", { desc = 'Formatting' })
    elseif client.server_capabilities.document_range_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", { desc = 'Formatting' })
    end
end

local function contain(t, s)
    for _, i in pairs(t) do
        if i == s then
            return true
        end
    end
    return false
end

-- workspace.checkThirdParty = false     ; to disable that thingy configure work environment?
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
                disable = { 'lowercase-global' },
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
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
local ltex_setting ={
    on_attach = on_attach,
    cmd = {'ltex-ls'},
    settings = {
            ltex = {
                    enabled = { "latex", "tex", "bib", "markdown","org" },
                    language = "en",
                    diagnosticSeverity = "information",
                    setenceCacheSize = 2000,
                    additionalRules = {
                            enablePickyRules = true,
                            motherTongue = "en",
                    },
                    trace = { server = "verbose" },
                    dictionary = {},
                    disabledRules = {},
                    hiddenFalsePositives = {},
            },
    },
}

local handlers = {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler
    function (server_name)
        if server_name == 'pylsp' then
            require('lspconfig')["pylsp"].setup{
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ingore = {'E501'},
                                -- maxLineLength = 100
                            }
                        }
                    }
                }
            }
        elseif server_name == 'yamlls' then
            lspconfig.yamlls.setup({
                settings = {
                    yaml = {
                        schemas = {
                            -- LINK (WORK ONLY) IN LIST
                            -- ["url"] = "/filename"
                        }
                    }
                }
            })
        else
        
            require("lspconfig")[server_name].setup {
                on_attach = on_attach
            }
        end
    end,
    -- next you can provided targeted overrides for specific servers
    ['lua_ls'] = function()
        lspconfig.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
    end,
}

-- require('lspconfig')['ltex'].setup{
--     on_attach = on_attach,
--     settigns = ltex_setting
-- }
--
require("mason").setup()
require("mason-lspconfig").setup({ handlers = handlers})


require("grammar-guard").init()
-- setup LSP config
require("lspconfig").grammar_guard.setup({
  cmd = { 'ltex-ls' }, -- add this if you install ltex-ls yourself
	settings = ltex_setting,
})

-- remove the lsp servers with their configs you don want
local vls_binary = '/usr/local/bin/vls'
require 'lspconfig'.vls.setup {
    cmd = { vls_binary },
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

