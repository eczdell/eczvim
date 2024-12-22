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

## **Key Mappings & Shortcuts**

### **General Key Mappings**

| Action                        | Key Mapping           | Command                 |
|-------------------------------|-----------------------|-------------------------|
| Save File                     | `<leader>w`           | `:w`                    |
| Quit Neovim                   | `<leader>q`           | `:q`                    |
| Force Quit Neovim             | `<leader>Q`           | `:qa!`                  |
| Toggle NvimTree (File Explorer) | `<leader>e`           | `:NvimTreeToggle`       |
| Show Lazy Plugin Manager      | `<leader>l`           | `:Lazy show`            |
| Open LazyGit                  | `<leader>gg`          | `:LazyGit`              |
| git commits                   | `<leader>gg`          | `:LazyGit`              |
| git branches                  | `<leader>gg`          | `:LazyGit`              |

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

---

### **Telescope (Fuzzy Finder)**

| Action                        | Key Mapping           | Command                      |
|-------------------------------|-----------------------|------------------------------|
| Find File                     | `<leader>f`           | `:Telescope find_files`      |
| Live Grep (Search in Files)   | `<leader>F`           | `:Telescope live_grep`       |
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
| Move Window Focus Left        | `<C-h>`               | Move to left window    |
| Move Window Focus Down        | `<C-j>`               | Move to bottom window  |
| Move Window Focus Up          | `<C-k>`               | Move to top window     |
| Move Window Focus Right       | `<C-l>`               | Move to right window   |
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

### **Plugin Manager (Lazy.nvim)**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Update Plugins                | `<leader>pm`          | `:Lazy show`        |
| Vim Configuration             | `<leader>pc`          |`:Lazy show`        |

---

### **Autopairs & Snippets**

| Action                        | Key Mapping           | Command             |
|-------------------------------|-----------------------|---------------------|
| Fast Wrap                     | `<M-e>`               | Close nearest pair (`{`, `[`, `(`, etc.) |

---
This document summarizes all the used plugins and the most frequently used key mappings in your Neovim configuration.

Happy coding! 😊


