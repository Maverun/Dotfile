-- ┌───────────────────────────────────────────────────────────────────────────┐
-- │                                    DAP                                    │
-- └───────────────────────────────────────────────────────────────────────────┘

vim.api.nvim_create_augroup('dapCustom',{clear = true})
vim.api.nvim_create_autocmd('FileType',{
    group = 'dapCustom',
    pattern = 'dap-repl',
    callback = function()
        vim.api.nvim_buf_set_keymap(0,'n','n',":lua require('dap').step_over()<CR>",{noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(0,'n','s',":lua require('dap').step_into()<CR>",{noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(0,'n','c',":lua require('dap').continue()<CR>",{noremap = true, silent = true})
    end,
    desc = "During Dap repl mode, we can just press key to do instead of command",
})


return {

  {'theHamsta/nvim-dap-virtual-text',
    ft = "dap-repl",
  },
  {'rcarriga/nvim-dap-ui',
    ft = "dap-repl",
    dependencies = {'mfussenegger/nvim-dap'},
    opts = {
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
        },
        layouts = {
          -- You can change the order of elements in the sidebar
          {
          elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
              id = "scopes",
              size = 0.25, -- Can be float or integer > 1
            },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 00.25 },
          },
          size = 50,
          position = "right", -- Can be "left" or "right"
          },
        {
          elements = { "repl" },
          size = 10,
          position = "bottom", -- Can be "bottom" or "top"
        }},
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 }
      }
  },

  {'mfussenegger/nvim-dap',
    event = 'InsertEnter',
    config = function()
      -- vim.g.dap_virtual_text=true --showing virtual text during debugging
      -- require'nvim-dap-virtual-text'.setup()
      dap = require('dap')
      dapui = require('dapui')
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.after.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.after.event_exited['dapui_config'] = function() dapui.close() end


      dap.adapters.python = {
        type = 'executable';
        -- command = '/home/maverun/dev/venvdebugpy/bin/python';
        command = '/usr/bin/python';
        args = { '-m', 'debugpy.adapter' };
      }


      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch';
          name = "Launch file";

          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

          program = "${file}"; -- This configuration will launch the current file if used.
          pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end;
        },
      }


      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb'
      }

      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},

          -- 💀
          -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
          --
          --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
          --
          -- Otherwise you might get the following error:
          --
          --    Error on launch: Failed to attach to the target process
          --
          -- But you should be aware of the implications:
          -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
          -- runInTerminal = false,
        },
      }

      -- If you want to use this for Rust and C, add something like this:

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

    end,
    keys = {
      {'\\dc',':lua require"dap".continue()<CR>',desc = 'Continue'},
      {'\\do',':lua require"dap".step_over()<CR>',desc = "Step Over"},
      {'\\dj',':lua require"dap".step_into()<CR>',desc = "Step Into"},
      {'\\dl',':lua require"dap".step_out()<CR>',desc = "Step Out"},
      {'\\db',':lua require"dap".toggle_breakpoint()<CR>',desc = "Toggle Breakpoint"},
      {'\\dsc',':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<CR>',desc = "Breakpoint Conditions"},
      {'\\dsl',':lua require"dap".set_breakpoint(nil,nil,vim.fn.input("Log point Message: "))<CR>',desc = "Log Point MSG"},
      {'\\dr',':lua require"dap".repl.open()<CR>',desc = "Repl Open"},
      {'\\de',':lua require"dap".run_last()<CR>',desc = "Run Last"},
    }

}
}


