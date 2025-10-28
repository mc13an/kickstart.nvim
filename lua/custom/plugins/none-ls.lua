return {
  -- none-ls
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim', 'nvimtools/none-ls-extras.nvim', 'davidmh/cspell.nvim' },
  config = function()
    local null_ls = require 'null-ls'
    local cspell = require 'cspell'

    null_ls.setup {
      debug = true, -- Enable debug mode to see what's happening
      sources = {

        -- Formatting
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.swiftlint,

        -- Diagnostics
        -- null_ls.builtins.diagnostics.swiftlint,
        require 'none-ls.diagnostics.eslint_d',
        -- Cspell spell checking
        cspell.diagnostics.with {
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
        },

        -- Code Actions
        require 'none-ls.code_actions.eslint_d',
        cspell.code_actions,
      },
    }

    vim.keymap.set('n', '<leader>fbb', vim.lsp.buf.format, {})

    -- Format on save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      pattern = '*',
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}
