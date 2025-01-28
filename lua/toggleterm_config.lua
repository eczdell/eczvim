vim.opt.termguicolors = true

-- Set up the toggleterm plugin with configurations
require('toggleterm').setup({
    size = 20,  -- Set the default size of the terminal window
    open_mapping = [[<c-\>]],  -- Keybinding to toggle the terminal (you can change this if desired)
    direction = 'float',  -- Terminal will open in a floating window (can also be 'horizontal', 'vertical', or 'tab')
    close_on_exit = true,  -- Automatically close the terminal when the process exits
    shell = vim.o.shell,   -- Use the default shell (bash, fish, etc.)
    shade_terminals = true,  -- Shade the terminal window
    persist_size = true,  -- Remember terminal size between sessions
    auto_scroll = true,  -- Enable auto-scrolling in the terminal
})

-- Optionally, you can define your own keybinding to toggle the terminal
vim.api.nvim_set_keymap('n', '<C-\\>', ':ToggleTerm<CR>', { noremap = true, silent = true })

-- Additional customization for terminal appearance can go here

