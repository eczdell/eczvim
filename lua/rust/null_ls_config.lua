-- rust/null_ls_config.lua
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- You can add Rust-related formatters or linters here
        null_ls.builtins.formatting.rustfmt,
    },
})

