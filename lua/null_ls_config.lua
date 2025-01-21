
-- Null-ls configuration for formatting and linting
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint.with({
      -- You can add specific options here if needed
      diagnostics_format = "#{m} (#{c})", -- Customizing the format to show message and code
    }),
    null_ls.builtins.formatting.prettier,
  },
})

  -- LSP diagnostic configuration
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true, -- Show underlines for issues
  update_in_insert = true, -- Update diagnostics while typing
  virtual_text = {
    prefix = ">>", -- Use a custom symbol for virtual text
    },
  })

-- Format on save with null-ls
vim.cmd([[
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json lua vim.lsp.buf.format({ async = true })
]])

