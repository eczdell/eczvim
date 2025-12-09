local lspconfig = vim.lsp.config

-- ==============================
-- JavaScript / TypeScript LSP
-- ==============================
lspconfig.tsserver.setup({
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    on_attach = function(client, bufnr)
        print(">>> tsserver attached to buffer")
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end,
})

