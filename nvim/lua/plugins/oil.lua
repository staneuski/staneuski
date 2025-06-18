return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
  },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      mode = { "n" },
      desc = "Navigate to the parent path",
    },
  },
  -- },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
