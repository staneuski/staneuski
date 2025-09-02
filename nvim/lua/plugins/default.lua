-- https://github.com/LazyVim/starter/blob/main/lua/plugins/example.lua
return {
  --[[
  {
    "folke/snacks.nvim",
    opts = {
      hidden = true,
    },
  },
  {
    "nvim-mini/mini.files",
    keys = {
      {
        "-",
        function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
      },
    },
  },
  ]]--
}
