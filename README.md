# eczvim

## Overview
`eczvim` is a pre-configured Neovim setup designed to enhance your Neovim experience with useful plugins, key mappings, and customizations. This repository includes essential settings for LSP, completion, syntax highlighting, file navigation, Git integration, and more.

## Installation

To set up Neovim with the `eczvim` configuration, clone this repository into your Neovim config directory:

### 1. Clone the repository:

```bash
git clone git@github.com:eczdell/eczvim.git ~/.config/nvim
```

# Neovim Keybindings & Plugin Setup

This document lists the key mappings and shortcuts configured for your Neovim setup along with the plugins used in your configuration.

---

```

# Install Prettier
npm install -g prettier

# Install ESLint
npm install -g eslint

# Install TypeScript and TSServer (for JavaScript/TypeScript)
npm install -g typescript typescript-language-server

# Install LazyGit
sudo apt install lazygit

```

## **Plugins Used**

1. **[lazy.nvim](https://github.com/folke/lazy.nvim)** - A plugin manager for Neovim that allows for lazy loading of plugins.
2. **[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configurations for Neovim.
3. **[williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)** - A tool for managing LSP servers, DAP servers, linters, and formatters.
4. **[williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)** - Bridges `mason.nvim` with `nvim-lspconfig` for easier LSP setup.
5. **[kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)** - Provides file type icons.
6. **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion plugin for Neovim.
7. **[hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)** - LSP source for `nvim-cmp`.
8. **[hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)** - Buffer source for `nvim-cmp`.
9. **[L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine for Neovim written in Lua.
10. **[saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)** - LuaSnip source for `nvim-cmp`.
11. **[kdheepak/lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)** - Interface for `lazygit` inside Neovim.
12. **[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder plugin.
13. **[nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - A collection of Lua functions used by several other plugins.
14. **[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)** - Auto pairs brackets, quotes, etc., in Neovim.
15. **[nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Syntax highlighting and code navigation.
16. **[nvim-treesitter/nvim-treesitter-refactor](https://github.com/nvim-treesitter/nvim-treesitter-refactor)** - Treesitter refactor plugin for advanced features.
17. **[nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)** - File explorer for Neovim.
18. **[jose-elias-alvarez/null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)** - Integrates external linters, formatters, and code actions.
19. **[goolord/alpha-nvim](https://github.com/goolord/alpha-nvim)** - Neovim dashboard with a customizable startup screen.

---

## Installing fornt (devicons)
````
notepad.exe "C:\Users\ssilw\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

sabin@DESKTOP-AR0IPN8:/mnt/c/Users/ssilw/Downloads/0xProto$ pwd
/mnt/c/Users/ssilw/Downloads/0xProto
sabin@DESKTOP-AR0IPN8:/mnt/c/Users/ssilw/Downloads/0xProto$

"font":
{
  "face": "0xProto Nerd Font Mono",
  "size": 11
}
```

## **Key Mappings & Shortcuts**

### **General Key Mappings**

| Action                        | Key Mapping           | Command                 |
|-------------------------------|-----------------------|-------------------------|
| Save File                     | `<leader>w`           | `:w`                    |
| Quit Neovim                   | `<leader>q`           | `:q`                    |
| Force Quit Neovim             | `<leader>Q`           | `:qa!`                  |
| Toggle NvimTree (File Explorer) | `<leader>e`         | `:NvimTreeToggle`       |
| Show Lazy Plugin Manager      | `<leader>l`           | `:Lazy show`            |
| Open LazyGit                  | `<leader>gg`          | `:LazyGit`              |
| git commits                   | `<leader>gc`          | `:LazyGit`              |
| gitsign blame                 | `<C-b>`               | `:       `              |
| git branches                  | `<leader>gb`          | `:LazyGit`              |
| move to git prev change       | `[c`                  |                         |
| move to git next change       | `]c`                  |                         |

---

### **Todo Notes**

| Action         | Key Mapping           | Command                 |
|----------------|-----------------------|-------------------------|
| Todo List      | `<leader>tl`          | `:TodoLocList`          |
| Todo Next      | `<leader>tn`          | `:TodoNext`             |
| Todo Prev      | `<leader>tp`          | `:TodoPrev`             |
| Todo Close     | `<leader>tc`          | `:close`                |
---

### **Buffer Navigation**

| Action                        | Key Mapping           | Command                 |
|-------------------------------|-----------------------|-------------------------|
| Next Buffer                   | `<Tab>`               | `:bnext`                |
| Previous Buffer               | `<S-Tab>`             | `:bprev`                |
| Close Current Buffer          | `<leader>bd`          | `:bd`                   |

---

### **Treesitter**

| Action                        | Key Mapping           | Command                 |
|-------------------------------|-----------------------|-------------------------|
| Close code Fold               | `<leader>zc`          | `:bnext`                |
| open  code Fold               | `<leader>zo`          | `:bnext`                |

---
### **LSP (Language Server Protocol) Key Mappings**

| Action                        | Key Mapping           | Command                         |
|-------------------------------|-----------------------|---------------------------------|
| Go to Definition              | `gd`                  | `:lua vim.lsp.buf.definition()` |
| Go to References              | `gr`                  | `:lua vim.lsp.buf.references()` |
| Show Hover Information        | `K`                   | `:lua vim.lsp.buf.hover()`      |
| Go to Implementation          | `gi`                  | `:lua vim.lsp.buf.implementation()` |
| Signature Help                | `<C-Space>`           | `:lua vim.lsp.buf.signature_help()` |
| Code Action                   | `<leader>a`           | `:lua vim.lsp.buf.code_action()` |
| Rename Symbol                 | `<leader>r`           | `:lua vim.lsp.buf.rename()`    |
| Go to Previous Diagnostic     | `[d`                  | `:lua vim.lsp.diagnostic.goto_prev()` |
| Go to Next Diagnostic         | `]d`                  | `:lua vim.lsp.diagnostic.goto_next()` |
| Go to Previous Quickfix Item  | `[q`                  | `:cprevious<CR>`                      |
| Go to Next Quickfix Item      | `]q`                  | `:cnext<CR>`                          |


---

### **Telescope (Fuzzy Finder)**

| Action                        | Key Mapping           | Command                      |
|-------------------------------|-----------------------|------------------------------|
| Find File                     | `<leader>f`           | `:Telescope find_files`      |
| Live Grep (Search in Files)   | `<leader>F`           | `:Telescope live_grep`       |
| visual (Search in Files)      | `<leader>F`           | `:Telescope live_grep`       |
| Buffers                       | `<leader>fb`          | `:Telescope buffers`         |
| Help Tags                     | `<leader>fh`          | `:Telescope help_tags`       |
| Diagnostics                   | `<leader>fd`          | `:Telescope diagnostics`     |

---

### **Miscellaneous Key Mappings**

| Action                        | Key Mapping           | Command                   |
|-------------------------------|-----------------------|---------------------------|
| Toggle Line Numbering         | `<leader>nr`          | `:set nu! rnu!`           |
| Disable Search Highlighting   | `<leader>n`           | `:noh`                    |

---

### **Window Management**

| Action                        | Key Mapping           | Command                |
|-------------------------------|-----------------------|------------------------|
| Move Window Focus Left        | `<leader>h`               | Move to left window    |
| Move Window Focus Down        | `<leader>j`               | Move to bottom window  |
| Move Window Focus Up          | `<leader>k`               | Move to top window     |
| Move Window Focus Right       | `<leader>l`               | Move to right window   |
| Increase Height               | `<C-Up>`              | `:resize +2`           |
| Decrease Height               | `<C-Down>`            | `:resize -2`           |
| Increase Width                | `<C-Right>`           | `:vertical resize +2`  |
| Decrease Width                | `<C-Left>`            | `:vertical resize -2`  |
| Full Width toggle             | `<leader>/`            | `:vertical resize -2`  |

---

### **Text Editing**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Move Line Up                  | `<A-k>`               | `:m .-2`            |
| Move Line Down                | `<A-j>`               | `:m .+1`            |
| Move Selected Lines Up        | `<A-k>` (Visual Mode) | `:move '<-2`        |
| Move Selected Lines Down      | `<A-j>` (Visual Mode) | `:move '>+1`        |
| Escape Insert Mode            | `jk`                  | `Esc`               |

---

### **Clipboard Operations**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Yank to System Clipboard      | Normal Mode: `y`      | `"+y`               |
|                               | Visual Mode: `y`      | `"+y`               |
|                               | Insert Mode: `<C-y>`  | `"+y`               |

---

### **LSP Symbol**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| lsp workspace symbols         | `<leader><leader>ws`  | `:Lazy show`        |
| lsp document symbols          | `<leader><leader>ds`  | `:Lazy show`        |

---
---

### **Plugin Manager (Lazy.nvim)**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Update Plugins                | `<leader>pm`          | `:Lazy show`        |
| Vim Configuration             | `<leader>pc`          |`:Lazy show`         |

---

### **Autopairs & Snippets**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Fast Wrap                     | `<M-e>`               | Close nearest pair (`{`, `[`, `(`, etc.) |

# Basic Vim Key Mappings

## Basic Navigation (hjkl)

| Key | Action           | Description                                |
|-----|------------------|--------------------------------------------|
| h   | Move left        | Move the cursor one character to the left. |
| j   | Move down        | Move the cursor one line down.             |
| k   | Move up          | Move the cursor one line up.               |
| l   | Move right       | Move the cursor one character to the right. |
| w   | Move to next word| Move the cursor to the start of the next word. |
| e   | Move to end of word | Move the cursor to the end of the current word. |
| b   | Move to previous word | Move the cursor to the start of the previous word. |

## Text Operations

| Action              | Key Mapping | Command                                                   |
|---------------------|-------------|-----------------------------------------------------------|
| yap (Yank a paragraph) | yap         | Yank the entire paragraph (from } to }).                  |
| dat (delete a paragraph) | dat | delete the around html tag).                  |
| vap (Visual a paragraph) | vap         | Visually select the entire paragraph (from } to }).       |
| caw (Change a word)    | caw         | Change the word under the cursor, entering insert mode.    |
| yaw (Yank a word)      | yaw         | Yank the word under the cursor.                           |
| vaw (Visual a word)    | vaw         | Visually select the word under the cursor.                |
| ciw (Change inner word) | ciw         | Change the word under the cursor, excluding surrounding spaces. |
| A   | A            | Move to the end of the current line and enter insert mode. |
| I   | I            | Move to the beginning of the current line and enter insert mode. |
| O   | O            | Insert a new line above the current line and enter insert mode. |
| o   | o            | Insert a new line below the current line and enter insert mode. |
## Movement to Specific File Locations

| Action                       | Key Mapping | Command                                                |
|------------------------------|-------------|--------------------------------------------------------|
| Go to the beginning of the file | gg          | Moves the cursor to the top of the file.               |
| Go to the end of the file      | G           | Moves the cursor to the bottom of the file.            |
| Go to the 10th line of the file| 10G         | Moves the cursor to line 10 of the file.               |

## Nvim Tree Commands

| Action                         | Key Mapping   | Command                                                   |
|--------------------------------|---------------|-----------------------------------------------------------|
| Open Nvim Tree                 | `<leader>e`   | Open the Nvim Tree file explorer.                         |
| Create a new file              | `a`           | Create a new file in the current directory.               |
| Delete a file or folder        | `d`           | Delete the selected file or folder (confirm with `y`).    |
| Cut (move) a file or folder    | `x`           | Cut the selected file or folder (move it).                |
| Paste a file or folder         | `p`           | Paste the cut file or folder into the current directory.  |
| Rename a file or folder        | `r`           | Rename the selected file or folder.                       |

## Golang-Specific Nvim Commands  

| Action                        | Key Mapping   | Command                                           |  
|--------------------------------|--------------|---------------------------------------------------|  
| Go to definition              | `gd`         | Jump to the definition of the symbol under cursor. |  
| Show references               | `gr`         | List all references to the symbol under cursor.   |  
| Show hover information        | `K`          | Show documentation for the symbol under cursor.   |  
| Rename symbol                 | `<leader>rn` | Rename the symbol under cursor.                   |  
| Go to previous diagnostic     | `[d`         | Jump to the previous error or warning.            |  
| Go to next diagnostic         | `]d`         | Jump to the next error or warning.                |  
| Show code actions             | `<leader>ca` | Show available code actions (fixes, refactoring). |  
| Format code                   | `<leader>f`  | Format the current buffer using `gopls`.          |  
| Run tests in the file         | `<leader>tt` | Run all tests in the current Go file.             |  
| Run nearest test function     | `<leader>tn` | Run the test function under cursor.               |  
| Open test output in quickfix  | `<leader>to` | Show test results in quickfix window.             |  
| Toggle test coverage          | `<leader>tc` | Show test coverage highlights.                    |  
| Restart `gopls` LSP           | `<leader>rs` | Restart the `gopls` language server.              |  

This document summarizes all the used plugins and the most frequently used key mappings in your Neovim configuration.

Happy coding! 😊


