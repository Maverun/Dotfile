return {
  {"nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    },
    config = function()
      require('neotest').setup{
        quickfix = {open=false},
        adapters = {
          require("neotest-python")({
            pytest_discovery = true,
            dap = { justMyCode = false },
            args = {"--log-level", "DEBUG"},
            runner = "pytest",
            python = function()
              local cwd = vim.fn.getcwd()
              for _, venv in ipairs({ cwd .. "/venv", cwd .. "/.venv" }) do
                local python = venv .. "/bin/python"
                if vim.fn.executable(python) == 1 then
                  return python
                end
              end
              return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end,
            pytest_discover_instances = true,
          })
        }
      }
    end,
    keys = {
        { '\\n', '', desc = "Neotest" },
        { '\\nr', function() require("neotest").run.run() end,                    desc = "Run nearest test" },
        { '\\nw', function() require("neotest").run.run(vim.fn.expand("%")) end,  desc = "Run whole test file" },
        { '\\no', function() require("neotest").output_panel.toggle() end,        desc = "Toggle the output" },
        { '\\ns', function() require("neotest").summary.toggle() end,             desc = "Toggle the Summary" },
        { '\\nt', function() require("neotest").watch.watch() end,                desc = "Watching file" },
    }
  }
}
