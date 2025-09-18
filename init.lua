vim.opt.termguicolors = true
-- load plugin manager
pcall(require, 'plugin-manager')
-- load plugin setup from plugins.lua
pcall(require, 'plugins')
pcall(require, 'settings')
pcall(require, 'keybindings')
pcall(require, 'diagnostics')

-- Load Rust-specific configurations
pcall(require, 'rust.lsp_config')

-- Load go-specific configurations
pcall(require, 'go.lsp_config')
pcall(require, 'go.dap_config')
pcall(require, 'go.treesitter_config')

-- load plugin configurations
pcall(require, 'autopairs_config')
pcall(require, 'treesitter_config')

pcall(require, 'lsp_config')
pcall(require, 'cmp_config')
pcall(require, 'toggleterm')

