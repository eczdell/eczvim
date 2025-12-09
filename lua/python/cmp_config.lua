-- New Neovim 0.11+ LSP setup

local config = vim.lsp.config

----------------------------------------------------------------
-- Pyright Setup
----------------------------------------------------------------
vim.lsp.start(config.pyright({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  end,

  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}))

----------------------------------------------------------------
-- Ruff LSP Setup
----------------------------------------------------------------
vim.lsp.start(config.ruff_lsp({
  init_options = {
    settings = {
      args = {}, -- extra CLI args like { "--line-length=88" }
    },
  },
}))

