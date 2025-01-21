-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = {  "html", "javascript","typescript", "tsx", "json", "dockerfile", "terraform"},
  highlight = { enable = true },
  indent = { enable = true },
 folding = {
    enable = true,  -- Enable folding using treesitter
    disable = {},   -- Optionally disable certain languages from using folding
    -- folding based on treesitter syntax parsing
  },
  autotag = {
    enable = true,  -- Enable auto-closing HTML tags
    filetypes = { "html", "javascript", "typescript", "jsx", "tsx", "xml" },  -- Filetypes where auto-closing will work
  },
})
