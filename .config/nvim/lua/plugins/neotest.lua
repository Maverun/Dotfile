return {
  {"nvim-neotest/neotest",
    opts = {
      quickfix = {open=false},
      adapters = {
        require("neotest-python")({
          pytest_discovery = true
        })
      }
    },
    keys = {
        { '\\nr', ':lua require"neotest".run.run()<CR>', desc = "Run nearest test" },
        { '\\nw', ':lua require"neotest".run.run(vim.fn.expand("%"))<CR>', desc = "Run whole test file" },
        { '\\no', ':lua require"neotest".output_panel.toggle()<CR>', desc = "Toggle the output" },
        { '\\ns', ':lua require"neotest".summary.toggle()<CR>', desc = "Toggle the Summary" },
    }
  }
}
