local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork"},
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        fieldalignment = true,
        shadow = true,
        nilness = true,
      },
      staticcheck = true,
      gofumpt = true, -- Use gofumpt for better formatting
    },
  },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    keymap(bufnr, "n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    keymap(bufnr, "n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    keymap(bufnr, "n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    -- Format on save
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})

