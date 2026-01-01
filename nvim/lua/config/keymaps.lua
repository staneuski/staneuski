-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.set("n", "<leader>bw", "<cmd>update<cr>", { desc = "Write Buffer" })
vim.keymap.set("n", "<leader>bW", function()
  vim.cmd.update()
  Snacks.bufdelete()
end, { desc = "Write and Delete Buffer" })
