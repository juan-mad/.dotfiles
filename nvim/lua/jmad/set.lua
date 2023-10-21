-- sets a "fat" cursor
-- vim.opt.guicursor = ""

-- Line numbers + relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- 4 space indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- line wrap
vim.opt.wrap = false

-- nvim does not do backups, instead undotree keeps old undo trees and histories
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- for file searching with /
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- colors?
vim.opt.termguicolors = true

-- when scrolling up, never have less than (8) lines above current position
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.g.mapleader = " "
