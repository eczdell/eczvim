local lspconfig = vim.lsp.config

lspconfig.terraformls.setup({
    filetypes = { "terraform", "tf", "tfvars" },
})

