-- load plugin manager
require('plugin_manager')
-- load plugin setup from plugins.lua
require('plugins')
require('settings')
require('keybindings')
require('diagnostics')

-- load plugin configurations
require('autopairs_config')
require('treesitter_config')

require('lsp_config') 
require('cmp_config')
require('null_ls_config') 
require('toggleterm') 
