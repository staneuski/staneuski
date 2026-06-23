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
      -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#explorer
      picker = {
        sources = {
          explorer = { hidden = true },
          files = { hidden = true },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cpp",
        "foam",
      })
    end,
  },
}
