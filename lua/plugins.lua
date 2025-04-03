-- plugins.lua
return require('lazy').setup({
  { 'neovim/nvim-lspconfig' },    -- LSP configurations
    cmd= "Git",  -- Only load when required (you can adjust this as needed)
  { 'williamboman/mason-lspconfig.nvim' },
  { 'williamboman/mason.nvim', config = function() require("mason").setup() end },
  {'prisma/vim-prisma'},
{
  "vinnymeller/swagger-preview.nvim",
  cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
  build = "npm i",
  config = function()
    require("swagger-preview").setup({
      -- The port to run the preview server on
      port = 8000,
      -- The host to run the preview server on
      host = "localhost",
    })
  end,
},
{
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    require("chatgpt").setup({
    api_key = os.getenv("OPENAI_API_KEY"),  -- Ensure this is set correctly
    model = "gpt-3.5-turbo",  -- Change model to the free-tier GPT-3.5
      })
  end
}
,
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
    end,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio"
    },
  }
,
  {
     "akinsho/toggleterm.nvim",
     config = function()
         require("toggleterm_config")  -- Load the terminal config from this file
     end,
  },
  { 'kyazdani42/nvim-web-devicons' },  -- For icons
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true, -- Enable Treesitter support (for JSX/TSX)
        disable_filetype = { "TelescopePrompt" }, -- Disable in certain filetypes
      })
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      -- Colorizer setup configuration
      require('colorizer').setup({
        '*', -- Highlight all file types
        css = { rgb_fn = true }, -- Enable rgb() functions in CSS
        html = { names = false }, -- Disable color name parsing for HTML
      })
    end
  },
  -- for rust languages
{ 
  'williamboman/mason-lspconfig.nvim', 
  config = function() 
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "rust_analyzer" }, -- Ensure rust-analyzer is installed
    })
  end 
},
  {
  'akinsho/bufferline.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      options = {
        offsets = {
          {
            filetype = "NvimTree",  -- Optional: adjust for file explorer
            text = "File Explorer", -- Optional: customize the offset text
            highlight = "Directory", -- Optional: highlight for file explorer
            text_align = "left",     -- Optional: align the text to the left
          },
        },
        separator_style = "slant",  -- Optional: defines the separator style (thin, slant, etc.)
        always_show_bufferline = true, -- Always show the bufferline
        show_buffer_icons = true,     -- Show icons for buffers
        show_buffer_close_icons = true,  -- Show close icons for buffers
        show_tab_indicators = true,   -- Show tab indicators for active buffer
      }
    }
  end,
},

   -- nvim-ts-autotag plugin
  -- {
  --   'windwp/nvim-ts-autotag',
  --   config = function()
  --     -- Configure nvim-ts-autotag
  --   require('nvim-ts-autotag').setup({
  --     enable = true,  -- Enable the plugin
  --     filetypes = { 'html','ts', 'xml', 'javascript', 'typescript', 'tsx', 'jsx' },  -- Filetypes to enable autotag for
  --   })
  --   end,
  -- },
  --
    -- Install nvim-comment for easy commenting
  { 'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      padding = true,          -- Adds padding around comments
      sticky = true,           -- Keeps the comment on the same line if possible
      toggler = {
        line = '<leader>cc',   -- Toggle line comments
        block = '<leader>b',  -- Toggle block comments
      },
      opleader = {
        line = '<leader>c',    -- Operator for line-wise comment
        block = '<leader>b',   -- Operator for block-wise comment
      },
      mappings = {
        basic = true,          -- Enable basic key mappings
        extra = true,          -- Enable extra key mappings (visual mode)
      },
      -- Adding language-specific configurations
      pre_hook = function(ctx)
        local U = require('Comment.utils')

        -- Determine whether it's a block comment or line comment
        local filetype = vim.bo.filetype
        if filetype == 'html' then
          -- For HTML, use <!-- --> for block comments
          return {
            start = '<!-- ',
            ["end"] = ' -->',  -- 'end' needs to be quoted since it's a keyword in Lua
          }
        elseif filetype == 'javascript' or filetype == 'typescript' or filetype == 'javascriptreact' or filetype == 'typescriptreact' then
          -- For React (JSX/TSX), use { /* */ } for block comments
          if ctx.ctype == U.ctype.block then
            return {
              start = '/{/* ',
              ["end"] = ' /*/}', -- 'end' needs to be quoted here too
            }
          end
        end
      end,
    })
  end
}
,
 { 'vim-airline/vim-airline-themes' },
{
    'vim-airline/vim-airline',
    config = function()
      -- Optional: Configure vim-airline settings
      vim.g.airline_powerline_fonts = 1  -- Use powerline fonts for better aesthetics
      vim.g.airline_theme = 'dark'  -- Set the theme for airline (change as you prefer)
      -- Configure airline extensio  -- Set the separator style to arrow
    vim.g.airline_left_sep = ''  -- Powerline right arrow
    vim.g.airline_right_sep = '' -- Powerline left arrowns
      vim.g.airline_extensions = { 'branch', 'hunks', 'quickfix'  }  -- Add desired extensions
    end
  },
  -- todo-comments plugin for managing TODO comments
  {
    'folke/todo-comments.nvim',
    config = function()
      -- Set up the plugin with default settings
      require('todo-comments').setup {
        -- Optional: You can customize the signs for different types of comments
        signs = true,
        keywords = {
          TODO = { icon = "", color = "info" },
          FIX = { icon = "", color = "error" },
          HACK = { icon = "⚡", color = "warning" },
        },
      }
    end,
  },
  -- Autocompletion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
{
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
      }
   -- Keybinding to toggle current line blame
      vim.api.nvim_set_keymap('n', '<C-b>', ':Gitsigns blame_line<CR>', { noremap = true, silent = true })

    end
  }
},

  {
    'kdheepak/lazygit.nvim',   -- Plugin name
    dependencies = { 'nvim-lua/plenary.nvim' },  -- plenary is required by lazygit.nvim
    config = function()
      -- Configuration block for lazygit (can be customized further)
    end,
  },
  -- Telescope for fuzzy searching
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
   { 'nvim-telescope/telescope-symbols.nvim' },

  -- Syntax highlighting and code navigation
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-refactor' },
  -- File explorer sidebar with icons
  { 
    'nvim-tree/nvim-tree.lua', 
    dependencies = { 
      'nvim-lua/plenary.nvim',  -- Required for nvim-tree functionality
      'nvim-tree/nvim-web-devicons',  -- Icons for nvim-tree
  },
  config = function()
    -- Set up nvim-tree with icons and other customizations
    require('nvim-tree').setup {
      renderer = {
        icons = {
          show = {
            file = true,      -- Show file icons
            folder = true,    -- Show folder icons
            folder_arrow = true,  -- Show folder arrow icons
          },
          glyphs = {
            default = '',      -- Default file icon
            symlink = '',      -- Symlink icon
            git = {
              unstaged = '',    -- Git unstaged icon
              staged = '✓',      -- Git staged icon
              unmerged = '',    -- Git unmerged icon
              renamed = '➜',     -- Git renamed icon
              untracked = '★',   -- Git untracked icon
              ignored = '◌',     -- Git ignored icon
            },
            folder = {
              arrow_open = '',    -- Open folder icon
              arrow_closed = '',  -- Closed folder icon
              default = '',       -- Folder icon
              empty = '',         -- Empty folder icon
              empty_open = '',    -- Empty open folder icon
              open = '',          -- Open folder icon
            },
          },
        },
      },
    }

  end 
},

 -- Linting and formatting
 { 'jose-elias-alvarez/null-ls.nvim', config = function() require('null-ls').setup() end },

 { 'goolord/alpha-nvim', config = function() 
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.startify')

      -- Custom ASCII banner
      dashboard.config.layout[1][1] = {
        type = "text",
        val = {
          " ███╗   ███╗ ██████╗ ███████╗███████╗██╗   ██╗"
        },
        opts = { position = "center", hl = "Type" }
      }

      -- Optional: Custom buttons for navigation
      dashboard.config.buttons = {
        { icon = "  Find File", action = "Telescope find_files", shortcut = "<leader>f" },
        { icon = "  Recent Files", action = "Telescope oldfiles", shortcut = "<leader>r" },
        { icon = "  Settings", action = "e ~/.config/nvim/init.lua", shortcut = "<leader>s" },
      }

      -- Apply the custom configuration to the dashboard
      alpha.setup(dashboard.config)
    end 
  },
})
