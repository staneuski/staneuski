-- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#options
local preview = { preview = { vertical = true } }

return {
  "stevearc/oil.nvim",
  priority = 1000,
  lazy = false,

  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        local m = name:match("^..$")
        return m ~= nil
      end,
    },
    float = {
      max_width = 0.8,
      max_height = 0.8,
      border = "rounded",
    },
    confirmation = { border = "rounded" },
    progress = { border = "rounded" },
  },
  keys = {
    {
      "-",
      function()
        require("oil").open_float(nil, preview)
      end,
      mode = { "n" },
      desc = "Open oil (Directory of the Current File)",
    },
    {
      "<leader>fo",
      function()
        require("oil").open_float(nil, preview)
      end,
      desc = "Open oil (Directory of the Current File)",
    },
    {
      "<leader>fO",
      function()
        require("oil").open_float(LazyVim.root(), preview)
      end,
      desc = "Open oil (root dir)",
    },
  },
}
