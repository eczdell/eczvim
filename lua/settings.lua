
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.g.mapleader = " "  -- Set leader key to spacebar
-- vim.o.foldlevel = 1 -- Collapse all folds by default
vim.o.foldlevel = 99 -- Set foldlevel to 99 to unfold all folds by default
-- Enable Treesitter folding
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'  -- Use Treesitter for folding


-- Set case-insensitive search
vim.opt.ignorecase = false
-- vim.opt.ignorecase = true
vim.opt.statusline = "%f [%{expand('%:e')} File] %= %y | Line: %l/%L | Col: %c"
-- Automatically delete the swap file if it exists
vim.o.swapfile = false
