local iron = require("iron.core")

iron.setup {
  config = {
    -- If iron should expose `<plug>(...)` mappings for the plugins
    should_map_plug = false,
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        command = {"zsh"}
      }
    },
    repl_open_cmd = require('iron.view').curry.bottom(40),
    -- how the REPL window will be opened, the default is opening
    -- a float window of height 40 at the bottom.
  },
  -- Iron doesn't set keymaps by default anymore. Set them here
  -- or use `should_map_plug = true` and map from you vim files
  keymaps = {
    send_motion = "\\sc",
    visual_send = "\\ss",
    send_file = "\\sf",
    send_line = "\\sl",
    send_mark = "\\smm",
    mark_motion = "\\smc",
    mark_visual = "\\smc",
    remove_mark = "\\smd",
    cr = "\\s<cr>",
    interrupt = "\\s<space>",
    exit = "\\sq",
    clear = "\\cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  }
}
