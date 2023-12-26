return {
  {"nvim-neotest/neotest",
    opts = {
      quickfix = {open=false},
      adapters = {
        require("neotest-python")({
          pytest_discovery = true
        })
      }
    }
  }
}
