-- enable lsp diagnostics (if not already configured)
vim.lsp.handlers["textdocument/publishdiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = true,
})
-- floating window for diagnostic messages
vim.cmd([[
  autocmd cursorhold * lua vim.diagnostic.open_float({ focusable = false })
]])


