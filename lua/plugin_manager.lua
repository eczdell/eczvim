-- Set up Lazy.nvim plugin manager
-- Bootstrap lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath('data') .. '/site/pack/packer/start/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
-- Prepend lazy.nvim to runtimepath
vim.opt.runtimepath:prepend(lazypath)

-- Initialize lazy.nvim and load plugins
require("lazy").setup(require("plugins"))