vim.opt.termguicolors = true

pcall(require, 'settings')
-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- load plugin manager
pcall(require, 'plugin-manager')
-- load plugin setup from plugins.lua
require("lazy").setup("plugins")

-- pcall(require, 'null-ls')
pcall(require, 'keybindings')
pcall(require, 'diagnostics')

-- Load Rust-specific configurations
-- pcall(require, 'rust.lsp_config')

pcall(require, "terraform.lsp_config")

-- Load js-specific configurations
pcall(require, "js.lsp_config")
pcall(require, "js.formatter")

-- Load python-specific configurations
pcall(require, 'python.cmp_config')
pcall(require, 'python.ruff')
pcall(require, "python.lsp_config")
pcall(require, "python.formatter")

-- Load go-specific configurations
-- pcall(require, 'go.lsp_config')
-- pcall(require, 'go.dap_config')
-- pcall(require, 'go.treesitter_config')

-- load plugin configurations
pcall(require, 'autopairs_config')
pcall(require, 'treesitter_config')

pcall(require, 'lsp_config')
pcall(require, 'cmp_config')

