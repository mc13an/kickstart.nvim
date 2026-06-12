return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'mason-org/mason.nvim', opts = {} },
    -- Maps LSP server names between nvim-lspconfig and Mason package names.
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim',    opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- Find references for the word under your cursor.
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      severity_sort = true,
      float = {
        border = 'rounded',
        source = 'if_many',
        wrap = true,
        max_width = 80,
      },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    ---@type table<string, vim.lsp.Config>
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      ts_ls = {},
      jsonls = {},
      -- GraphQL Language Server for schema-aware completions
      graphql = {
        filetypes = { 'gql', 'graphql', 'typescriptreact', 'javascriptreact', 'typescript', 'javascript' },
      },

      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { '(`.*?`)', '(".*?")', "('.*?')" },
              },
            },
          },
        },
      },

      stylua = {}, -- Used to format Lua code

      -- Special Lua Config, as recommended by neovim help docs
      lua_ls = {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
              --  See https://github.com/neovim/nvim-lspconfig/issues/3189
              library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }),
            },
          })
        end,
        settings = {
          Lua = {},
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'cspell',
      'prettierd',
      'eslint_d',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end

    local opts = { noremap = true, silent = true }

    -- Jump and show virtual line diagnostics for the current line
    -- from https://www.reddit.com/r/neovim/comments/1jm5atz/replacing_vimdiagnosticopen_float_with_virtual/
    local function jumpWithVirtLineDiagnostics(jumpCount)
      pcall(vim.api.nvim_del_augroup_by_name, 'jumpWithVirtLineDiags') -- prevent autocmd for repeated jumps

      vim.diagnostic.jump { count = jumpCount }

      local initialVirtTextConf = vim.diagnostic.config().virtual_text
      vim.diagnostic.config {
        virtual_text = false,
        virtual_lines = { current_line = true },
      }

      vim.defer_fn(function() -- deferred to not trigger by jump itself
        vim.api.nvim_create_autocmd('CursorMoved', {
          desc = 'User(once): Reset diagnostics virtual lines',
          once = true,
          group = vim.api.nvim_create_augroup('jumpWithVirtLineDiags', {}),
          callback = function()
            vim.diagnostic.config { virtual_lines = false, virtual_text = initialVirtTextConf }
          end,
        })
      end, 1)
    end

    vim.keymap.set('n', '[d', function()
      jumpWithVirtLineDiagnostics(-1)
    end, { desc = 'Previous diagnostic' })
    vim.keymap.set('n', ']d', function()
      jumpWithVirtLineDiagnostics(1)
    end, { desc = 'Next diagnostic' })

    vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<cr>', { desc = '[L]sp [R]estart' })

    opts.desc = 'Show line diagnostics'
    vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float, opts)

    opts.desc = 'Show documentation for what is under cursor'
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover {
        border = 'rounded',
      }
    end, opts)

    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = 'Show line diagnostics'
      vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float, opts)

      opts.desc = 'Show documentation for what is under cursor'
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

      opts.desc = 'Show LSP definition'
      vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions trim_text=true<cr>', opts)
    end
    vim.lsp.config.sourcekit = {
      cmd = { vim.trim(vim.fn.system 'xcrun -f sourcekit-lsp') },
      on_attach = on_attach,
      on_init = function(client)
        -- HACK: to fix some issues with LSP
        -- more details: https://github.com/neovim/neovim/issues/19237#issuecomment-2237037154
        client.offset_encoding = 'utf-8'
      end,
    }
    vim.lsp.enable 'sourcekit'
  end,
}
