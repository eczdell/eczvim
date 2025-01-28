-- plugins.lua
return require('lazy').setup({
  { 'neovim/nvim-lspconfig' },    -- LSP configurations
    cmd= "Git",  -- Only load when required (you can adjust this as needed)
  { 'williamboman/mason-lspconfig.nvim' },
  { 'williamboman/mason.nvim', config = function() require("mason").setup() end },
  {
     "akinsho/toggleterm.nvim",
     config = function()
         require("toggleterm_config")  -- Load the terminal config from this file
     end,
  },
  { 'kyazdani42/nvim-web-devicons' },  -- For icons
   {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',  -- Ensure it loads when entering insert mode
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
  { 
    'windwp/nvim-ts-autotag', 
    config = function()
      -- Configure nvim-ts-autotag
      require('nvim-ts-autotag').setup()
    end,
  },
    -- Install nvim-comment for easy commenting
  { 'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      padding = true,          -- Adds padding around comments
      sticky = true,           -- Keeps the comment on the same line if possible
      toggler = {
        line = '<leader>cc',   -- Toggle line comments
        block = '<leader>cb',  -- Toggle block comments
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
              start = '{/* ',
              ["end"] = ' */}', -- 'end' needs to be quoted here too
            }
          end
        end
      end,
    })
  end
}
,
 { 'vim-airline/vim-airline-themes' },
    -- Install vim-fugitive plugin
  {
    'tpope/vim-fugitive'
  },
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
  'airblade/vim-gitgutter',
  config = function()
    -- Optional: configure gitgutter settings
  end
},
  -- Adding the lazygit.nvim plugin
 
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
