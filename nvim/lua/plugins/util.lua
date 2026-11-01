-- https://github.com/LazyVim/starter/blob/main/lua/plugins/example.lua
local oil_preview = { preview = { vertical = true } }
return {
  -- https://lazyvim.org/plugins/util
  {
    "folke/snacks.nvim",
    opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#explorer
      picker = {
        sources = {
          explorer = { hidden = true },
          files = { hidden = true },
        },
      },
      -- https://github.com/folke/snacks.nvim/issues/982
      explorer = { trash = false },
    },
  },

  -- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#options
  {
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
          require("oil").open()
        end,
        mode = { "n" },
        desc = "Open oil (Directory of the Current File)",
      },
      {
        "<leader>fo",
        function()
          require("oil").open_float(nil, oil_preview)
        end,
        desc = "Open oil (Directory of the Current File)",
      },
      {
        "<leader>fO",
        function()
          require("oil").open_float(LazyVim.root(), oil_preview)
        end,
        desc = "Open oil (root dir)",
      },
    },
  },
}
