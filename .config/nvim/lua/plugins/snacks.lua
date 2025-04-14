return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  ---@field input? snacks.input.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    lazygit = {enabled = true},
    git = {enabled = true},
    input = {enabled = true},
    notifier = {enabled = true, timeout=5000},
    picker = {enabled = true},
    },
  keys = {
    { '<leader>g', '', desc = "Git"},
    { '<leader>gg', function() Snacks.lazygit() end, desc = "Lazygit"},
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>f", desc = "Snacks Picker" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep Visual Selection or Word", mode = { "n", "x" } },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Files" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo" },
    { "<leader>fb", function() Snacks.picker.buffer() end, desc = "Buffer" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notifications" },
    { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>fC", function() Snacks.picker.commands_history() end, desc = "Commands History" },
    { "<leader>ft", function() Snacks.picker.treesitter() end, desc = "Treesitter" },
    { "<leader>fl", function() Snacks.picker.lines() end, desc = "Lines" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
  }

}
