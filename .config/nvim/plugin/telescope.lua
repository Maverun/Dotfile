--┌────────────────────────────────────────────────────────────────────────────┐
--│                                 Telescope                                  │
--└────────────────────────────────────────────────────────────────────────────┘
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
        ["project"] = "/home/maverun/dev",
        ["wiki"]    = "/ext_drive/SynologyDrive/NotesTaking"
      }
    }
  },
}

--require"telescope".load_extension("frecency")
