return {

  -- Terraform LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "terraformls" },
      })

      local lspconfig = require("lspconfig")

      -- Terraform LSP
      lspconfig.terraformls.setup({})

      -- Auto format Terraform on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.tf", "*.tfvars" },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  },

  -- Syntax Highlight
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "tfvars" },
    config = function()
      vim.g.terraform_fmt_on_save = 0 -- Avoids double-format if using LSP fmt
    end,
  },

  -- Optional: TFLint + terraform_fmt via null-ls (recommended)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.terraform_fmt,
          null_ls.builtins.diagnostics.tflint,
        },
      })
    end,
  },

}

