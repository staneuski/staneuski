-- https://github.com/LazyVim/starter/blob/main/lua/plugins/example.lua
return {
  {
    "catppuccin",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
      dashboard = { preset = { header = "" } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cpp",
        "foam",
      })
    end,
  },
}
