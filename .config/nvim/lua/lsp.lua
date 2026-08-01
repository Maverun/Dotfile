-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    LSP                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.lsp.enable({
  "lua",
  "python",
  -- "basedpyright",
  "ruff",
  "yaml",
  "bash",
  "json",
  "markdown",
})

vim.lsp.config("*", {
  on_attach = function(client, buffer)
    if client and client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    vim.keymap.set("n", "grq", vim.diagnostic.setloclist, { desc = "Diagnostic QuickList" })
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "Declaration" })
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, { desc = "Definition" })
    if client:supports_method("textDocument/formatting") then
      vim.keymap.set("n", "grf", vim.lsp.buf.format, { buffer = buffer, desc = "Formatting whole files" })
    end
  end,
})

-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                Diagnostics                                │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
})
