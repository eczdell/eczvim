-- ========================================
-- Global LSP on_attach and capabilities
-- ========================================
local on_attach = function(_, bufnr)
  print(">>> LSP attached to buffer")
  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

-- Capabilities (for nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- ========================================
-- Mason + mason-lspconfig Setup
-- ========================================
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "pylsp",
    "rust_analyzer",
    "terraformls",
    "tflint",
  },
  automatic_installation = true,
})

local lsp = vim.lsp.config  -- NEW API for Neovim 0.11+

-- ========================================
-- Auto-setup for ALL LSPs
-- ========================================
local servers = {
  "pyright",
  "pylsp",
  "rust_analyzer",
  "terraformls",
  "tflint",
  "typescript-language-server",
}

for _, server in ipairs(servers) do
  lsp[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- ========================================
-- Custom TSServer autostart
-- ========================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  callback = function(args)
    vim.lsp.start({
      name = "tsserver",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = vim.fs.dirname(vim.fs.find(
        { "package.json", "tsconfig.json", ".git" },
        { upward = true, path = args.file }
      )[1]),
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

