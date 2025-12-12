-- New Neovim 0.11+ LSP setup

local config = vim.lsp.config

----------------------------------------------------------------
-- Pyright Setup
----------------------------------------------------------------
vim.lsp.start(config.pyright({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
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

