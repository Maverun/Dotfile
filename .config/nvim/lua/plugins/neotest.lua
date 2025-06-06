return {
  {"nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
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
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = {"--log-level", "DEBUG"},
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            -- python = ".venv/bin/python",
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            --   ...
            -- end,
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = true,
          })
        }
      }
    end,
    keys = {
        { '\\n', '', desc = "Neotest" },
        { '\\nr', ':lua require"neotest".run.run()<CR>', desc = "Run nearest test" },
        { '\\nw', ':lua require"neotest".run.run(vim.fn.expand("%"))<CR>', desc = "Run whole test file" },
        { '\\no', ':lua require"neotest".output_panel.toggle()<CR>', desc = "Toggle the output" },
        { '\\ns', ':lua require"neotest".summary.toggle()<CR>', desc = "Toggle the Summary" },
    }
  }
}
