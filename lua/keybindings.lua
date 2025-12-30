-- keybindings.lua

vim.g.mapleader = " "  -- Set leader key to spacebar
local opts = { noremap = true, silent = true }


-- keybindings.lua

      -- keybinding
      local opts = { noremap = true, silent = true }
      -- Keybinding to toggle NvimTree
      vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

      -- Close the Todo Location List with a keybinding (in Lua)
      vim.api.nvim_set_keymap('n', '<leader>gb', ':Telescope git_branches<CR>', opts)
      vim.api.nvim_set_keymap('n', '<leader>gc', ':Telescope git_commits<CR>', opts)


      -- FIX :hello
      -- HACK: sabin
      -- TODO: sabin 

      -- Keybindings for managing TODO comments
      vim.api.nvim_set_keymap('n', '<leader>tn', ':TodoNext<CR>', opts)  -- Jump to the next TODO comment
      vim.api.nvim_set_keymap('n', '<leader>tp', ':TodoPrev<CR>', opts)  -- Jump to the previous TODO comment
      vim.api.nvim_set_keymap('n', '<leader>tl', ':TodoLocList<CR>', opts)  -- Open location list with all TODO comments
      -- Close the Todo Location List with a keybinding (in Lua)
      vim.api.nvim_set_keymap('n', '<leader>tc', ':close<CR>', opts)


-- Keymap for swapping lines with Ctrl+Up and Ctrl+Down (Normal mode)
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', opts)  -- Move line down
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', opts)  -- Move line up

-- Keymap for swapping lines in Visual mode (Multiple lines selection)
vim.api.nvim_set_keymap('x', '<A-j>', ":move '>+1<CR>gv=gv", opts)  -- Move selected lines down
vim.api.nvim_set_keymap('x', '<A-k>', ":move '<-2<CR>gv=gv", opts)  -- Move selected lines up

-- quick fix list next and previous keybinding
vim.api.nvim_set_keymap('n', ']q', ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[q', ':cprev<CR>', { noremap = true, silent = true })

-- jumps between matching pairs:
vim.keymap.set('n', '<leader>m', '%', { desc = 'Match pair' })

-- Keybinding to quickly view diagnostics
vim.api.nvim_set_keymap('n', '<leader>d', ':lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', opts)

-- ERROR only
vim.api.nvim_set_keymap('n', ']e', ':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>', opts)
vim.api.nvim_set_keymap('n', '[e', ':lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>', opts)

-- WARN only
vim.api.nvim_set_keymap('n', ']w', ':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>', opts)
vim.api.nvim_set_keymap('n', '[w', ':lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>', opts)

-- INFO only
vim.api.nvim_set_keymap('n', ']i', ':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.INFO })<CR>', opts)
vim.api.nvim_set_keymap('n', '[i', ':lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.INFO })<CR>', opts)

-- Map 'jk' to Escape in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)
-- Define options for key mappings

-- Map 'jk' to Escape in insert mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

-- Yank to system clipboard using 'y' in normal mode
vim.api.nvim_set_keymap('n', 'y', '"+y', opts)

-- Yank to system clipboard using 'y' in visual mode
vim.api.nvim_set_keymap('v', 'y', '"+y', opts)

-- Yank to system clipboard using 'y' in insert mode
vim.api.nvim_set_keymap('i', '<C-y>', '<Esc>"+y', opts)

-- Lazy.nvim plugin management key mappings
vim.api.nvim_set_keymap('n', '<leader>p', ':Lazy show<CR>', opts)  -- Update plugins



-- Keybinding for formatting
vim.api.nvim_set_keymap('n', '<leader>fm', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)

-- Telescope keymaps
vim.api.nvim_set_keymap('n', '<leader>f', '<Cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>F', '<Cmd>Telescope live_grep<CR>', opts)
vim.keymap.set("v", "<leader>F", function()
  local word = vim.fn.expand("<cword>")
  require("telescope.builtin").live_grep({ default_text = word })
end, { silent = true })

vim.api.nvim_set_keymap('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fk', '<Cmd>Telescope keymaps<CR>', opts)

-- Buffer navigation and closing keymaps
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', opts)       -- Next buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprev<CR>', opts)     -- Previous buffer
vim.api.nvim_set_keymap('n', '<leader>bd', ':bd<CR>', opts)     -- Close current buffe

-- NvimTree keymap
vim.api.nvim_set_keymap('n', '<leader>e', '<Cmd>NvimTreeFindFileToggle<CR>', opts)

-- LSP keymaps 
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Space>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>a', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)

-- Key mappings for Lazy Plugin Manager and opening the config file
vim.keymap.set('n', '<Leader>pm', ':Lazy<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lr", ":so $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Key mapping for opening LazyGit inside Neovim
-- '<leader>gg' will launch lazygit in a new window
vim.api.nvim_set_keymap('n', '<leader>gg', ':LazyGit<CR>', opts)

-- File management keymaps
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<Cmd>q<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>Q', '<Cmd>qa!<CR>', opts)

-- Split navigation keymaps (able to switch using leader and hjkl)
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', opts)
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', opts)
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', opts)
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', opts)

-- Resize windows
vim.api.nvim_set_keymap('n', '<C-Up>', '<Cmd>resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Down>', '<Cmd>resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Left>', '<Cmd>vertical resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Right>', '<Cmd>vertical resize +2<CR>', opts)

-- Miscellaneous keymaps
vim.api.nvim_set_keymap('n', '<leader>/', '/<C-R>=expand("<cword>")<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>n', ':noh<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>nr', ':set nu! rnu!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><leader>ds', ':Telescope lsp_document_symbols<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><leader>ws', ':Telescope lsp_workspace_symbols<CR>', opts)

-- Toggle full-screen width for current window
function _G.toggle_full_screen_width()
  local is_full_screen_width = vim.g.is_full_screen_width or false

  if is_full_screen_width then
    -- Restore the window to its original width (default value, e.g., 80 columns)
    vim.cmd('vertical resize 80')  -- Set the window width back to 80 columns
    vim.g.is_full_screen_width = false
  else
    -- Maximize the window width (make it as wide as possible) 
     vim.cmd('vertical resize 9999')  
    -- Set a large window width to make it full screen
    vim.g.is_full_screen_width = true
  end
end

-- Keybinding for full-screen width toggle
vim.api.nvim_set_keymap('n', '<leader>/', ':lua toggle_full_screen_width()<CR>', { noremap = true, silent = true })

