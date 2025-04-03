vim.opt.termguicolors = true
-- load plugin manager
require('plugin_manager')
-- load plugin setup from plugins.lua
require('plugins')
require('settings')
require('keybindings')
require('diagnostics')

-- Load Rust-specific configurations
require('rust.lsp_config')
require('rust.null_ls_config')

-- Load go-specific configurations
require('go.lsp_config')
require('go.null_ls_config')
require('go.dap_config')
require('go.treesitter_config')

-- load plugin configurations
require('autopairs_config')
require('treesitter_config')

require('lsp_config') 
require('cmp_config')
require('null_ls_config') 
require('toggleterm') 
