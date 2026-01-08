# AGENTS.md

Instructions for AI coding agents working in this Neovim configuration repository.

## Project Overview

Kickstart.nvim-based Neovim configuration using lazy.nvim for plugin management. Hub-and-spoke architecture with a main `init.lua` and modular plugin files in `lua/custom/plugins/`.

## Build, Lint, and Test Commands

### Formatting
```bash
# Format all Lua files (primary command)
stylua init.lua lua/

# Format specific file
stylua lua/custom/plugins/lspconfig.lua

# Check formatting without changes
stylua --check init.lua lua/
```

### Plugin Management (run inside Neovim)
```vim
:Lazy              " Open plugin manager UI
:Lazy sync         " Update all plugins
:Lazy restore      " Restore from lazy-lock.json
:checkhealth       " Check system requirements and plugin health
```

### Testing
This is a Neovim configuration, not an application with traditional tests. Testing is done via:
- `:checkhealth` - Verify plugin and LSP health
- Manual validation - Test keymaps and plugin functionality
- Neotest for projects using this config - `<leader>tr` (run nearest test), `<leader>tf` (run test file)

## Code Style Guidelines

### Formatting Standards
- **Column width**: 160 characters (stylua.toml)
- **Indentation**: 2 spaces (no tabs)
- **Line endings**: Unix (LF)
- **Quote style**: Auto-prefer single quotes

### Lua Conventions

#### File Structure
```lua
-- Plugin files in lua/custom/plugins/ should return a table
return {
  'author/plugin-name',
  event = 'VimEnter',  -- Loading strategy
  dependencies = { 'dependency/plugin' },
  config = function()
    require('plugin').setup({
      -- Configuration here
    })
  end,
}
```

#### Naming Conventions
- **Variables**: `snake_case` (e.g., `local lazypath`, `local ensure_installed`)
- **Functions**: `snake_case` (e.g., `local function client_supports_method()`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `local SERVERS = {}`)
- **Plugin files**: `kebab-case.lua` (e.g., `lspconfig.lua`, `alpha-nvim.lua`)

#### Imports and Requires
```lua
-- Prefer local requires at function scope when possible
local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
end

-- Global requires at top of file for dependencies
local null_ls = require 'null-ls'
local cspell = require 'cspell'
```

#### Comments
- Use `--` for single-line comments
- Use `-- NOTE:`, `-- WARN:`, `-- HACK:` prefixes for important comments
- Document complex configuration blocks
- Include `:help` references where relevant

#### Type Annotations
```lua
-- Use LuaLS annotations for clarity
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer some lsp support methods only in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
  -- Implementation
end
```

### Vim API Usage
- Prefer `vim.o` for simple options
- Use `vim.opt` for list/map options (e.g., `vim.opt.listchars = { tab = '» ' }`)
- Use `vim.keymap.set()` for all keymaps (not `vim.api.nvim_set_keymap`)
- Always include `desc` parameter in keymaps for which-key integration

### Error Handling
```lua
-- Check for plugin availability
local ok, plugin = pcall(require, 'plugin-name')
if not ok then
  vim.notify('Plugin not found: plugin-name', vim.log.levels.ERROR)
  return
end

-- Validate external dependencies
if vim.fn.executable('tool-name') ~= 1 then
  vim.notify('Required tool not found: tool-name', vim.log.levels.WARN)
end
```

### Plugin Configuration Patterns

#### Lazy Loading Strategies
- `event = 'VimEnter'` - After UI loads
- `event = 'InsertEnter'` - When entering insert mode
- `event = 'BufWritePre'` - Before saving buffer
- `cmd = 'CommandName'` - When command is invoked
- `keys = '<leader>x'` - When key is pressed
- `ft = 'lua'` - For specific filetypes

#### Dependencies
Always declare dependencies explicitly:
```lua
dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
}
```

### Keymap Patterns
- **Leader key**: `<space>` (vim.g.mapleader)
- **Search**: `<leader>s` prefix (e.g., `<leader>sf` = search files)
- **Toggle**: `<leader>t` prefix (e.g., `<leader>th` = toggle inlay hints)
- **Git hunks**: `<leader>h` prefix
- **Diagnostics**: `<leader>x` prefix (Trouble)
- **LSP goto**: `gr` prefix (e.g., `grd` = goto definition, `grr` = goto references)
- **Test**: `<leader>t` prefix (e.g., `<leader>tr` = run test, `<leader>tf` = test file)

### File Organization
- **Core config**: `init.lua` (settings, options, core plugins)
- **Custom plugins**: `lua/custom/plugins/*.lua` (auto-imported via `{ import = 'custom.plugins' }`)
- **Kickstart plugins**: `lua/kickstart/plugins/*.lua` (manually required in init.lua)
- **One plugin per file** in custom/plugins directory

## Common Patterns

### Adding a New Plugin
1. Create file in `lua/custom/plugins/plugin-name.lua`
2. Return plugin spec table (auto-imported)
3. Run `:Lazy sync` to install

### LSP Configuration
- Servers defined in `lua/custom/plugins/lspconfig.lua`
- Add to `servers` table for auto-installation via Mason
- Capabilities extended by blink.cmp

### Formatting Setup
- Formatting via none-ls (null-ls fork)
- Configured in `lua/custom/plugins/none-ls.lua`
- Auto-format on save enabled by default
- Use `<leader>fbb` for manual format

## System Requirements
- Neovim stable (0.10+) or nightly (0.11+)
- git, make, unzip, C compiler
- ripgrep, fd-find for searching
- Node.js/npm for TypeScript LSP
- Optional: Nerd Font (set `vim.g.have_nerd_font = true`)

## Language-Specific Settings

### Swift
```lua
-- Configured in init.lua with auto-command
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
```

### TypeScript/JavaScript
- LSP: ts_ls (configured in lspconfig.lua)
- Formatting: prettierd (configured in none-ls.lua)
- Linting: eslint_d (configured in none-ls.lua)
- Testing: neotest-vitest (configured in neotest.lua)

## Important Notes for Agents

1. **Never modify `init.lua` unless absolutely necessary** - prefer adding plugins to `lua/custom/plugins/`
2. **Always run stylua before committing** - code must pass formatting checks
3. **Test in Neovim** - run `:checkhealth` after configuration changes
4. **Respect lazy loading** - don't break event-based loading strategies
5. **Preserve keymaps** - check existing keymaps before adding new ones (use `:WhichKey` or `<leader>?`)
6. **Document complex changes** - add comments explaining non-obvious configuration
7. **Version compatibility** - ensure changes work with both Neovim 0.10 (stable) and 0.11 (nightly)

## Troubleshooting

- Plugin not loading: Check `:Lazy` UI for errors
- LSP not working: Run `:LspInfo` and `:checkhealth lsp`
- Formatting issues: Check `:checkhealth null-ls` and ensure formatters are installed
- Keymaps not working: Use `:verbose map <keymap>` to check for conflicts
