# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Kickstart.nvim-based Neovim configuration - a well-documented, single-file starter configuration designed as a teaching tool. The configuration uses lazy.nvim for plugin management and follows modern Neovim best practices.

## Common Development Commands

### Code Formatting
- **Stylua**: Lua code formatter configured via `.stylua.toml`
  - Config: 160 column width, 2 spaces indent, Unix line endings
  - Run manually: `stylua init.lua lua/`

### Plugin Management
- `:Lazy` - Open lazy.nvim UI for plugin management
- `:Lazy sync` - Update all plugins
- `:Lazy restore` - Restore plugins to versions in `lazy-lock.json`
- `:checkhealth` - Check system requirements and plugin health

## High-Level Architecture

### Core Structure
The configuration follows a hub-and-spoke architecture:

1. **init.lua (Hub)**: Main configuration file (1000+ lines) containing:
   - Core Neovim settings and options
   - Lazy.nvim bootstrap and setup
   - Inline plugin specifications for core functionality
   - Imports for modular plugin files

2. **Modular Plugin System (Spokes)**:
   - `lua/custom/plugins/` - Custom user plugins (auto-imported)
   - `lua/kickstart/plugins/` - Optional kickstart plugins (manually required)

### Plugin Loading Architecture
The configuration leverages lazy.nvim's loading strategies:

- **Event-based**: `VimEnter`, `InsertEnter`, `BufWritePre`, `VeryLazy`
- **Command-based**: Plugins load when specific commands are called
- **Keymap-based**: Plugins load when specific keys are pressed
- **Filetype-based**: Language-specific plugins load for relevant files

### Adding New Plugins
1. **Simple inline plugin** in init.lua:
   ```lua
   { 'author/plugin-name', opts = {} }
   ```

2. **Complex plugin with configuration**:
   ```lua
   {
     'author/plugin-name',
     event = 'VimEnter',  -- or other loading strategy
     dependencies = { 'dependency/plugin' },
     config = function()
       require('plugin').setup({ --[[ options ]] })
     end,
   }
   ```

3. **Custom modular plugin**:
   - Create file in `lua/custom/plugins/myplugin.lua`
   - Return plugin specification table
   - Automatically loaded via import statement

### Key Architectural Patterns
- **Leader key**: Space (`<space>`)
- **Keymap patterns**:
  - `<leader>s` - Search operations
  - `<leader>t` - Toggle operations
  - `<leader>h` - Git hunk operations
  - `<leader>x` - Trouble diagnostics
  - `gr` - LSP goto operations

### Important Plugin Configurations
- **LSP**: Configured via nvim-lspconfig with Mason for automatic server installation
- **Completion**: blink.cmp with LSP, snippets, and path sources
- **Formatting**: conform.nvim handles code formatting
- **Git Integration**: gitsigns.nvim and git-blame.nvim
- **File Explorer**: neo-tree.nvim with `<leader>e` mapping
- **Fuzzy Finding**: telescope.nvim for file/text search

### System Requirements
- Neovim stable or nightly
- git, make, unzip, C compiler
- ripgrep and fd-find for searching
- Node.js/npm for TypeScript development
- Nerd Font (optional, check `vim.g.have_nerd_font`)