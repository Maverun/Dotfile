-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    LSP                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

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

function on_attach(client, bufnr)
    navic = require'nvim-navic'
    navic.attach(client,bufnr)
    local function map(l, r, o)
        local options = { noremap = true, silent = true, buffer = bufnr}
        if o then options = vim.tbl_extend('force', options, o) end
        vim.keymap.set('n', l, r, o)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = popup_border })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = popup_border })
    -- Mappings.
    map("gD", vim.lsp.buf.declaration, { desc = 'Go to Declaration' })
    map("gd", vim.lsp.buf.definition, { desc = 'Go to Definitions' })
    map("<space>k", vim.lsp.buf.hover, { desc = 'Hover info' })
    map("<space>i", vim.lsp.buf.implementation, { desc = 'Implementation' })
    map("<space>s", vim.lsp.buf.signature_help, { desc = 'Signature Help' })
    map("<space>wa", vim.lsp.buf.add_workspace_folder, { desc = 'Add Workspace Folder' })
    map("<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = 'Remove Workspace Folder' })
    map("<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = 'List Workspace Folder' })
    map("<space>D", vim.lsp.buf.type_definition, { desc = 'Type Definitions' })
    map("<space>r", vim.lsp.buf.rename, { desc = 'Rename' })
    map("gr", vim.lsp.buf.references, { desc = 'References' })
    map("<space>e", vim.diagnostic.open_float, { desc = 'Show Line Diagnostics' })
    map("gN", vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostics' })
    map("gn", vim.diagnostic.goto_next, { desc = 'Go to next diagnostics' })
    map("<space>q", vim.diagnostic.setloclist, { desc = 'Diagnostics Loclists' })
    map("<space>b", function() vim.lsp.buf.format({async = true}) end, { desc = 'Diagnostics Loclists' })

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.formatting()<CR>", { desc = 'Formatting' })
    elseif client.server_capabilities.document_range_formatting then
        map("<space>p", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", { desc = 'Formatting' })
    end
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



return {
    {'SmiteshP/nvim-navic'},
    {"williamboman/mason.nvim", opts={}},
    "williamboman/mason-lspconfig.nvim",
    {'neovim/nvim-lspconfig',
    dependencies = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'brymer-meneses/grammar-guard.nvim',
        'onsails/lspkind-nvim',
    },
    config = function()


        local handlers = {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler
            function (server_name) -- default handler (optional)
                local lspconfig = require('lspconfig')
                if server_name == "pylsp" then
                    require("lspconfig")["pylsp"].setup{
                        on_attach = on_attach,
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = {
                                        ignore = {'E501'}
                                        -- maxLineLength = 100
                                    }
                                }
                            }
                        }
                    }
                elseif server_name == "yamlls" then
                    lspconfig.yamlls.setup({
                        on_attach = on_attach,
                        setting = {
                            yaml = {
                                schemas = {
                                    -- PRIVATE DUE TO WORK...
                                    -- ["URL"] = "/Filename"
                                }
                            }
                        }
                    })
                else
                    require("lspconfig")[server_name].setup{
                        on_attach = on_attach
                    }
                end
            end,

            ["lua_ls"] = function()
                local lspconfig = require('lspconfig')
                lspconfig.lua_ls.setup(lua_setting)
            end,
        } -- End of Handlers

        require("mason-lspconfig").setup({ handlers = handlers})



        -- require('lspconfig')['ltex'].setup{
        --     on_attach = on_attach,
        --     settings = ltex_setting
        -- }
        --
        -- require("grammar-guard").init()
        -- -- setup LSP config
        -- require("lspconfig").grammar_guard.setup({
        --   cmd = { 'ltex-ls' }, -- add this if you install ltex-ls yourself
        --         settings = ltex_setting,
        -- })

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

end
}
}
