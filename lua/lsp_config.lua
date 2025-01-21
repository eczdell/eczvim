-- LSP configuration
local lspconfig = require('lspconfig')

-- Pyright for Python
lspconfig.pyright.setup{}

-- ts_ls for TypeScript/JavaScript (updated)
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
      -- Set LSP keymaps
    --
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- Enable completion for the current buffer
    require('cmp').setup.buffer({
      sources = { { name = 'nvim_lsp' } }
    })

  end
})

-- Rust setup with rust-analyzer
lspconfig.rust_analyzer.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- Enable completion for the current buffer
    require('cmp').setup.buffer({
      sources = { { name = 'nvim_lsp' } }
    })
  end
})

