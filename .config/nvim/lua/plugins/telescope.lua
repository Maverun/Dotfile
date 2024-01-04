--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 Telescope                                  │
--└────────────────────────────────────────────────────────────────────────────┘
return {
    'nvim-telescope/telescope.nvim',
    config = function()
        require'telescope'.setup {
            defaults = {
                layout_strategy = 'flex',
                layout_config = {
                    flex = {
                        flip_columns = 150
                    },
                    vertical = {
                        mirror = true
                    }
                },
            },
          extensions = {
            frecency = {
              show_scores = true,
              show_unindexed = true,
              ignore_patterns = {"*.git/*", "*/tmp/*"},
              disable_devicons = false,
              workspaces = {
                ["conf"]    = "/home/maverun/.config",
                ["nvim"]    = "/home/maverun/.config/nvim",
                ["project"] = "/home/maverun/dev",
                ["wiki"]    = "/ext_drive/SynologyDrive/NotesTaking"
              }
            }
          },
        }
    end,
   dependencies = {
    "crispgm/telescope-heading.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "tami5/sql.nvim",
    "crispgm/telescope-heading.nvim",
   },

   keys = {
       {'<leader>ff',':Telescope find_files<CR>', desc = 'Find Files'},
       {'<leader>fof',':lua require("telescope.builtin").find_files({search_dirs={"~/Drive/NotesTaking/"}})<CR>', desc = 'NotesTaking Files'},
       {'<leader>fO',':Telescope oldfiles<CR>', desc = 'Old Files'},
       {'<leader>fg',':Telescope live_grep<CR>', desc = 'Live Grep'},
       {'<leader>fb',':Telescope buffers<CR>', desc = 'Buffers'},
       {'<leader>fh',':Telescope help_tags<CR>', desc = 'Help Tags'},
       {'<leader>fk',':Telescope keymaps<CR>', desc = 'Keymaps'},
       {'<leader>fm',':Telescope marks<CR>', desc = 'Marks'},
       {'<leader>fr','<Cmd>lua require("telescope").extensions.frecency.frecency()<CR>', desc = 'Frecency'},
       {'<leader>foh','<Cmd>lua require("telescope").extensions.heading.heading()<CR>', desc = 'Heading List'}
   }


}
