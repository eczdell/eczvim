-- plugins.lua
return {
    -- Rust-specific plugins
    { 'rust-lang/rust.vim' },                  -- Rust syntax support
    { 'neovim/nvim-lspconfig' },               -- LSP configuration
    { 'saecki/crates.nvim' },                  -- Crate version management (optional)
    { 'jose-elias-alvarez/null-ls.nvim' },     -- null-ls for formatters and linters
}

