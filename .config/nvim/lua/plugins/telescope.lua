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
    "p00f/nvim-ts-rainbow",
    "crispgm/telescope-heading.nvim",
   }
}
