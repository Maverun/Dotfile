-- LUA language Server
---@type vim.lsp.Config
return {
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    autoFixOnSave = true,
    Lua = {
      diagnostics = {
          disable = { 'lowercase-global' },
          globals = { 'vim', 'Snacks', 'au', 'ag', 'command', 'describe', 'it', 'before_each', 'after_each' },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
          quote_style = 'single',
          align_call_args = true,
          align_function_define_params = true,
          continuous_assign_statement_align_to_equal_sign = true,
        },
      },
      completion = {
        autoRequire = false,
        callSnippet = 'Replace',
      },
      hint = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        library = {
          '/usr/share/nvim/runtime/lua',
          '${3rd}/luv/library'
        },
      }
    },
  },
}
