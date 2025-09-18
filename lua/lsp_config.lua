-- lsp_config.lua
local on_attach = function(_, bufnr)
  print(">>> LSP attached to buffer")
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function(args)
    vim.lsp.start({
      name = "tsserver",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = vim.fs.dirname(vim.fs.find(
        { "package.json", "tsconfig.json", ".git" },
        { upward = true, path = args.file }
      )[1]),
      on_attach = on_attach,
    })
  end,
})

