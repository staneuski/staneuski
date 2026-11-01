-- FoamFile
vim.api.nvim_create_autocmd("FileType", {
  pattern = "foam",
  callback = function(args)
    vim.bo[args.buf].commentstring = "// %s"
  end,
})

return {
  -- https://lazyvim.org/plugins/treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cpp", "foam" },
    },
  },
}
