-- Set Neovim options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.g.mapleader = " "  -- Set leader key to spacebar

-- Set up Lazy.nvim plugin manager
-- Bootstrap lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath('data') .. '/site/pack/packer/start/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
-- Prepend lazy.nvim to runtimepath
vim.opt.runtimepath:prepend(lazypath)

-- Enable LSP diagnostics (if not already configured)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = true,
})
require('lazy').setup({
  { 'neovim/nvim-lspconfig' },    -- LSP configurations
  { 'williamboman/mason.nvim', config = function() require("mason").setup() end },
  { 'williamboman/mason-lspconfig.nvim' },
{ 'kyazdani42/nvim-web-devicons' },  -- For icons
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
        separator_style = "thin",  -- Optional: defines the separator style (thin, slant, etc.)
        always_show_bufferline = true, -- Always show the bufferline
        show_buffer_icons = true,     -- Show icons for buffers
        show_buffer_close_icons = true,  -- Show close icons for buffers
        show_tab_indicators = true,   -- Show tab indicators for active buffer
      }
    }
  end,
},
  -- Autocompletion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
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

 { 'windwp/nvim-autopairs', config = function()
      require('nvim-autopairs').setup {
        check_ts = true,  -- Enable Treesitter support
        enable_check_bracket_line = false,  -- Disable checking for closing brackets in the same line
        disable_filetype = { "TelescopePrompt", "vim" },  -- Disable autopairs in certain filetypes
      }
    end
  },

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

    -- Keybinding to toggle NvimTree
    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
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

-- LSP configuration
local lspconfig = require('lspconfig')

-- Pyright for Python
lspconfig.pyright.setup{}

-- ts_ls for TypeScript/JavaScript (updated)
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Enable completion for the current buffer
    require('cmp').setup.buffer({
      sources = { { name = 'nvim_lsp' } }
    })

    -- Set LSP keymaps
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  end
})

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt", "vim" },
  check_ts = true,
  fast_wrap = {
    map = "<M-e>",  -- Alt+e to trigger a fast wrap (close pair with cursor)
    chars = { "{", "[", "(", '"' },  -- Define which characters to wrap fast
    pattern = [=[[%'%"%>%]%)%}]]=],  -- Define the pattern to wrap around
    end_key = "$",  -- End key for wrapping
    keys = "qwertyuiopzxcvbnmasdfghjkl",  -- Keys for fast wrapping
  }
})

-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  ensure_installed = { "javascript", "typescript", "tsx", "json" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- Null-ls configuration for formatting and linting
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.diagnostics.eslint,
  },
})

-- Autocompletion setup (nvim-cmp)
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)  -- Use LuaSnip for snippet expansion
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),  -- Move to previous completion item
    ['<C-n>'] = cmp.mapping.select_next_item(),  -- Move to next completion item
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),     -- Scroll documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(4),      -- Scroll documentation
    ['<Enter>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion
    ['<C-Space>'] = cmp.mapping.complete(),           -- Trigger completion
  },
  sources = {
    { name = 'nvim_lsp' },           -- LSP-based completion (for variables, functions, etc.)
    { name = 'buffer' },             -- Completion from current buffer
    { name = 'luasnip' },            -- Snippets from LuaSnip
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        buffer = '[Buffer]',
        luasnip = '[Snippet]',
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- Keymap for swapping lines with Alt+Up and Alt+Down (Normal mode)
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })  -- Move line up
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })  -- Move line down

-- Keymap for swapping lines in Visual mode (Multiple lines selection)
vim.api.nvim_set_keymap('x', '<A-k>', ":move '<-2<CR>gv=gv", { noremap = true, silent = true })  -- Move selected lines up
vim.api.nvim_set_keymap('x', '<A-j>', ":move '>+1<CR>gv=gv", { noremap = true, silent = true })  -- Move selected lines down


-- Format on save with null-ls
vim.cmd([[
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json lua vim.lsp.buf.format({ async = true })
]])

-- Null-ls configuration for formatting and linting
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint.with({
      -- You can add specific options here if needed
      diagnostics_format = "#{m} (#{c})", -- Customizing the format to show message and code
    }),
    null_ls.builtins.formatting.prettier,
  },
})

-- LSP diagnostic configuration
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true, -- Show underlines for issues
  update_in_insert = true, -- Update diagnostics while typing
  virtual_text = {
    prefix = ">>", -- Use a custom symbol for virtual text
  },
})

-- Floating window for diagnostic messages
vim.cmd([[
  autocmd CursorHold * lua vim.diagnostic.open_float({ focusable = false })
]])

-- Keybinding to quickly view diagnostics
vim.api.nvim_set_keymap('n', '<leader>d', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- Key mappings
local opts = { noremap = true, silent = true }

-- Map 'jk' to Escape in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
-- Define options for key mappings
local opts = { noremap = true, silent = true }

-- Map 'jk' to Escape in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

-- Yank to system clipboard using 'y' in normal mode
vim.api.nvim_set_keymap('n', 'y', '"+y', opts)

-- Yank to system clipboard using 'y' in visual mode
vim.api.nvim_set_keymap('v', 'y', '"+y', opts)

-- Yank to system clipboard using 'y' in insert mode
vim.api.nvim_set_keymap('i', '<C-y>', '<Esc>"+y', opts)

-- Lazy.nvim plugin management key mappings
vim.api.nvim_set_keymap('n', '<leader>l', ':Lazy show<CR>', { noremap = true, silent = true })  -- Update plugins


-- Telescope keymaps
vim.api.nvim_set_keymap('n', '<leader>f', '<Cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>F', '<Cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', opts)

-- Buffer navigation and closing keymaps
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', opts)       -- Next buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprev<CR>', opts)     -- Previous buffer
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', opts)     -- Close current buffe

-- NvimTree keymap
vim.api.nvim_set_keymap('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', opts)

-- LSP keymaps
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Space>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

-- Key mapping for opening LazyGit inside Neovim
-- '<leader>gg' will launch lazygit in a new window
vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- File management keymaps
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<Cmd>q<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Q', '<Cmd>qa!<CR>', opts)

-- Split navigation keymaps
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize windows
vim.api.nvim_set_keymap('n', '<C-Up>', '<Cmd>resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Down>', '<Cmd>resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', opts)

-- Miscellaneous keymaps
vim.api.nvim_set_keymap('n', '<leader>/', '/<C-R>=expand("<cword>")<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>n', ':noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>nr', ':set nu! rnu!<CR>', opts)

