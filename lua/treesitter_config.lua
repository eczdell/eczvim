-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "html", "javascript", "typescript", "tsx", "json",
    "dockerfile", "terraform", "hcl"
  },

  highlight = { enable = true },
  indent = { enable = true },

  autotag = {
    enable = true,
    filetypes = { "html", "javascript", "typescript", "jsx", "tsx", "xml" },
  },
})

