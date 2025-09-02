return {
  "stevearc/oil.nvim",
  priority = 1000,
  lazy = false,

  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
            local m = name:match("^..$")
            return m ~= nil
        end,
    },
  },
  keys = {
    {
      "-",
      function() require("oil").open() end,
      mode = { "n" },
      desc = "Navigate to the parent path",
    },
    {
      "<leader>fo",
      function() require("oil").open() end,
      desc = "Open oil (Directory of Current File)",
    },
    {
      "<leader>fO",
      function() require("oil").open(vim.uv.cwd()) end,
      desc = "Open oil (cwd)",
    },
  },
}
