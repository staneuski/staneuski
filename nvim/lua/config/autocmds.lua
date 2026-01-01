-- https://github.com/LazyVim/starter/blob/main/lua/config/autocmds.lua

-- EasyBuild
vim.api.nvim_create_autocmd("FileType", {
  pattern = "conf",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("%.eb$") then
      vim.bo[args.buf].syntax = "python"
    end
  end,
})

-- FoamFile
vim.api.nvim_create_autocmd("FileType", {
  pattern = "foam",
  callback = function(args)
    vim.bo[args.buf].syntax = "cpp"
    vim.bo[args.buf].commentstring = "// %s"
  end,
})
