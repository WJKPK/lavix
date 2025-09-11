vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
--vim.opt.signcolumn = "yes:3"
vim.opt.tabstop = 4
vim.opt.timeoutlen = 0
vim.wo.wrap = false
vim.opt.exrc = true
vim.cmd("syntax on")
vim.diagnostic.config({
  virtual_lines = true
})

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

--vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
--vim.keymap.set("n", "<space>x", ":.lua<CR>")
--vim.keymap.set("v", "<space>x", ":lua<CR>")
