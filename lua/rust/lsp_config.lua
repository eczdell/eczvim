-- rust/lsp_config.lua
local lspconfig = require('lspconfig')

lspconfig.rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true,
            },
        },
    },
})

