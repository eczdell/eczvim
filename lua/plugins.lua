-- plugins.lua
return {
  git = {
    url_format = "git@github.com:%s.git"
  },
  -- ======================
  -- LSP + Mason
  -- ======================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local mason_lspconfig = require("mason-lspconfig")
    local lsp = require("lspconfig")  -- corrected

    local on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local servers = {
      pyright = "pyright",
      ["python-lsp-server"] = "pylsp",
      ["rust-analyzer"] = "rust_analyzer",
      ["terraform-ls"] = "terraformls",
      tflint = "tflint",
      tsserver = "tsserver",
    }

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    })

  end,
}
,

  -- ======================
  -- General Plugins
  -- ======================
  { "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        lsp_format = true,
        formatters_by_ft = {
          python = { "ruff_format" },
        },
      })
    end,
  },

  { "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = { "folke/snacks.nvim", "nvim-telescope/telescope.nvim", "ibhagwan/fzf-lua" },
  },

  { 'prisma/vim-prisma' },

  {
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = function()
      require("swagger-preview").setup({ port = 8000, host = "localhost" })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  { "akinsho/toggleterm.nvim", config = function() require("toggleterm_config") end },
  { "kyazdani42/nvim-web-devicons" },
  { "windwp/nvim-autopairs", config = function() require('nvim-autopairs').setup({ check_ts = true, disable_filetype = { "TelescopePrompt" } }) end },
  { "norcalli/nvim-colorizer.lua", config = function() require('colorizer').setup({ '*', css = { rgb_fn = true }, html = { names = false } }) end },

  { "akinsho/bufferline.nvim", dependencies = { 'kyazdani42/nvim-web-devicons' }, config = function()
      require('bufferline').setup {
        options = {
          offsets = {{ filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" }},
          separator_style = "slant",
          always_show_bufferline = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_tab_indicators = true,
        }
      }
  end },

  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  { 'vim-airline/vim-airline-themes' },
  { 'vim-airline/vim-airline', config = function() vim.g.airline_powerline_fonts = 1; vim.g.airline_theme = 'dark' end },
  { 'folke/todo-comments.nvim', config = function() require('todo-comments').setup() end },
  { 'neovim/nvim-lspconfig' },

  -- Autocompletion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  { 'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end },
  { 'kdheepak/lazygit.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-symbols.nvim' },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-refactor' },

  -- File Explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' }, config = function()
      require('nvim-tree').setup {
        renderer = { icons = { show = { file = true, folder = true, folder_arrow = true } } }
      }
  end },

  { 'goolord/alpha-nvim', config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.startify')
      dashboard.config.layout[1][1] = { type = "text", val = { " ███╗   ███╗ ██████╗ ███████╗███████╗██╗   ██╗" }, opts = { position = "center", hl = "Type" } }
      dashboard.config.buttons = {
        { icon = "  Find File", action = "Telescope find_files", shortcut = "<leader>f" },
        { icon = "  Recent Files", action = "Telescope oldfiles", shortcut = "<leader>r" },
        { icon = "  Settings", action = "e ~/.config/nvim/init.lua", shortcut = "<leader>s" },
      }
      alpha.setup(dashboard.config)
  end },
}
